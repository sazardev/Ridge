// Exercises the profile feature's full stack — usecases, repository,
// DAO, and the shared `AppDatabase` — against a *real* in-memory drift
// (SQLite) database, not a hand-fake repository. This is the one place
// this phase's drift+riverpod plumbing gets proven end-to-end: table
// creation via the default migration, a row actually round-tripping
// through SQL, and the reactive `.watch()` stream picking up writes
// without any manual refresh.
import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late StreamController<GuestProfile?> profileUpdates;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    // LIFO teardown: dispose the container (cancels its drift
    // subscriptions) before closing the underlying database connection.
    addTearDown(() => database.close());
    addTearDown(container.dispose);

    // Riverpod only pumps a StreamNotifier's underlying subscription while
    // something is actively watching/listening to it — `.read`/`.future`
    // alone never subscribes. In the real app this listener is
    // `_RouterRefreshNotifier` (via `hasGuestProfileProvider`); here we
    // stand in for it, and fan every emission out onto a plain broadcast
    // stream so tests can `firstWhere` the specific update they expect
    // after a mutation instead of racing `.future`'s cached snapshot.
    profileUpdates = StreamController<GuestProfile?>.broadcast();
    addTearDown(profileUpdates.close);
    container.listen(activeProfileControllerProvider, (_, next) {
      if (next.hasValue) profileUpdates.add(next.value);
    });
  });

  test(
    'no profile yet: watch resolves to null and hasGuestProfile is false',
    () async {
      final initial = await container.read(
        activeProfileControllerProvider.future,
      );
      expect(initial, isNull);
      expect(container.read(hasGuestProfileProvider), isFalse);
    },
  );

  test('creating a Guest Profile writes through drift and the reactive '
      'stream + hasGuestProfile flip without a manual refresh', () async {
    final nextUpdate = profileUpdates.stream
        .firstWhere((p) => p?.username == 'nova')
        .timeout(const Duration(seconds: 5));

    final createResult = await container
        .read(activeProfileControllerProvider.notifier)
        .create('nova');
    expect(createResult.isOk, isTrue);
    final created = createResult.valueOrNull;
    expect(created, isNotNull);
    expect(created!.username, 'nova');

    // Prove the write actually landed in SQLite: query the DAO fresh,
    // independent of the riverpod-cached stream value above.
    final row = await container
        .read(guestProfileDaoProvider)
        .getActiveProfile();
    expect(row, isNotNull);
    expect(row!.username, 'nova');
    expect(row.id, created.id.value);

    // The reactive stream (drift watch -> repository -> usecase ->
    // controller) reflects the write without any manual refresh.
    final afterCreate = await nextUpdate;
    expect(afterCreate?.username, 'nova');
    expect(container.read(hasGuestProfileProvider), isTrue);
  });

  test('a second Guest Profile is rejected — single row per install', () async {
    await container
        .read(activeProfileControllerProvider.notifier)
        .create('nova');

    final second = await container
        .read(activeProfileControllerProvider.notifier)
        .create('impostor');
    expect(second.isErr, isTrue);

    final row = await container
        .read(guestProfileDaoProvider)
        .getActiveProfile();
    expect(row?.username, 'nova');
  });

  test('renaming persists through drift and the stream updates', () async {
    await container
        .read(activeProfileControllerProvider.notifier)
        .create('nova');

    final nextUpdate = profileUpdates.stream
        .firstWhere((p) => p?.username == 'nova-renamed')
        .timeout(const Duration(seconds: 5));

    final renameResult = await container
        .read(activeProfileControllerProvider.notifier)
        .rename('nova-renamed');
    expect(renameResult.isOk, isTrue);

    final afterRename = await nextUpdate;
    expect(afterRename?.username, 'nova-renamed');

    final row = await container
        .read(guestProfileDaoProvider)
        .getActiveProfile();
    expect(row?.username, 'nova-renamed');
  });

  test(
    'CreateGuestProfileUseCase rejects a blank username before writing',
    () async {
      final result = await container.read(createGuestProfileUseCaseProvider)(
        '   ',
      );
      expect(result.isErr, isTrue);

      final row = await container
          .read(guestProfileDaoProvider)
          .getActiveProfile();
      expect(row, isNull);
    },
  );
}
