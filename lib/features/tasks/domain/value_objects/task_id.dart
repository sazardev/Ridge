import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'task_id.freezed.dart';

@freezed
abstract class TaskId with _$TaskId {
  const factory(String value) = _TaskId;

  factory generate() => TaskId(const Uuid().v4());
}
