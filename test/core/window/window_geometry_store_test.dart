import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/window/window_geometry_store.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('load returns null before anything has ever been saved', () async {
    final result = await WindowGeometryStore().load();

    expect(result, isNull);
  });

  test('saveBounds then load round-trips the exact bounds, defaulting '
      'isMaximized to false', () async {
    final store = WindowGeometryStore();

    await store.saveBounds(x: 12, y: 34, width: 1024, height: 768);
    final result = await store.load();

    expect(result, isNotNull);
    expect(result!.x, 12);
    expect(result.y, 34);
    expect(result.width, 1024);
    expect(result.height, 768);
    expect(result.isMaximized, isFalse);
  });

  test('saveIsMaximized persists independently of the saved bounds', () async {
    final store = WindowGeometryStore();
    await store.saveBounds(x: 0, y: 0, width: 1280, height: 800);

    await store.saveIsMaximized(isMaximized: true);

    final result = await store.load();
    expect(result!.isMaximized, isTrue);
    expect(result.width, 1280);
  });
}
