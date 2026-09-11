import 'package:app_links/app_links.dart';
import 'package:ridge/core/router/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deep_link_providers.g.dart';

/// Whether [path] is the `/practice/:pathId/lessons/:lessonId` shape this
/// app currently understands from an external link — see
/// `LessonNavigation.shareableLessonUri` for the matching generator.
/// Deliberately an allow-list, not "forward whatever path arrives": most
/// other routes' builders read a required `extra` object
/// (`state.extra! as ...`, e.g. `/profile/edit`, `/practice/session`
/// itself) that a raw incoming link never carries, so forwarding an
/// arbitrary path to `router.go` would null-assert-crash instead of
/// failing safely.
bool isSupportedDeepLinkPath(String path) => _lessonLinkPattern.hasMatch(path);

final RegExp _lessonLinkPattern = RegExp(r'^/practice/[^/]+/lessons/[^/]+$');

/// Listens for incoming `ridge://` links, both while the app is already
/// running and the one that launched it cold (`getInitialLink`), and
/// forwards recognized ones to [appRouterProvider]'s `GoRouter` — fired
/// once at startup exactly like `catalogSeedProvider`/
/// `deviceInfoSyncProvider` (`content_providers.dart`/
/// `profile_providers.dart`), watched unconditionally in `RidgeApp.build`.
@Riverpod(keepAlive: true)
Future<void> deepLinkListener(Ref ref) async {
  final router = ref.read(appRouterProvider);
  final appLinks = AppLinks();

  void handleLink(Uri uri) {
    if (isSupportedDeepLinkPath(uri.path)) router.go(uri.path);
  }

  final subscription = appLinks.uriLinkStream.listen(handleLink);
  ref.onDispose(subscription.cancel);

  final initialLink = await appLinks.getInitialLink();
  if (initialLink != null) handleLink(initialLink);
}
