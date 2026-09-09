import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/data_management/domain/repositories/data_reset_repository.dart';

/// Deletes every row in every table this app owns — a full local
/// factory reset, including the Guest Profile itself.
class WipeAllDataUseCase {
  /// Creates the use case over the given [DataResetRepository] port.
  const new(this._repository);

  final DataResetRepository _repository;

  /// Runs the wipe.
  Future<Result<void, AppFailure>> call() => _repository.wipeAllData();
}
