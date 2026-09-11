// `isSupportedDeepLinkPath` is the allow-list guarding an incoming
// `ridge://` link before it's ever handed to `GoRouter.go` — most other
// routes' builders read a required `extra` object a raw link never
// carries, so anything not on this list must be rejected rather than
// forwarded.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/router/deep_link_providers.dart';

void main() {
  group('isSupportedDeepLinkPath', () {
    test('accepts a lesson link path', () {
      expect(
        isSupportedDeepLinkPath(
          '/practice/go-foundations-v1/lessons/go-foundations-v1-04',
        ),
        isTrue,
      );
    });

    test('rejects routes whose builder requires an extra object', () {
      expect(isSupportedDeepLinkPath('/practice/session'), isFalse);
      expect(isSupportedDeepLinkPath('/profile/edit'), isFalse);
    });

    test('rejects a path missing the lesson segment', () {
      expect(isSupportedDeepLinkPath('/practice'), isFalse);
      expect(isSupportedDeepLinkPath('/practice/go-foundations-v1'), isFalse);
      expect(
        isSupportedDeepLinkPath('/practice/go-foundations-v1/lessons/'),
        isFalse,
      );
    });
  });
}
