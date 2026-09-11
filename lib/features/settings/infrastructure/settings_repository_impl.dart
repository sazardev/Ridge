import 'dart:async';

import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/settings/domain/entities/app_settings.dart';
import 'package:ridge/features/settings/domain/repositories/settings_repository.dart';
import 'package:ridge/features/settings/infrastructure/settings_local_data_source.dart';
import 'package:ridge/features/settings/infrastructure/settings_mapper.dart';

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
    _hydrated = _hydrate();
  }

  final SettingsLocalDataSource _dataSource;
  late final StreamController<AppSettings> _controller;
  late final Future<AppSettings> _hydrated;
  AppSettings _current = AppSettings.initial;

  /// Resolves once, with whatever [AppSettings] were actually persisted
  /// (or [AppSettings.initial] if nothing was ever saved) — deliberately
  /// separate from [watch]'s broadcast stream, which always eagerly
  /// replays [_current] to every new subscriber (including
  /// [AppSettings.initial] before this resolves, so `SettingsController`
  /// never blocks on it). `main.dart` awaits this once, before the first
  /// frame is ever painted, so the running app never has to show
  /// [AppSettings.initial]'s hardcoded defaults (wrong palette/theme)
  /// for even a frame while waiting on the async `shared_preferences`
  /// read to resolve.
  Future<AppSettings> get hydrated => _hydrated;

  Future<AppSettings> _hydrate() async {
    final dto = await _dataSource.read();
    if (dto != null) {
      _current = dto.toDomain();
      _controller.add(_current);
    }
    return _current;
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
