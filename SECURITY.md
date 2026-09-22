# Security Policy

## Supported versions

Ridge doesn't yet have a public 1.0/stable line with parallel maintenance
branches — trunk-based development on `main` (see `STACK.md §10.4`), tagged
releases (`vX.Y.Z`). Only the latest tagged release is supported; please
upgrade before reporting an issue that might already be fixed.

## Reporting a vulnerability

**Please do not open a public GitHub issue for a security vulnerability.**

Instead, email **omar.desarrollo@gmtransporterp.com** with:

- A description of the vulnerability and its potential impact.
- Steps to reproduce it (a minimal repro is very helpful).
- The affected version/commit and platform (Android/Linux/Windows/Web).

You should get an acknowledgment within a few days. Once a fix is
confirmed, we'll coordinate a disclosure timeline with you before any public
write-up, and credit you in the release notes unless you'd prefer to stay
anonymous.

## Scope

Ridge is **offline-first**; as of this writing there is no Supabase/auth
backend deployed yet (see `Memory.md`'s "Estado actual" for the current
implementation status) — the current attack surface is local: the
`flutter_secure_storage`-backed PIN app-lock, on-device `drift`/SQLite data,
and the on-device "content pack" JSON loader
(`lib/core/content_packs/`). Once the online backend (auth, duels, squads,
sync — `STACK.md §5`–`§6`) ships, this policy's scope extends to it and to
the Supabase project configuration (RLS policies, Edge Functions) — that
work isn't live yet, so please hold reports about it until it is, unless
you're pointing out a design gap in `SPEC.md`/`STACK.md` itself.

Out of scope: vulnerabilities that require a rooted/jailbroken device, a
compromised OS keychain/secret-service, or physical access to an unlocked
device.
