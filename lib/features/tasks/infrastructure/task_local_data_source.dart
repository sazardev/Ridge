import 'dart:convert';

import 'package:just_in_time/features/tasks/infrastructure/task_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskLocalDataSource {
  const new(this._prefs);

  final SharedPreferencesAsync _prefs;

  static const _key = 'tasks.v1';

  Future<List<TaskDto>> readAll() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return const [];
    final list = jsonDecode(raw) as List<Object?>;
    return list
        .map((e) => TaskDto.fromJson(e! as Map<String, Object?>))
        .toList();
  }

  Future<void> writeAll(List<TaskDto> tasks) {
    return _prefs.setString(
      _key,
      jsonEncode(tasks.map((t) => t.toJson()).toList()),
    );
  }
}
