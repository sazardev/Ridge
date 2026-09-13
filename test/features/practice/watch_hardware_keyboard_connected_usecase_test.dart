// Unit test for `WatchHardwareKeyboardConnectedUseCase` — a thin
// pass-through over `HardwareKeyboardRepository.watchConnected()`, so the
// only thing worth pinning down is that it forwards the stream unchanged
// (mirrors `get_next_sprint_snippet_usecase_test.dart`'s hand-fake-port
// pattern).
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/practice/application/usecases/watch_hardware_keyboard_connected_usecase.dart';
import 'package:ridge/features/practice/domain/repositories/hardware_keyboard_repository.dart';

class _FakeHardwareKeyboardRepository implements HardwareKeyboardRepository {
  new(this._values);

  final List<bool> _values;

  @override
  Stream<bool> watchConnected() => Stream.fromIterable(_values);
}

void main() {
  test("forwards the repository's connected stream unchanged", () async {
    final repository = _FakeHardwareKeyboardRepository([false, true, false]);
    final useCase = WatchHardwareKeyboardConnectedUseCase(repository);

    expect(await useCase().toList(), [false, true, false]);
  });
}
