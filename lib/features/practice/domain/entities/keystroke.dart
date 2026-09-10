import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/entities/keyboard_row.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

part 'keystroke.freezed.dart';

/// One captured, classified event during a practice session — either a
/// forward-typed character or a correction (backspace), per SPEC.md
/// §4.1. Every keystroke — forward or correction — gets its own
/// [sequenceIndex] in an append-only log; nothing is ever rewritten once
/// emitted.
@freezed
abstract class Keystroke with _$Keystroke {
  /// Creates an immutable classified keystroke.
  const factory({
    required PhysicalKeyId physicalKeyId,
    required KeystrokeResult result,
    required bool isCorrection,
    required Finger finger,
    required KeyboardRow keyboardRow,
    required int sequenceIndex,
    String? expectedChar,
    String? actualChar,
    Duration? dwell,
    Duration? flight,
  }) = _Keystroke;
}
