import 'dart:io';

import 'package:flutter/foundation.dart';

/// True on Linux, Windows, and macOS — the platforms that get a real OS
/// window (and therefore a custom `WindowBar`). False on Android, iOS, and
/// web, where there's no window chrome to replace.
bool get isDesktopPlatform =>
    !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);
