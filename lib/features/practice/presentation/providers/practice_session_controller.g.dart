// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives one practice session for a specific `Snippet` through
/// `idle -> running -> finished -> result` (SPEC.md §5.1-§5.3).
/// Parameterized (a Riverpod family) by the starting snippet and mode so
/// navigating to a new session always gets fresh state.
///
/// - **Zen**: no deadline, no accuracy gate. `running` starts on the
///   first keystroke; the session reaches `finished` the moment the
///   buffer reaches the expected snippet's length.
/// - **Sprint**: a countdown starts alongside `running`. Finishing the
///   current snippet before the countdown reaches zero advances to a new
///   same-difficulty snippet within the *same* session (seamless — no
///   `finished`/`idle` transition in between); the countdown reaching
///   zero force-finishes instead, dropping any character still pending
///   classification at that exact instant from the metrics input.
/// - **Precision**: shaped like Zen, but [FinishPracticeSessionUseCase]
///   evaluates the finished session's accuracy against the mode's
///   threshold. "Retry" ([retry]) is just a fresh `idle -> running` on
///   the same snippet, producing a brand-new immutable session row.
/// - **Survival**: a continuous same-difficulty stream exactly like
///   Sprint's, but with lives instead of a clock (SPEC.md §5.8). Every
///   rejected keystroke costs one life (tracked by
///   `SurvivalRunTracker`); the last life ends the run abruptly, exactly
///   like a natural finish — the fatal keystroke is still part of the
///   persisted log, it's simply rejected like any other mismatch.
///
/// Backgrounding freezes elapsed-time accounting (and, for Sprint, the
/// countdown); backgrounding for longer than [_abandonThreshold] discards
/// the in-progress buffer entirely (nothing is ever persisted for an
/// abandoned run).

@ProviderFor(PracticeSessionController)
final practiceSessionControllerProvider = PracticeSessionControllerFamily._();

/// Drives one practice session for a specific `Snippet` through
/// `idle -> running -> finished -> result` (SPEC.md §5.1-§5.3).
/// Parameterized (a Riverpod family) by the starting snippet and mode so
/// navigating to a new session always gets fresh state.
///
/// - **Zen**: no deadline, no accuracy gate. `running` starts on the
///   first keystroke; the session reaches `finished` the moment the
///   buffer reaches the expected snippet's length.
/// - **Sprint**: a countdown starts alongside `running`. Finishing the
///   current snippet before the countdown reaches zero advances to a new
///   same-difficulty snippet within the *same* session (seamless — no
///   `finished`/`idle` transition in between); the countdown reaching
///   zero force-finishes instead, dropping any character still pending
///   classification at that exact instant from the metrics input.
/// - **Precision**: shaped like Zen, but [FinishPracticeSessionUseCase]
///   evaluates the finished session's accuracy against the mode's
///   threshold. "Retry" ([retry]) is just a fresh `idle -> running` on
///   the same snippet, producing a brand-new immutable session row.
/// - **Survival**: a continuous same-difficulty stream exactly like
///   Sprint's, but with lives instead of a clock (SPEC.md §5.8). Every
///   rejected keystroke costs one life (tracked by
///   `SurvivalRunTracker`); the last life ends the run abruptly, exactly
///   like a natural finish — the fatal keystroke is still part of the
///   persisted log, it's simply rejected like any other mismatch.
///
/// Backgrounding freezes elapsed-time accounting (and, for Sprint, the
/// countdown); backgrounding for longer than [_abandonThreshold] discards
/// the in-progress buffer entirely (nothing is ever persisted for an
/// abandoned run).
final class PracticeSessionControllerProvider
    extends $NotifierProvider<PracticeSessionController, PracticeSessionState> {
  /// Drives one practice session for a specific `Snippet` through
  /// `idle -> running -> finished -> result` (SPEC.md §5.1-§5.3).
  /// Parameterized (a Riverpod family) by the starting snippet and mode so
  /// navigating to a new session always gets fresh state.
  ///
  /// - **Zen**: no deadline, no accuracy gate. `running` starts on the
  ///   first keystroke; the session reaches `finished` the moment the
  ///   buffer reaches the expected snippet's length.
  /// - **Sprint**: a countdown starts alongside `running`. Finishing the
  ///   current snippet before the countdown reaches zero advances to a new
  ///   same-difficulty snippet within the *same* session (seamless — no
  ///   `finished`/`idle` transition in between); the countdown reaching
  ///   zero force-finishes instead, dropping any character still pending
  ///   classification at that exact instant from the metrics input.
  /// - **Precision**: shaped like Zen, but [FinishPracticeSessionUseCase]
  ///   evaluates the finished session's accuracy against the mode's
  ///   threshold. "Retry" ([retry]) is just a fresh `idle -> running` on
  ///   the same snippet, producing a brand-new immutable session row.
  /// - **Survival**: a continuous same-difficulty stream exactly like
  ///   Sprint's, but with lives instead of a clock (SPEC.md §5.8). Every
  ///   rejected keystroke costs one life (tracked by
  ///   `SurvivalRunTracker`); the last life ends the run abruptly, exactly
  ///   like a natural finish — the fatal keystroke is still part of the
  ///   persisted log, it's simply rejected like any other mismatch.
  ///
  /// Backgrounding freezes elapsed-time accounting (and, for Sprint, the
  /// countdown); backgrounding for longer than [_abandonThreshold] discards
  /// the in-progress buffer entirely (nothing is ever persisted for an
  /// abandoned run).
  PracticeSessionControllerProvider._({
    required PracticeSessionControllerFamily super.from,
    required (Snippet, PracticeMode) super.argument,
  }) : super(
         retry: null,
         name: r'practiceSessionControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$practiceSessionControllerHash();

  @override
  String toString() {
    return r'practiceSessionControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PracticeSessionController create() => PracticeSessionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PracticeSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PracticeSessionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PracticeSessionControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$practiceSessionControllerHash() =>
    r'19c242f7c5036b7c6972d4ec01d0fa23958bb435';

/// Drives one practice session for a specific `Snippet` through
/// `idle -> running -> finished -> result` (SPEC.md §5.1-§5.3).
/// Parameterized (a Riverpod family) by the starting snippet and mode so
/// navigating to a new session always gets fresh state.
///
/// - **Zen**: no deadline, no accuracy gate. `running` starts on the
///   first keystroke; the session reaches `finished` the moment the
///   buffer reaches the expected snippet's length.
/// - **Sprint**: a countdown starts alongside `running`. Finishing the
///   current snippet before the countdown reaches zero advances to a new
///   same-difficulty snippet within the *same* session (seamless — no
///   `finished`/`idle` transition in between); the countdown reaching
///   zero force-finishes instead, dropping any character still pending
///   classification at that exact instant from the metrics input.
/// - **Precision**: shaped like Zen, but [FinishPracticeSessionUseCase]
///   evaluates the finished session's accuracy against the mode's
///   threshold. "Retry" ([retry]) is just a fresh `idle -> running` on
///   the same snippet, producing a brand-new immutable session row.
/// - **Survival**: a continuous same-difficulty stream exactly like
///   Sprint's, but with lives instead of a clock (SPEC.md §5.8). Every
///   rejected keystroke costs one life (tracked by
///   `SurvivalRunTracker`); the last life ends the run abruptly, exactly
///   like a natural finish — the fatal keystroke is still part of the
///   persisted log, it's simply rejected like any other mismatch.
///
/// Backgrounding freezes elapsed-time accounting (and, for Sprint, the
/// countdown); backgrounding for longer than [_abandonThreshold] discards
/// the in-progress buffer entirely (nothing is ever persisted for an
/// abandoned run).

final class PracticeSessionControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PracticeSessionController,
          PracticeSessionState,
          PracticeSessionState,
          PracticeSessionState,
          (Snippet, PracticeMode)
        > {
  PracticeSessionControllerFamily._()
    : super(
        retry: null,
        name: r'practiceSessionControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Drives one practice session for a specific `Snippet` through
  /// `idle -> running -> finished -> result` (SPEC.md §5.1-§5.3).
  /// Parameterized (a Riverpod family) by the starting snippet and mode so
  /// navigating to a new session always gets fresh state.
  ///
  /// - **Zen**: no deadline, no accuracy gate. `running` starts on the
  ///   first keystroke; the session reaches `finished` the moment the
  ///   buffer reaches the expected snippet's length.
  /// - **Sprint**: a countdown starts alongside `running`. Finishing the
  ///   current snippet before the countdown reaches zero advances to a new
  ///   same-difficulty snippet within the *same* session (seamless — no
  ///   `finished`/`idle` transition in between); the countdown reaching
  ///   zero force-finishes instead, dropping any character still pending
  ///   classification at that exact instant from the metrics input.
  /// - **Precision**: shaped like Zen, but [FinishPracticeSessionUseCase]
  ///   evaluates the finished session's accuracy against the mode's
  ///   threshold. "Retry" ([retry]) is just a fresh `idle -> running` on
  ///   the same snippet, producing a brand-new immutable session row.
  /// - **Survival**: a continuous same-difficulty stream exactly like
  ///   Sprint's, but with lives instead of a clock (SPEC.md §5.8). Every
  ///   rejected keystroke costs one life (tracked by
  ///   `SurvivalRunTracker`); the last life ends the run abruptly, exactly
  ///   like a natural finish — the fatal keystroke is still part of the
  ///   persisted log, it's simply rejected like any other mismatch.
  ///
  /// Backgrounding freezes elapsed-time accounting (and, for Sprint, the
  /// countdown); backgrounding for longer than [_abandonThreshold] discards
  /// the in-progress buffer entirely (nothing is ever persisted for an
  /// abandoned run).

  PracticeSessionControllerProvider call(Snippet snippet, PracticeMode mode) =>
      PracticeSessionControllerProvider._(
        argument: (snippet, mode),
        from: this,
      );

  @override
  String toString() => r'practiceSessionControllerProvider';
}

/// Drives one practice session for a specific `Snippet` through
/// `idle -> running -> finished -> result` (SPEC.md §5.1-§5.3).
/// Parameterized (a Riverpod family) by the starting snippet and mode so
/// navigating to a new session always gets fresh state.
///
/// - **Zen**: no deadline, no accuracy gate. `running` starts on the
///   first keystroke; the session reaches `finished` the moment the
///   buffer reaches the expected snippet's length.
/// - **Sprint**: a countdown starts alongside `running`. Finishing the
///   current snippet before the countdown reaches zero advances to a new
///   same-difficulty snippet within the *same* session (seamless — no
///   `finished`/`idle` transition in between); the countdown reaching
///   zero force-finishes instead, dropping any character still pending
///   classification at that exact instant from the metrics input.
/// - **Precision**: shaped like Zen, but [FinishPracticeSessionUseCase]
///   evaluates the finished session's accuracy against the mode's
///   threshold. "Retry" ([retry]) is just a fresh `idle -> running` on
///   the same snippet, producing a brand-new immutable session row.
/// - **Survival**: a continuous same-difficulty stream exactly like
///   Sprint's, but with lives instead of a clock (SPEC.md §5.8). Every
///   rejected keystroke costs one life (tracked by
///   `SurvivalRunTracker`); the last life ends the run abruptly, exactly
///   like a natural finish — the fatal keystroke is still part of the
///   persisted log, it's simply rejected like any other mismatch.
///
/// Backgrounding freezes elapsed-time accounting (and, for Sprint, the
/// countdown); backgrounding for longer than [_abandonThreshold] discards
/// the in-progress buffer entirely (nothing is ever persisted for an
/// abandoned run).

abstract class _$PracticeSessionController
    extends $Notifier<PracticeSessionState> {
  late final _$args = ref.$arg as (Snippet, PracticeMode);
  Snippet get snippet => _$args.$1;
  PracticeMode get mode => _$args.$2;

  PracticeSessionState build(Snippet snippet, PracticeMode mode);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PracticeSessionState, PracticeSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PracticeSessionState, PracticeSessionState>,
              PracticeSessionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
