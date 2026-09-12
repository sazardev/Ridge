import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/practice/presentation/services/keystroke_sound_player.dart';
import 'package:ridge/features/settings/domain/entities/app_sound_pack.dart';

/// An opaque stand-in for a loaded SoLoud clip — the player never inspects
/// the handle, so identity is all a fake needs to provide.
class _FakeClip implements KeystrokeSoundClip;

void main() {
  group('KeystrokeSoundPlayer', () {
    test('loads each clip once and fires one voice per keystroke', () async {
      final loaded = <String>[];
      final played = <KeystrokeSoundClip>[];
      final player = KeystrokeSoundPlayer(
        AppSoundPack.soft,
        load: (asset) async {
          loaded.add(asset);
          return _FakeClip();
        },
        play: played.add,
        disposeClip: (_) async {},
      );
      addTearDown(player.dispose);

      for (var i = 0; i < 5; i++) {
        unawaited(player.playClick());
        unawaited(player.playReject());
      }
      await pumpEventQueue();

      expect(loaded, [
        'assets/sounds/soft/key_click.wav',
        'assets/sounds/soft/key_reject.wav',
      ]);
      expect(
        played,
        hasLength(10),
        reason: 'five clicks plus five rejects, none dropped or deduplicated',
      );
    });

    test('queues playback until the clips finish loading', () async {
      final click = Completer<KeystrokeSoundClip?>();
      final played = <KeystrokeSoundClip>[];
      final player = KeystrokeSoundPlayer(
        AppSoundPack.soft,
        load: (asset) => asset.contains('key_click')
            ? click.future
            : Future<KeystrokeSoundClip?>.value(_FakeClip()),
        play: played.add,
        disposeClip: (_) async {},
      );
      addTearDown(player.dispose);

      unawaited(player.playClick());
      await pumpEventQueue();
      expect(played, isEmpty, reason: 'the click clip is still loading');

      final clip = _FakeClip();
      click.complete(clip);
      await pumpEventQueue();

      expect(played, [clip]);
    });

    test('keeps the clip that loaded when the other one fails', () async {
      final played = <KeystrokeSoundClip>[];
      final disposed = <KeystrokeSoundClip>[];
      final player = KeystrokeSoundPlayer(
        AppSoundPack.soft,
        load: (asset) async {
          if (asset.contains('key_reject')) {
            throw Exception('audio backend unavailable');
          }
          return _FakeClip();
        },
        play: played.add,
        disposeClip: (clip) async => disposed.add(clip),
      );
      addTearDown(player.dispose);

      unawaited(player.playReject());
      unawaited(player.playClick());
      await pumpEventQueue();

      expect(played, hasLength(1), reason: 'reject stayed silent, click got');

      player.dispose();
      await pumpEventQueue();
      expect(disposed, hasLength(1), reason: 'only the loaded clip is owned');
    });

    test('disposes clips that finish loading after dispose', () async {
      final click = Completer<KeystrokeSoundClip?>();
      final reject = Completer<KeystrokeSoundClip?>();
      final disposed = <KeystrokeSoundClip>[];
      final player = KeystrokeSoundPlayer(
        AppSoundPack.soft,
        load: (asset) =>
            asset.contains('key_click') ? click.future : reject.future,
        play: (_) {},
        disposeClip: (clip) async => disposed.add(clip),
      );

      // Deliberately a lone call: dispose must run while both loads are
      // still in flight, so there is nothing to cascade it onto.
      // ignore: cascade_invocations
      player.dispose();

      final clickClip = _FakeClip();
      final rejectClip = _FakeClip();
      click.complete(clickClip);
      reject.complete(rejectClip);
      await pumpEventQueue();

      expect(disposed, [
        clickClip,
        rejectClip,
      ], reason: "a pack switch must not leak the previous pack's clips");
    });

    test('swallows playback and cleanup failures', () async {
      final player = KeystrokeSoundPlayer(
        AppSoundPack.arcade,
        load: (_) async => _FakeClip(),
        play: (_) => throw Exception('device gone'),
        disposeClip: (_) async => throw Exception('device gone'),
      );
      addTearDown(player.dispose);

      await player.playClick();
      await player.playReject();
      player.dispose();
      await pumpEventQueue();
    });

    test('the silent variant never touches a backend', () async {
      final player = KeystrokeSoundPlayer.silent(AppSoundPack.mechanical);

      await player.playClick();
      await player.playReject();
      // Disposing twice must stay safe.
      player
        ..dispose()
        ..dispose();
    });
  });
}
