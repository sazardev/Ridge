import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// Shared drift database instance, opened once for the app's lifetime.
/// Feature-level DAOs/repositories build on top of this instead of each
/// opening their own connection.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}
