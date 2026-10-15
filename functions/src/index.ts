// Ridge's account Cloud Functions (SPEC.md §7.2, STACK.md §5.2). Three
// operations that need the Admin SDK and therefore can't live in the
// client:
//
//  - register:       validates username uniqueness, creates the Firebase
//                    Auth user behind the internal synthetic email,
//                    writes the public profile and mints the one-time
//                    recovery code (returned in clear exactly once).
//  - recoverAccount: verifies the recovery code, sets the new password
//                    and rotates the code.
//  - deleteAccount:  the store-required in-app deletion path.
//
// The Flutter client invokes these through the callable HTTPS protocol
// (see `callable_functions_client.dart`). No email is ever sent and no
// personal data is ever stored — the synthetic <username>@users.ridge.internal
// address is an internal identifier only.
import { createHash, randomBytes, randomInt, timingSafeEqual } from "node:crypto";

import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

initializeApp();

/** Must match `accountFunctionsRegion` in the Flutter app. */
const REGION = "southamerica-east1";

/** Must match `AccountUsername` in the Flutter domain. */
const USERNAME_PATTERN = /^[a-z0-9](?:[a-z0-9_.-]*[a-z0-9])?$/;
const USERNAME_MIN = 3;
const USERNAME_MAX = 24;

/** Must match `AccountPassword` in the Flutter domain. */
const PASSWORD_MIN = 8;
const PASSWORD_MAX = 100;

/** Must match `FirebaseAccountRepository.syntheticEmailDomain`. */
const SYNTHETIC_EMAIL_DOMAIN = "users.ridge.internal";

/** Crockford-style alphabet: no I, L, O, 0 or 1 — nothing mistakable. */
const CODE_ALPHABET = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";
const CODE_LENGTH = 20;

const INVALID_USERNAME_MESSAGE =
  `Username must be ${USERNAME_MIN}-${USERNAME_MAX} characters: letters, ` +
  "digits, dots, dashes or underscores, starting and ending with a letter or digit";
const INVALID_PASSWORD_MESSAGE =
  `Password must be between ${PASSWORD_MIN} and ${PASSWORD_MAX} characters`;
const USERNAME_TAKEN_MESSAGE = "That username is already taken";
const INVALID_RECOVERY_MESSAGE = "Invalid recovery code";

function syntheticEmail(username: string): string {
  return `${username}@${SYNTHETIC_EMAIL_DOMAIN}`;
}

/** The canonical form of a recovery code: no grouping, no lowercase. */
function normalizeRecoveryCode(raw: string): string {
  return raw.toUpperCase().replace(/[^A-Z0-9]/g, "");
}

function generateRecoveryCode(): string {
  let raw = "";
  for (let i = 0; i < CODE_LENGTH; i += 1) {
    raw += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
  }
  return raw.replace(/(.{5})(?=.)/g, "$1-");
}

function hashRecoveryCode(code: string, salt: string): string {
  return createHash("sha256").update(`${salt}:${code}`).digest("hex");
}

function parseUsername(data: unknown): string {
  const raw =
    typeof (data as { username?: unknown })?.username === "string"
      ? ((data as { username: string }).username as string).trim().toLowerCase()
      : "";
  if (
    raw.length < USERNAME_MIN ||
    raw.length > USERNAME_MAX ||
    !USERNAME_PATTERN.test(raw)
  ) {
    throw new HttpsError("invalid-argument", INVALID_USERNAME_MESSAGE);
  }
  return raw;
}

function parsePassword(raw: unknown): string {
  const password = typeof raw === "string" ? raw : "";
  if (password.length < PASSWORD_MIN || password.length > PASSWORD_MAX) {
    throw new HttpsError("invalid-argument", INVALID_PASSWORD_MESSAGE);
  }
  return password;
}

/**
 * Creates a Registered Account: the auth user, the uniqueness record,
 * the public profile document and the one-time recovery code. Returns
 * `{ uid, username, recoveryCode, createdAt }` — the code in clear only
 * here, only once.
 */
export const register = onCall({ region: REGION }, async (request) => {
  const username = parseUsername(request.data);
  const password = parsePassword(
    (request.data as { password?: unknown })?.password,
  );

  const db = getFirestore();
  const usernameRef = db.collection("usernames").doc(username);
  if ((await usernameRef.get()).exists) {
    throw new HttpsError("already-exists", USERNAME_TAKEN_MESSAGE);
  }

  const auth = getAuth();
  let user;
  try {
    user = await auth.createUser({ email: syntheticEmail(username), password });
  } catch (error) {
    if ((error as { code?: string }).code === "auth/email-already-in-use") {
      throw new HttpsError("already-exists", USERNAME_TAKEN_MESSAGE);
    }
    throw new HttpsError("internal", "Could not create the account");
  }

  const recoveryCode = generateRecoveryCode();
  const salt = randomBytes(16).toString("hex");
  try {
    await db.runTransaction(async (transaction) => {
      const current = await transaction.get(usernameRef);
      if (current.exists) {
        throw new HttpsError("already-exists", USERNAME_TAKEN_MESSAGE);
      }
      transaction.create(usernameRef, {
        uid: user.uid,
        createdAt: FieldValue.serverTimestamp(),
      });
      transaction.create(db.collection("profiles").doc(user.uid), {
        username,
        normalizedUsername: username,
        createdAt: FieldValue.serverTimestamp(),
      });
      transaction.create(db.collection("recoveryCodes").doc(user.uid), {
        hash: hashRecoveryCode(normalizeRecoveryCode(recoveryCode), salt),
        salt,
        createdAt: FieldValue.serverTimestamp(),
      });
    });
  } catch (error) {
    // A lost uniqueness race: clean the orphaned auth user up so nothing
    // half-registered is left behind.
    await auth.deleteUser(user.uid).catch(() => undefined);
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Could not create the account");
  }

  return {
    uid: user.uid,
    username,
    recoveryCode,
    createdAt: new Date().toISOString(),
  };
});

/**
 * Recovers an account with its one-time code: verifies the code, sets
 * the new password and rotates the recovery code, returning the new one
 * in clear exactly once.
 */
export const recoverAccount = onCall({ region: REGION }, async (request) => {
  const username = parseUsername(request.data);
  const recoveryCode = normalizeRecoveryCode(
    typeof (request.data as { recoveryCode?: unknown })?.recoveryCode ===
      "string"
      ? ((request.data as { recoveryCode: string }).recoveryCode as string)
      : "",
  );
  if (recoveryCode.length !== CODE_LENGTH) {
    throw new HttpsError("permission-denied", INVALID_RECOVERY_MESSAGE);
  }
  const newPassword = parsePassword(
    (request.data as { newPassword?: unknown })?.newPassword,
  );

  const db = getFirestore();
  const usernameDoc = await db.collection("usernames").doc(username).get();
  if (!usernameDoc.exists) {
    throw new HttpsError("not-found", "No account with that username");
  }
  const uid = usernameDoc.get("uid") as string;

  const recoveryDoc = await db.collection("recoveryCodes").doc(uid).get();
  const storedHash = recoveryDoc.get("hash") as string | undefined;
  const salt = recoveryDoc.get("salt") as string | undefined;
  if (!recoveryDoc.exists || !storedHash || !salt) {
    throw new HttpsError("permission-denied", INVALID_RECOVERY_MESSAGE);
  }
  const candidate = hashRecoveryCode(recoveryCode, salt);
  const matches = timingSafeEqual(
    Buffer.from(candidate, "hex"),
    Buffer.from(storedHash, "hex"),
  );
  if (!matches) {
    throw new HttpsError("permission-denied", INVALID_RECOVERY_MESSAGE);
  }

  await getAuth().updateUser(uid, { password: newPassword });

  const newCode = generateRecoveryCode();
  const newSalt = randomBytes(16).toString("hex");
  await db.collection("recoveryCodes").doc(uid).set({
    hash: hashRecoveryCode(normalizeRecoveryCode(newCode), newSalt),
    salt: newSalt,
    createdAt: FieldValue.serverTimestamp(),
  });

  return { recoveryCode: newCode };
});

/**
 * Permanently deletes the signed-in account: the auth user, the public
 * profile, the recovery record and the username reservation.
 */
export const deleteAccount = onCall({ region: REGION }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Sign in first");
  }

  const db = getFirestore();
  const profileDoc = await db.collection("profiles").doc(uid).get();
  const normalizedUsername = profileDoc.get("normalizedUsername") as
    | string
    | undefined;

  await getAuth().deleteUser(uid);

  const batch = db.batch();
  batch.delete(db.collection("profiles").doc(uid));
  batch.delete(db.collection("recoveryCodes").doc(uid));
  if (normalizedUsername) {
    batch.delete(db.collection("usernames").doc(normalizedUsername));
  }
  await batch.commit();

  return { deleted: true };
});
