import 'package:flutter/scheduler.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_customization_geometry.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_scene_effects.dart';

/// Owns the two live lighting layers of the keyboard visual that outlive a
/// single pointer gesture: the per-key press levels driven by the *real*
/// keyboard (each held key sinks its matching cap) and the reactive
/// flashes (1 decaying to 0) fired by clicks and keystrokes. A single
/// ticker advances both and stops itself the moment nothing is moving, so
/// a board nobody is touching costs zero frames.
class KeyboardKeyEffects {
  /// Creates the effect state; [onFrame] is called after every advancing
  /// tick so the owner can repaint.
  new({required TickerProvider vsync, required this.onFrame}) {
    _ticker = vsync.createTicker(_onTick);
  }

  /// Called whenever a tick changed something.
  final VoidCallback onFrame;

  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  /// Current press level (0..1) per key index, driven by the real
  /// keyboard.
  final Map<int, double> levelsByIndex = {};

  /// Target (1 while held, 0 while released) for each key index the real
  /// keyboard has touched.
  final Map<int, double> targetsByIndex = {};

  /// Reactive flash (1 decaying to 0) per key index.
  final Map<int, double> pulsesByIndex = {};

  /// Age (seconds) of every active ripple, indexed by its origin key —
  /// the expanding splash ring of `RgbEffect.ripple`.
  final Map<int, double> ripplesByOrigin = {};

  /// Fires a reactive flash for [index] — a click or a keystroke. Also
  /// spawns the ripple ring from that key; the scene only draws it in
  /// ripple mode, so this costs nothing otherwise.
  void pulse(int index) {
    pulsesByIndex[index] = 1;
    ripplesByOrigin[index] = 0;
    _ensureRunning();
  }

  /// Reconciles the currently held [pressed] `PhysicalKeyId.name`s against
  /// [baseKeys] — position-based via the printed legends, so a functional
  /// remap never moves the reaction to another cap. Newly pressed keys
  /// also get a flash, so typing on the real board lights it up in every
  /// RGB mode.
  void syncExternal(Set<String> pressed, List<KeyboardKeySpec> baseKeys) {
    var needsTick = false;
    for (var i = 0; i < baseKeys.length; i++) {
      final legend = baseKeys[i].label;
      final name = legend == null ? null : physicalKeyNameForLegend(legend);
      final target = (name != null && pressed.contains(name)) ? 1.0 : 0.0;
      if ((targetsByIndex[i] ?? 0) != target) {
        targetsByIndex[i] = target;
        levelsByIndex.putIfAbsent(i, () => 0);
        needsTick = true;
        if (target == 1) pulse(i);
      }
    }
    if (needsTick || pulsesByIndex.isNotEmpty) _ensureRunning();
  }

  /// The press levels aligned with a key list of [length].
  List<double> levels(int length) => [
    for (var i = 0; i < length; i++) levelsByIndex[i] ?? 0,
  ];

  /// The reactive flashes aligned with a key list of [length].
  List<double> pulses(int length) => [
    for (var i = 0; i < length; i++) pulsesByIndex[i] ?? 0,
  ];

  /// The active ripple ages aligned with a key list of [length] (0 = no
  /// ripple originating there).
  List<double> ripples(int length) => [
    for (var i = 0; i < length; i++) ripplesByOrigin[i] ?? 0,
  ];

  /// Drops every level/flash — the painted keys are about to change
  /// shape/order, so stale indexes would light the wrong caps.
  void reset() {
    levelsByIndex.clear();
    targetsByIndex.clear();
    pulsesByIndex.clear();
    ripplesByOrigin.clear();
  }

  /// Disposes the ticker.
  void dispose() {
    _ticker.dispose();
  }

  void _ensureRunning() {
    if (!_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    if (dt <= 0) return;
    var active = false;

    for (final index in targetsByIndex.keys.toList()) {
      final target = targetsByIndex[index]!;
      final current = levelsByIndex[index] ?? 0;
      final speed = target > current ? 14.0 : 7.0;
      var next = current + (target > current ? speed : -speed) * dt;
      if (target > current && next > target) next = target;
      if (target < current && next < target) next = target;
      if (next == target) {
        if (target == 0) {
          levelsByIndex.remove(index);
          targetsByIndex.remove(index);
        } else {
          levelsByIndex[index] = next;
        }
      } else {
        levelsByIndex[index] = next;
        active = true;
      }
    }

    for (final index in pulsesByIndex.keys.toList()) {
      final next = pulsesByIndex[index]! - dt * 1.5;
      if (next <= 0) {
        pulsesByIndex.remove(index);
      } else {
        pulsesByIndex[index] = next;
        active = true;
      }
    }

    for (final origin in ripplesByOrigin.keys.toList()) {
      final next = ripplesByOrigin[origin]! + dt;
      if (next > rippleLifetimeSeconds) {
        ripplesByOrigin.remove(origin);
      } else {
        ripplesByOrigin[origin] = next;
        active = true;
      }
    }

    onFrame();
    if (!active) {
      _ticker.stop();
      _lastTick = Duration.zero;
    }
  }
}
