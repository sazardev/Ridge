import 'package:flutter/foundation.dart';

/// Lets any part of the app draw attention to the window bar — e.g. before
/// blocking a close with an "unsaved changes" dialog. Bumping [shakeTick]
/// is the only API; [WindowBar] listens and replays its shake animation
/// every time the value changes.
class WindowBarController extends ValueNotifier<int> {
  WindowBarController() : super(0);

  void shake() => value++;
}
