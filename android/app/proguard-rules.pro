# Project-specific R8/ProGuard rules for the release build type
# (isMinifyEnabled/isShrinkResources, see android/app/build.gradle.kts).
#
# The Flutter Gradle plugin injects its own keep-rules for the engine
# embedding automatically. Every plugin currently in pubspec.yaml (drift,
# sqlite3_flutter_libs, flutter_secure_storage, local_auth, share_plus,
# app_links, device_info_plus, package_info_plus, path_provider,
# audioplayers) ships its own consumer ProGuard rules bundled in its AAR,
# so nothing extra is needed today.
#
# Add a rule here only if a release build crashes with a
# ClassNotFoundException/NoSuchMethodError that the debug build doesn't
# hit — that is the signature of R8 stripping something a plugin needs at
# runtime via reflection/JNI that its own consumer rules didn't cover.
