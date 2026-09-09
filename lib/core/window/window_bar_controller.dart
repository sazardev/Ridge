import 'package:flutter/foundation.dart';

/// Lets any part of the app draw attention to the window bar — e.g. before
/// blocking a close with an "unsaved changes" dialog. Calling [shake] is
/// the only API; `WindowBar` listens for the value change and replays its
/// shake animation every time it fires.
class WindowBarController extends ValueNotifier<int> {
  /// Creates the controller, idle until [shake] is called.
  new() : super(0);

  /// Triggers the window bar's attention-shake animation.
  void shake() => value++;
}
