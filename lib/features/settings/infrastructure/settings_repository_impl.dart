import 'dart:async';

import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/domain/repositories/settings_repository.dart';
import 'package:just_in_time/features/settings/infrastructure/settings_local_data_source.dart';
import 'package:just_in_time/features/settings/infrastructure/settings_mapper.dart';

/// Local-storage adapter for [SettingsRepository]. Keeps an in-memory
/// current value so late subscribers immediately receive it — a broadcast
/// stream alone wouldn't replay anything to a listener that joins after
/// the last emission.
class SettingsRepositoryImpl implements SettingsRepository {
  /// Creates the adapter and immediately starts hydrating from storage.
  new(this._dataSource) {
    _controller = StreamController<AppSettings>.broadcast(
      onListen: () => _controller.add(_current),
    );
    unawaited(_hydrate());
  }

  final SettingsLocalDataSource _dataSource;
  late final StreamController<AppSettings> _controller;
  AppSettings _current = AppSettings.initial;

  Future<void> _hydrate() async {
    final dto = await _dataSource.read();
    if (dto != null) {
      _current = dto.toDomain();
      _controller.add(_current);
    }
  }

  @override
  Stream<AppSettings> watch() => _controller.stream;

  @override
  Future<Result<void, AppFailure>> update(AppSettings settings) async {
    final previous = _current;
    _current = settings;
    _controller.add(_current);
    try {
      await _dataSource.write(settings.toDto());
      return const Result.ok(null);
    } on Exception catch (e) {
      _current = previous;
      _controller.add(_current);
      return Result.err(StorageFailure('Could not save settings', cause: e));
    }
  }
}
