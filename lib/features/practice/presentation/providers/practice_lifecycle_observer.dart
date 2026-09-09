part of 'practice_session_controller.dart';

/// Forwards app-lifecycle changes to a plain callback so
/// [PracticeSessionController] (which can't itself extend
/// [WidgetsBindingObserver] — it already extends the generated Riverpod
/// notifier base) can react to backgrounding.
class _PracticeLifecycleObserver extends WidgetsBindingObserver {
  new(this._onChange);

  final void Function(AppLifecycleState state) _onChange;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => _onChange(state);
}
