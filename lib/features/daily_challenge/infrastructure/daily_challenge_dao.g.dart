// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge_dao.dart';

// ignore_for_file: type=lint
mixin _$DailyChallengeDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyChallengeCompletionsTable get dailyChallengeCompletions =>
      attachedDatabase.dailyChallengeCompletions;
  DailyChallengeDaoManager get managers => DailyChallengeDaoManager(this);
}

class DailyChallengeDaoManager {
  final _$DailyChallengeDaoMixin _db;
  DailyChallengeDaoManager(this._db);
  $$DailyChallengeCompletionsTableTableManager get dailyChallengeCompletions =>
      $$DailyChallengeCompletionsTableTableManager(
        _db.attachedDatabase,
        _db.dailyChallengeCompletions,
      );
}
