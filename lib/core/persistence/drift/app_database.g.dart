// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GuestProfilesTable extends GuestProfiles
    with TableInfo<$GuestProfilesTable, GuestProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuestProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _favoriteLanguagesMeta = const VerificationMeta(
    'favoriteLanguages',
  );
  @override
  late final GeneratedColumn<String> favoriteLanguages =
      GeneratedColumn<String>(
        'favorite_languages',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _keyboardLayoutMeta = const VerificationMeta(
    'keyboardLayout',
  );
  @override
  late final GeneratedColumn<String> keyboardLayout = GeneratedColumn<String>(
    'keyboard_layout',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyboardBrandMeta = const VerificationMeta(
    'keyboardBrand',
  );
  @override
  late final GeneratedColumn<String> keyboardBrand = GeneratedColumn<String>(
    'keyboard_brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keyboardModelMeta = const VerificationMeta(
    'keyboardModel',
  );
  @override
  late final GeneratedColumn<String> keyboardModel = GeneratedColumn<String>(
    'keyboard_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favoriteQuoteMeta = const VerificationMeta(
    'favoriteQuote',
  );
  @override
  late final GeneratedColumn<String> favoriteQuote = GeneratedColumn<String>(
    'favorite_quote',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favoriteProgrammerMeta =
      const VerificationMeta('favoriteProgrammer');
  @override
  late final GeneratedColumn<String> favoriteProgrammer =
      GeneratedColumn<String>(
        'favorite_programmer',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _operatingSystemVersionMeta =
      const VerificationMeta('operatingSystemVersion');
  @override
  late final GeneratedColumn<String> operatingSystemVersion =
      GeneratedColumn<String>(
        'operating_system_version',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deviceModelMeta = const VerificationMeta(
    'deviceModel',
  );
  @override
  late final GeneratedColumn<String> deviceModel = GeneratedColumn<String>(
    'device_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    createdAt,
    favoriteLanguages,
    keyboardLayout,
    keyboardBrand,
    keyboardModel,
    favoriteQuote,
    favoriteProgrammer,
    platform,
    operatingSystemVersion,
    deviceModel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guest_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<GuestProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('favorite_languages')) {
      context.handle(
        _favoriteLanguagesMeta,
        favoriteLanguages.isAcceptableOrUnknown(
          data['favorite_languages']!,
          _favoriteLanguagesMeta,
        ),
      );
    }
    if (data.containsKey('keyboard_layout')) {
      context.handle(
        _keyboardLayoutMeta,
        keyboardLayout.isAcceptableOrUnknown(
          data['keyboard_layout']!,
          _keyboardLayoutMeta,
        ),
      );
    }
    if (data.containsKey('keyboard_brand')) {
      context.handle(
        _keyboardBrandMeta,
        keyboardBrand.isAcceptableOrUnknown(
          data['keyboard_brand']!,
          _keyboardBrandMeta,
        ),
      );
    }
    if (data.containsKey('keyboard_model')) {
      context.handle(
        _keyboardModelMeta,
        keyboardModel.isAcceptableOrUnknown(
          data['keyboard_model']!,
          _keyboardModelMeta,
        ),
      );
    }
    if (data.containsKey('favorite_quote')) {
      context.handle(
        _favoriteQuoteMeta,
        favoriteQuote.isAcceptableOrUnknown(
          data['favorite_quote']!,
          _favoriteQuoteMeta,
        ),
      );
    }
    if (data.containsKey('favorite_programmer')) {
      context.handle(
        _favoriteProgrammerMeta,
        favoriteProgrammer.isAcceptableOrUnknown(
          data['favorite_programmer']!,
          _favoriteProgrammerMeta,
        ),
      );
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    }
    if (data.containsKey('operating_system_version')) {
      context.handle(
        _operatingSystemVersionMeta,
        operatingSystemVersion.isAcceptableOrUnknown(
          data['operating_system_version']!,
          _operatingSystemVersionMeta,
        ),
      );
    }
    if (data.containsKey('device_model')) {
      context.handle(
        _deviceModelMeta,
        deviceModel.isAcceptableOrUnknown(
          data['device_model']!,
          _deviceModelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GuestProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GuestProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      favoriteLanguages: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favorite_languages'],
      ),
      keyboardLayout: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyboard_layout'],
      ),
      keyboardBrand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyboard_brand'],
      ),
      keyboardModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyboard_model'],
      ),
      favoriteQuote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favorite_quote'],
      ),
      favoriteProgrammer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favorite_programmer'],
      ),
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      ),
      operatingSystemVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operating_system_version'],
      ),
      deviceModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_model'],
      ),
    );
  }

  @override
  $GuestProfilesTable createAlias(String alias) {
    return $GuestProfilesTable(attachedDatabase, alias);
  }
}

class GuestProfileRow extends DataClass implements Insertable<GuestProfileRow> {
  /// The `ProfileId` value, stored as plain text.
  final String id;

  /// The user-chosen display name.
  final String username;

  /// When this profile was created, on this device.
  final DateTime createdAt;

  /// The user's self-reported favorite programming languages, as a
  /// comma-joined list of `FavoriteLanguage.name`s (see
  /// `ProfileMapper`'s CSV helpers), or `null`/empty if none are set.
  final String? favoriteLanguages;

  /// The user's self-reported keyboard layout (`KeyboardLayout.name`), or
  /// `null` if never set.
  final String? keyboardLayout;

  /// The user's self-reported keyboard brand, free text, or `null` if
  /// never set.
  final String? keyboardBrand;

  /// The user's self-reported keyboard model, free text, or `null` if
  /// never set.
  final String? keyboardModel;

  /// The user's favorite quote/phrase, free text, or `null` if never set.
  final String? favoriteQuote;

  /// The user's favorite programmer/tech influence, free text, or `null`
  /// if never set.
  final String? favoriteProgrammer;

  /// Auto-detected platform name (e.g. `"Android"`, `"Linux"`), or `null`
  /// if never detected. Never user-edited — see `EnsureDeviceInfoUseCase`.
  final String? platform;

  /// Auto-detected OS version string (e.g. `"Android 14"`,
  /// `"Ubuntu 24.04.1 LTS"`), or `null` if never detected or unavailable.
  final String? operatingSystemVersion;

  /// Auto-detected hardware model (e.g. `"Google Pixel 8"`), or `null`
  /// when never detected or the platform doesn't expose one (Linux,
  /// Windows, Web).
  final String? deviceModel;
  const GuestProfileRow({
    required this.id,
    required this.username,
    required this.createdAt,
    this.favoriteLanguages,
    this.keyboardLayout,
    this.keyboardBrand,
    this.keyboardModel,
    this.favoriteQuote,
    this.favoriteProgrammer,
    this.platform,
    this.operatingSystemVersion,
    this.deviceModel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || favoriteLanguages != null) {
      map['favorite_languages'] = Variable<String>(favoriteLanguages);
    }
    if (!nullToAbsent || keyboardLayout != null) {
      map['keyboard_layout'] = Variable<String>(keyboardLayout);
    }
    if (!nullToAbsent || keyboardBrand != null) {
      map['keyboard_brand'] = Variable<String>(keyboardBrand);
    }
    if (!nullToAbsent || keyboardModel != null) {
      map['keyboard_model'] = Variable<String>(keyboardModel);
    }
    if (!nullToAbsent || favoriteQuote != null) {
      map['favorite_quote'] = Variable<String>(favoriteQuote);
    }
    if (!nullToAbsent || favoriteProgrammer != null) {
      map['favorite_programmer'] = Variable<String>(favoriteProgrammer);
    }
    if (!nullToAbsent || platform != null) {
      map['platform'] = Variable<String>(platform);
    }
    if (!nullToAbsent || operatingSystemVersion != null) {
      map['operating_system_version'] = Variable<String>(
        operatingSystemVersion,
      );
    }
    if (!nullToAbsent || deviceModel != null) {
      map['device_model'] = Variable<String>(deviceModel);
    }
    return map;
  }

  GuestProfilesCompanion toCompanion(bool nullToAbsent) {
    return GuestProfilesCompanion(
      id: Value(id),
      username: Value(username),
      createdAt: Value(createdAt),
      favoriteLanguages: favoriteLanguages == null && nullToAbsent
          ? const Value.absent()
          : Value(favoriteLanguages),
      keyboardLayout: keyboardLayout == null && nullToAbsent
          ? const Value.absent()
          : Value(keyboardLayout),
      keyboardBrand: keyboardBrand == null && nullToAbsent
          ? const Value.absent()
          : Value(keyboardBrand),
      keyboardModel: keyboardModel == null && nullToAbsent
          ? const Value.absent()
          : Value(keyboardModel),
      favoriteQuote: favoriteQuote == null && nullToAbsent
          ? const Value.absent()
          : Value(favoriteQuote),
      favoriteProgrammer: favoriteProgrammer == null && nullToAbsent
          ? const Value.absent()
          : Value(favoriteProgrammer),
      platform: platform == null && nullToAbsent
          ? const Value.absent()
          : Value(platform),
      operatingSystemVersion: operatingSystemVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(operatingSystemVersion),
      deviceModel: deviceModel == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceModel),
    );
  }

  factory GuestProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GuestProfileRow(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      favoriteLanguages: serializer.fromJson<String?>(
        json['favoriteLanguages'],
      ),
      keyboardLayout: serializer.fromJson<String?>(json['keyboardLayout']),
      keyboardBrand: serializer.fromJson<String?>(json['keyboardBrand']),
      keyboardModel: serializer.fromJson<String?>(json['keyboardModel']),
      favoriteQuote: serializer.fromJson<String?>(json['favoriteQuote']),
      favoriteProgrammer: serializer.fromJson<String?>(
        json['favoriteProgrammer'],
      ),
      platform: serializer.fromJson<String?>(json['platform']),
      operatingSystemVersion: serializer.fromJson<String?>(
        json['operatingSystemVersion'],
      ),
      deviceModel: serializer.fromJson<String?>(json['deviceModel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'favoriteLanguages': serializer.toJson<String?>(favoriteLanguages),
      'keyboardLayout': serializer.toJson<String?>(keyboardLayout),
      'keyboardBrand': serializer.toJson<String?>(keyboardBrand),
      'keyboardModel': serializer.toJson<String?>(keyboardModel),
      'favoriteQuote': serializer.toJson<String?>(favoriteQuote),
      'favoriteProgrammer': serializer.toJson<String?>(favoriteProgrammer),
      'platform': serializer.toJson<String?>(platform),
      'operatingSystemVersion': serializer.toJson<String?>(
        operatingSystemVersion,
      ),
      'deviceModel': serializer.toJson<String?>(deviceModel),
    };
  }

  GuestProfileRow copyWith({
    String? id,
    String? username,
    DateTime? createdAt,
    Value<String?> favoriteLanguages = const Value.absent(),
    Value<String?> keyboardLayout = const Value.absent(),
    Value<String?> keyboardBrand = const Value.absent(),
    Value<String?> keyboardModel = const Value.absent(),
    Value<String?> favoriteQuote = const Value.absent(),
    Value<String?> favoriteProgrammer = const Value.absent(),
    Value<String?> platform = const Value.absent(),
    Value<String?> operatingSystemVersion = const Value.absent(),
    Value<String?> deviceModel = const Value.absent(),
  }) => GuestProfileRow(
    id: id ?? this.id,
    username: username ?? this.username,
    createdAt: createdAt ?? this.createdAt,
    favoriteLanguages: favoriteLanguages.present
        ? favoriteLanguages.value
        : this.favoriteLanguages,
    keyboardLayout: keyboardLayout.present
        ? keyboardLayout.value
        : this.keyboardLayout,
    keyboardBrand: keyboardBrand.present
        ? keyboardBrand.value
        : this.keyboardBrand,
    keyboardModel: keyboardModel.present
        ? keyboardModel.value
        : this.keyboardModel,
    favoriteQuote: favoriteQuote.present
        ? favoriteQuote.value
        : this.favoriteQuote,
    favoriteProgrammer: favoriteProgrammer.present
        ? favoriteProgrammer.value
        : this.favoriteProgrammer,
    platform: platform.present ? platform.value : this.platform,
    operatingSystemVersion: operatingSystemVersion.present
        ? operatingSystemVersion.value
        : this.operatingSystemVersion,
    deviceModel: deviceModel.present ? deviceModel.value : this.deviceModel,
  );
  GuestProfileRow copyWithCompanion(GuestProfilesCompanion data) {
    return GuestProfileRow(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      favoriteLanguages: data.favoriteLanguages.present
          ? data.favoriteLanguages.value
          : this.favoriteLanguages,
      keyboardLayout: data.keyboardLayout.present
          ? data.keyboardLayout.value
          : this.keyboardLayout,
      keyboardBrand: data.keyboardBrand.present
          ? data.keyboardBrand.value
          : this.keyboardBrand,
      keyboardModel: data.keyboardModel.present
          ? data.keyboardModel.value
          : this.keyboardModel,
      favoriteQuote: data.favoriteQuote.present
          ? data.favoriteQuote.value
          : this.favoriteQuote,
      favoriteProgrammer: data.favoriteProgrammer.present
          ? data.favoriteProgrammer.value
          : this.favoriteProgrammer,
      platform: data.platform.present ? data.platform.value : this.platform,
      operatingSystemVersion: data.operatingSystemVersion.present
          ? data.operatingSystemVersion.value
          : this.operatingSystemVersion,
      deviceModel: data.deviceModel.present
          ? data.deviceModel.value
          : this.deviceModel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GuestProfileRow(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('createdAt: $createdAt, ')
          ..write('favoriteLanguages: $favoriteLanguages, ')
          ..write('keyboardLayout: $keyboardLayout, ')
          ..write('keyboardBrand: $keyboardBrand, ')
          ..write('keyboardModel: $keyboardModel, ')
          ..write('favoriteQuote: $favoriteQuote, ')
          ..write('favoriteProgrammer: $favoriteProgrammer, ')
          ..write('platform: $platform, ')
          ..write('operatingSystemVersion: $operatingSystemVersion, ')
          ..write('deviceModel: $deviceModel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    createdAt,
    favoriteLanguages,
    keyboardLayout,
    keyboardBrand,
    keyboardModel,
    favoriteQuote,
    favoriteProgrammer,
    platform,
    operatingSystemVersion,
    deviceModel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GuestProfileRow &&
          other.id == this.id &&
          other.username == this.username &&
          other.createdAt == this.createdAt &&
          other.favoriteLanguages == this.favoriteLanguages &&
          other.keyboardLayout == this.keyboardLayout &&
          other.keyboardBrand == this.keyboardBrand &&
          other.keyboardModel == this.keyboardModel &&
          other.favoriteQuote == this.favoriteQuote &&
          other.favoriteProgrammer == this.favoriteProgrammer &&
          other.platform == this.platform &&
          other.operatingSystemVersion == this.operatingSystemVersion &&
          other.deviceModel == this.deviceModel);
}

class GuestProfilesCompanion extends UpdateCompanion<GuestProfileRow> {
  final Value<String> id;
  final Value<String> username;
  final Value<DateTime> createdAt;
  final Value<String?> favoriteLanguages;
  final Value<String?> keyboardLayout;
  final Value<String?> keyboardBrand;
  final Value<String?> keyboardModel;
  final Value<String?> favoriteQuote;
  final Value<String?> favoriteProgrammer;
  final Value<String?> platform;
  final Value<String?> operatingSystemVersion;
  final Value<String?> deviceModel;
  final Value<int> rowid;
  const GuestProfilesCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.favoriteLanguages = const Value.absent(),
    this.keyboardLayout = const Value.absent(),
    this.keyboardBrand = const Value.absent(),
    this.keyboardModel = const Value.absent(),
    this.favoriteQuote = const Value.absent(),
    this.favoriteProgrammer = const Value.absent(),
    this.platform = const Value.absent(),
    this.operatingSystemVersion = const Value.absent(),
    this.deviceModel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GuestProfilesCompanion.insert({
    required String id,
    required String username,
    required DateTime createdAt,
    this.favoriteLanguages = const Value.absent(),
    this.keyboardLayout = const Value.absent(),
    this.keyboardBrand = const Value.absent(),
    this.keyboardModel = const Value.absent(),
    this.favoriteQuote = const Value.absent(),
    this.favoriteProgrammer = const Value.absent(),
    this.platform = const Value.absent(),
    this.operatingSystemVersion = const Value.absent(),
    this.deviceModel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       username = Value(username),
       createdAt = Value(createdAt);
  static Insertable<GuestProfileRow> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<DateTime>? createdAt,
    Expression<String>? favoriteLanguages,
    Expression<String>? keyboardLayout,
    Expression<String>? keyboardBrand,
    Expression<String>? keyboardModel,
    Expression<String>? favoriteQuote,
    Expression<String>? favoriteProgrammer,
    Expression<String>? platform,
    Expression<String>? operatingSystemVersion,
    Expression<String>? deviceModel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (createdAt != null) 'created_at': createdAt,
      if (favoriteLanguages != null) 'favorite_languages': favoriteLanguages,
      if (keyboardLayout != null) 'keyboard_layout': keyboardLayout,
      if (keyboardBrand != null) 'keyboard_brand': keyboardBrand,
      if (keyboardModel != null) 'keyboard_model': keyboardModel,
      if (favoriteQuote != null) 'favorite_quote': favoriteQuote,
      if (favoriteProgrammer != null) 'favorite_programmer': favoriteProgrammer,
      if (platform != null) 'platform': platform,
      if (operatingSystemVersion != null)
        'operating_system_version': operatingSystemVersion,
      if (deviceModel != null) 'device_model': deviceModel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GuestProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? username,
    Value<DateTime>? createdAt,
    Value<String?>? favoriteLanguages,
    Value<String?>? keyboardLayout,
    Value<String?>? keyboardBrand,
    Value<String?>? keyboardModel,
    Value<String?>? favoriteQuote,
    Value<String?>? favoriteProgrammer,
    Value<String?>? platform,
    Value<String?>? operatingSystemVersion,
    Value<String?>? deviceModel,
    Value<int>? rowid,
  }) {
    return GuestProfilesCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      favoriteLanguages: favoriteLanguages ?? this.favoriteLanguages,
      keyboardLayout: keyboardLayout ?? this.keyboardLayout,
      keyboardBrand: keyboardBrand ?? this.keyboardBrand,
      keyboardModel: keyboardModel ?? this.keyboardModel,
      favoriteQuote: favoriteQuote ?? this.favoriteQuote,
      favoriteProgrammer: favoriteProgrammer ?? this.favoriteProgrammer,
      platform: platform ?? this.platform,
      operatingSystemVersion:
          operatingSystemVersion ?? this.operatingSystemVersion,
      deviceModel: deviceModel ?? this.deviceModel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (favoriteLanguages.present) {
      map['favorite_languages'] = Variable<String>(favoriteLanguages.value);
    }
    if (keyboardLayout.present) {
      map['keyboard_layout'] = Variable<String>(keyboardLayout.value);
    }
    if (keyboardBrand.present) {
      map['keyboard_brand'] = Variable<String>(keyboardBrand.value);
    }
    if (keyboardModel.present) {
      map['keyboard_model'] = Variable<String>(keyboardModel.value);
    }
    if (favoriteQuote.present) {
      map['favorite_quote'] = Variable<String>(favoriteQuote.value);
    }
    if (favoriteProgrammer.present) {
      map['favorite_programmer'] = Variable<String>(favoriteProgrammer.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (operatingSystemVersion.present) {
      map['operating_system_version'] = Variable<String>(
        operatingSystemVersion.value,
      );
    }
    if (deviceModel.present) {
      map['device_model'] = Variable<String>(deviceModel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuestProfilesCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('createdAt: $createdAt, ')
          ..write('favoriteLanguages: $favoriteLanguages, ')
          ..write('keyboardLayout: $keyboardLayout, ')
          ..write('keyboardBrand: $keyboardBrand, ')
          ..write('keyboardModel: $keyboardModel, ')
          ..write('favoriteQuote: $favoriteQuote, ')
          ..write('favoriteProgrammer: $favoriteProgrammer, ')
          ..write('platform: $platform, ')
          ..write('operatingSystemVersion: $operatingSystemVersion, ')
          ..write('deviceModel: $deviceModel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnippetsTable extends Snippets
    with TableInfo<$SnippetsTable, SnippetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symbolFocusMeta = const VerificationMeta(
    'symbolFocus',
  );
  @override
  late final GeneratedColumn<String> symbolFocus = GeneratedColumn<String>(
    'symbol_focus',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lengthMeta = const VerificationMeta('length');
  @override
  late final GeneratedColumn<String> length = GeneratedColumn<String>(
    'length',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _titleEsMeta = const VerificationMeta(
    'titleEs',
  );
  @override
  late final GeneratedColumn<String> titleEs = GeneratedColumn<String>(
    'title_es',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceAttributionMeta = const VerificationMeta(
    'sourceAttribution',
  );
  @override
  late final GeneratedColumn<String> sourceAttribution =
      GeneratedColumn<String>(
        'source_attribution',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _tldrEnMeta = const VerificationMeta('tldrEn');
  @override
  late final GeneratedColumn<String> tldrEn = GeneratedColumn<String>(
    'tldr_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tldrEsMeta = const VerificationMeta('tldrEs');
  @override
  late final GeneratedColumn<String> tldrEs = GeneratedColumn<String>(
    'tldr_es',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _explanationEnMeta = const VerificationMeta(
    'explanationEn',
  );
  @override
  late final GeneratedColumn<String> explanationEn = GeneratedColumn<String>(
    'explanation_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _explanationEsMeta = const VerificationMeta(
    'explanationEs',
  );
  @override
  late final GeneratedColumn<String> explanationEs = GeneratedColumn<String>(
    'explanation_es',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _charCountMeta = const VerificationMeta(
    'charCount',
  );
  @override
  late final GeneratedColumn<int> charCount = GeneratedColumn<int>(
    'char_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revision,
    language,
    difficulty,
    category,
    symbolFocus,
    length,
    titleEn,
    titleEs,
    code,
    sourceAttribution,
    tldrEn,
    tldrEs,
    explanationEn,
    explanationEs,
    charCount,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippets';
  @override
  VerificationContext validateIntegrity(
    Insertable<SnippetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('symbol_focus')) {
      context.handle(
        _symbolFocusMeta,
        symbolFocus.isAcceptableOrUnknown(
          data['symbol_focus']!,
          _symbolFocusMeta,
        ),
      );
    }
    if (data.containsKey('length')) {
      context.handle(
        _lengthMeta,
        length.isAcceptableOrUnknown(data['length']!, _lengthMeta),
      );
    } else if (isInserting) {
      context.missing(_lengthMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    }
    if (data.containsKey('title_es')) {
      context.handle(
        _titleEsMeta,
        titleEs.isAcceptableOrUnknown(data['title_es']!, _titleEsMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('source_attribution')) {
      context.handle(
        _sourceAttributionMeta,
        sourceAttribution.isAcceptableOrUnknown(
          data['source_attribution']!,
          _sourceAttributionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAttributionMeta);
    }
    if (data.containsKey('tldr_en')) {
      context.handle(
        _tldrEnMeta,
        tldrEn.isAcceptableOrUnknown(data['tldr_en']!, _tldrEnMeta),
      );
    }
    if (data.containsKey('tldr_es')) {
      context.handle(
        _tldrEsMeta,
        tldrEs.isAcceptableOrUnknown(data['tldr_es']!, _tldrEsMeta),
      );
    }
    if (data.containsKey('explanation_en')) {
      context.handle(
        _explanationEnMeta,
        explanationEn.isAcceptableOrUnknown(
          data['explanation_en']!,
          _explanationEnMeta,
        ),
      );
    }
    if (data.containsKey('explanation_es')) {
      context.handle(
        _explanationEsMeta,
        explanationEs.isAcceptableOrUnknown(
          data['explanation_es']!,
          _explanationEsMeta,
        ),
      );
    }
    if (data.containsKey('char_count')) {
      context.handle(
        _charCountMeta,
        charCount.isAcceptableOrUnknown(data['char_count']!, _charCountMeta),
      );
    } else if (isInserting) {
      context.missing(_charCountMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnippetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnippetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      symbolFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol_focus'],
      ),
      length: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}length'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      )!,
      titleEs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_es'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      sourceAttribution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_attribution'],
      )!,
      tldrEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tldr_en'],
      )!,
      tldrEs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tldr_es'],
      )!,
      explanationEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_en'],
      )!,
      explanationEs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_es'],
      )!,
      charCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}char_count'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $SnippetsTable createAlias(String alias) {
    return $SnippetsTable(attachedDatabase, alias);
  }
}

class SnippetRow extends DataClass implements Insertable<SnippetRow> {
  /// The stable, human-assigned `SnippetId` value.
  final String id;

  /// Monotonically increasing revision of this entry's content.
  final int revision;

  /// `ProgrammingLanguage` enum name, stored as plain text.
  final String language;

  /// `Difficulty` enum name, stored as plain text.
  final String difficulty;

  /// `ContentCategory` enum name, stored as plain text.
  final String category;

  /// Comma-separated `SymbolFocus` enum names, or `null` if this entry
  /// doesn't target any particular symbol.
  final String? symbolFocus;

  /// `SnippetLength` enum name, stored as plain text.
  final String length;

  /// Human-readable title shown in the catalog browser (English).
  final String titleEn;

  /// Spanish counterpart of [titleEn].
  final String titleEs;

  /// The real Go source code to type.
  final String code;

  /// Where this code came from (e.g. `stdlib: fmt`, `hand-authored`).
  final String sourceAttribution;

  /// An ultra-short (a few words) English summary of the concept this
  /// snippet demonstrates — shown first, above [explanationEn], as a
  /// skimmable "tl;dr" before the fuller explanation.
  final String tldrEn;

  /// Spanish counterpart of [tldrEn].
  final String tldrEs;

  /// A short, plain-language explanation (English) of what this code
  /// does and which Go syntax/idiom it demonstrates — optional post-
  /// session learning support, never shown during capture itself.
  final String explanationEn;

  /// Spanish counterpart of [explanationEn].
  final String explanationEs;

  /// `code.length`, denormalized onto this row so future queries (e.g.
  /// sorting/filtering by length) never need to load the full `code`
  /// column just to compute a sort key.
  final int charCount;

  /// Whether this entry is part of the current catalog. A superseded
  /// revision is kept but marked inactive so historical sessions that
  /// reference it stay interpretable.
  final bool isActive;
  const SnippetRow({
    required this.id,
    required this.revision,
    required this.language,
    required this.difficulty,
    required this.category,
    this.symbolFocus,
    required this.length,
    required this.titleEn,
    required this.titleEs,
    required this.code,
    required this.sourceAttribution,
    required this.tldrEn,
    required this.tldrEs,
    required this.explanationEn,
    required this.explanationEs,
    required this.charCount,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision'] = Variable<int>(revision);
    map['language'] = Variable<String>(language);
    map['difficulty'] = Variable<String>(difficulty);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || symbolFocus != null) {
      map['symbol_focus'] = Variable<String>(symbolFocus);
    }
    map['length'] = Variable<String>(length);
    map['title_en'] = Variable<String>(titleEn);
    map['title_es'] = Variable<String>(titleEs);
    map['code'] = Variable<String>(code);
    map['source_attribution'] = Variable<String>(sourceAttribution);
    map['tldr_en'] = Variable<String>(tldrEn);
    map['tldr_es'] = Variable<String>(tldrEs);
    map['explanation_en'] = Variable<String>(explanationEn);
    map['explanation_es'] = Variable<String>(explanationEs);
    map['char_count'] = Variable<int>(charCount);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SnippetsCompanion toCompanion(bool nullToAbsent) {
    return SnippetsCompanion(
      id: Value(id),
      revision: Value(revision),
      language: Value(language),
      difficulty: Value(difficulty),
      category: Value(category),
      symbolFocus: symbolFocus == null && nullToAbsent
          ? const Value.absent()
          : Value(symbolFocus),
      length: Value(length),
      titleEn: Value(titleEn),
      titleEs: Value(titleEs),
      code: Value(code),
      sourceAttribution: Value(sourceAttribution),
      tldrEn: Value(tldrEn),
      tldrEs: Value(tldrEs),
      explanationEn: Value(explanationEn),
      explanationEs: Value(explanationEs),
      charCount: Value(charCount),
      isActive: Value(isActive),
    );
  }

  factory SnippetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnippetRow(
      id: serializer.fromJson<String>(json['id']),
      revision: serializer.fromJson<int>(json['revision']),
      language: serializer.fromJson<String>(json['language']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      category: serializer.fromJson<String>(json['category']),
      symbolFocus: serializer.fromJson<String?>(json['symbolFocus']),
      length: serializer.fromJson<String>(json['length']),
      titleEn: serializer.fromJson<String>(json['titleEn']),
      titleEs: serializer.fromJson<String>(json['titleEs']),
      code: serializer.fromJson<String>(json['code']),
      sourceAttribution: serializer.fromJson<String>(json['sourceAttribution']),
      tldrEn: serializer.fromJson<String>(json['tldrEn']),
      tldrEs: serializer.fromJson<String>(json['tldrEs']),
      explanationEn: serializer.fromJson<String>(json['explanationEn']),
      explanationEs: serializer.fromJson<String>(json['explanationEs']),
      charCount: serializer.fromJson<int>(json['charCount']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revision': serializer.toJson<int>(revision),
      'language': serializer.toJson<String>(language),
      'difficulty': serializer.toJson<String>(difficulty),
      'category': serializer.toJson<String>(category),
      'symbolFocus': serializer.toJson<String?>(symbolFocus),
      'length': serializer.toJson<String>(length),
      'titleEn': serializer.toJson<String>(titleEn),
      'titleEs': serializer.toJson<String>(titleEs),
      'code': serializer.toJson<String>(code),
      'sourceAttribution': serializer.toJson<String>(sourceAttribution),
      'tldrEn': serializer.toJson<String>(tldrEn),
      'tldrEs': serializer.toJson<String>(tldrEs),
      'explanationEn': serializer.toJson<String>(explanationEn),
      'explanationEs': serializer.toJson<String>(explanationEs),
      'charCount': serializer.toJson<int>(charCount),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SnippetRow copyWith({
    String? id,
    int? revision,
    String? language,
    String? difficulty,
    String? category,
    Value<String?> symbolFocus = const Value.absent(),
    String? length,
    String? titleEn,
    String? titleEs,
    String? code,
    String? sourceAttribution,
    String? tldrEn,
    String? tldrEs,
    String? explanationEn,
    String? explanationEs,
    int? charCount,
    bool? isActive,
  }) => SnippetRow(
    id: id ?? this.id,
    revision: revision ?? this.revision,
    language: language ?? this.language,
    difficulty: difficulty ?? this.difficulty,
    category: category ?? this.category,
    symbolFocus: symbolFocus.present ? symbolFocus.value : this.symbolFocus,
    length: length ?? this.length,
    titleEn: titleEn ?? this.titleEn,
    titleEs: titleEs ?? this.titleEs,
    code: code ?? this.code,
    sourceAttribution: sourceAttribution ?? this.sourceAttribution,
    tldrEn: tldrEn ?? this.tldrEn,
    tldrEs: tldrEs ?? this.tldrEs,
    explanationEn: explanationEn ?? this.explanationEn,
    explanationEs: explanationEs ?? this.explanationEs,
    charCount: charCount ?? this.charCount,
    isActive: isActive ?? this.isActive,
  );
  SnippetRow copyWithCompanion(SnippetsCompanion data) {
    return SnippetRow(
      id: data.id.present ? data.id.value : this.id,
      revision: data.revision.present ? data.revision.value : this.revision,
      language: data.language.present ? data.language.value : this.language,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      category: data.category.present ? data.category.value : this.category,
      symbolFocus: data.symbolFocus.present
          ? data.symbolFocus.value
          : this.symbolFocus,
      length: data.length.present ? data.length.value : this.length,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleEs: data.titleEs.present ? data.titleEs.value : this.titleEs,
      code: data.code.present ? data.code.value : this.code,
      sourceAttribution: data.sourceAttribution.present
          ? data.sourceAttribution.value
          : this.sourceAttribution,
      tldrEn: data.tldrEn.present ? data.tldrEn.value : this.tldrEn,
      tldrEs: data.tldrEs.present ? data.tldrEs.value : this.tldrEs,
      explanationEn: data.explanationEn.present
          ? data.explanationEn.value
          : this.explanationEn,
      explanationEs: data.explanationEs.present
          ? data.explanationEs.value
          : this.explanationEs,
      charCount: data.charCount.present ? data.charCount.value : this.charCount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnippetRow(')
          ..write('id: $id, ')
          ..write('revision: $revision, ')
          ..write('language: $language, ')
          ..write('difficulty: $difficulty, ')
          ..write('category: $category, ')
          ..write('symbolFocus: $symbolFocus, ')
          ..write('length: $length, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleEs: $titleEs, ')
          ..write('code: $code, ')
          ..write('sourceAttribution: $sourceAttribution, ')
          ..write('tldrEn: $tldrEn, ')
          ..write('tldrEs: $tldrEs, ')
          ..write('explanationEn: $explanationEn, ')
          ..write('explanationEs: $explanationEs, ')
          ..write('charCount: $charCount, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    revision,
    language,
    difficulty,
    category,
    symbolFocus,
    length,
    titleEn,
    titleEs,
    code,
    sourceAttribution,
    tldrEn,
    tldrEs,
    explanationEn,
    explanationEs,
    charCount,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnippetRow &&
          other.id == this.id &&
          other.revision == this.revision &&
          other.language == this.language &&
          other.difficulty == this.difficulty &&
          other.category == this.category &&
          other.symbolFocus == this.symbolFocus &&
          other.length == this.length &&
          other.titleEn == this.titleEn &&
          other.titleEs == this.titleEs &&
          other.code == this.code &&
          other.sourceAttribution == this.sourceAttribution &&
          other.tldrEn == this.tldrEn &&
          other.tldrEs == this.tldrEs &&
          other.explanationEn == this.explanationEn &&
          other.explanationEs == this.explanationEs &&
          other.charCount == this.charCount &&
          other.isActive == this.isActive);
}

class SnippetsCompanion extends UpdateCompanion<SnippetRow> {
  final Value<String> id;
  final Value<int> revision;
  final Value<String> language;
  final Value<String> difficulty;
  final Value<String> category;
  final Value<String?> symbolFocus;
  final Value<String> length;
  final Value<String> titleEn;
  final Value<String> titleEs;
  final Value<String> code;
  final Value<String> sourceAttribution;
  final Value<String> tldrEn;
  final Value<String> tldrEs;
  final Value<String> explanationEn;
  final Value<String> explanationEs;
  final Value<int> charCount;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SnippetsCompanion({
    this.id = const Value.absent(),
    this.revision = const Value.absent(),
    this.language = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.category = const Value.absent(),
    this.symbolFocus = const Value.absent(),
    this.length = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleEs = const Value.absent(),
    this.code = const Value.absent(),
    this.sourceAttribution = const Value.absent(),
    this.tldrEn = const Value.absent(),
    this.tldrEs = const Value.absent(),
    this.explanationEn = const Value.absent(),
    this.explanationEs = const Value.absent(),
    this.charCount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnippetsCompanion.insert({
    required String id,
    required int revision,
    required String language,
    required String difficulty,
    required String category,
    this.symbolFocus = const Value.absent(),
    required String length,
    this.titleEn = const Value.absent(),
    this.titleEs = const Value.absent(),
    required String code,
    required String sourceAttribution,
    this.tldrEn = const Value.absent(),
    this.tldrEs = const Value.absent(),
    this.explanationEn = const Value.absent(),
    this.explanationEs = const Value.absent(),
    required int charCount,
    required bool isActive,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revision = Value(revision),
       language = Value(language),
       difficulty = Value(difficulty),
       category = Value(category),
       length = Value(length),
       code = Value(code),
       sourceAttribution = Value(sourceAttribution),
       charCount = Value(charCount),
       isActive = Value(isActive);
  static Insertable<SnippetRow> custom({
    Expression<String>? id,
    Expression<int>? revision,
    Expression<String>? language,
    Expression<String>? difficulty,
    Expression<String>? category,
    Expression<String>? symbolFocus,
    Expression<String>? length,
    Expression<String>? titleEn,
    Expression<String>? titleEs,
    Expression<String>? code,
    Expression<String>? sourceAttribution,
    Expression<String>? tldrEn,
    Expression<String>? tldrEs,
    Expression<String>? explanationEn,
    Expression<String>? explanationEs,
    Expression<int>? charCount,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revision != null) 'revision': revision,
      if (language != null) 'language': language,
      if (difficulty != null) 'difficulty': difficulty,
      if (category != null) 'category': category,
      if (symbolFocus != null) 'symbol_focus': symbolFocus,
      if (length != null) 'length': length,
      if (titleEn != null) 'title_en': titleEn,
      if (titleEs != null) 'title_es': titleEs,
      if (code != null) 'code': code,
      if (sourceAttribution != null) 'source_attribution': sourceAttribution,
      if (tldrEn != null) 'tldr_en': tldrEn,
      if (tldrEs != null) 'tldr_es': tldrEs,
      if (explanationEn != null) 'explanation_en': explanationEn,
      if (explanationEs != null) 'explanation_es': explanationEs,
      if (charCount != null) 'char_count': charCount,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnippetsCompanion copyWith({
    Value<String>? id,
    Value<int>? revision,
    Value<String>? language,
    Value<String>? difficulty,
    Value<String>? category,
    Value<String?>? symbolFocus,
    Value<String>? length,
    Value<String>? titleEn,
    Value<String>? titleEs,
    Value<String>? code,
    Value<String>? sourceAttribution,
    Value<String>? tldrEn,
    Value<String>? tldrEs,
    Value<String>? explanationEn,
    Value<String>? explanationEs,
    Value<int>? charCount,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return SnippetsCompanion(
      id: id ?? this.id,
      revision: revision ?? this.revision,
      language: language ?? this.language,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      symbolFocus: symbolFocus ?? this.symbolFocus,
      length: length ?? this.length,
      titleEn: titleEn ?? this.titleEn,
      titleEs: titleEs ?? this.titleEs,
      code: code ?? this.code,
      sourceAttribution: sourceAttribution ?? this.sourceAttribution,
      tldrEn: tldrEn ?? this.tldrEn,
      tldrEs: tldrEs ?? this.tldrEs,
      explanationEn: explanationEn ?? this.explanationEn,
      explanationEs: explanationEs ?? this.explanationEs,
      charCount: charCount ?? this.charCount,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (symbolFocus.present) {
      map['symbol_focus'] = Variable<String>(symbolFocus.value);
    }
    if (length.present) {
      map['length'] = Variable<String>(length.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleEs.present) {
      map['title_es'] = Variable<String>(titleEs.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (sourceAttribution.present) {
      map['source_attribution'] = Variable<String>(sourceAttribution.value);
    }
    if (tldrEn.present) {
      map['tldr_en'] = Variable<String>(tldrEn.value);
    }
    if (tldrEs.present) {
      map['tldr_es'] = Variable<String>(tldrEs.value);
    }
    if (explanationEn.present) {
      map['explanation_en'] = Variable<String>(explanationEn.value);
    }
    if (explanationEs.present) {
      map['explanation_es'] = Variable<String>(explanationEs.value);
    }
    if (charCount.present) {
      map['char_count'] = Variable<int>(charCount.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsCompanion(')
          ..write('id: $id, ')
          ..write('revision: $revision, ')
          ..write('language: $language, ')
          ..write('difficulty: $difficulty, ')
          ..write('category: $category, ')
          ..write('symbolFocus: $symbolFocus, ')
          ..write('length: $length, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleEs: $titleEs, ')
          ..write('code: $code, ')
          ..write('sourceAttribution: $sourceAttribution, ')
          ..write('tldrEn: $tldrEn, ')
          ..write('tldrEs: $tldrEs, ')
          ..write('explanationEn: $explanationEn, ')
          ..write('explanationEs: $explanationEs, ')
          ..write('charCount: $charCount, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TypingSessionsTable extends TypingSessions
    with TableInfo<$TypingSessionsTable, TypingSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TypingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _snippetIdMeta = const VerificationMeta(
    'snippetId',
  );
  @override
  late final GeneratedColumn<String> snippetId = GeneratedColumn<String>(
    'snippet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snippetRevisionMeta = const VerificationMeta(
    'snippetRevision',
  );
  @override
  late final GeneratedColumn<int> snippetRevision = GeneratedColumn<int>(
    'snippet_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtUtcMicrosMeta =
      const VerificationMeta('startedAtUtcMicros');
  @override
  late final GeneratedColumn<int> startedAtUtcMicros = GeneratedColumn<int>(
    'started_at_utc_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMicrosMeta = const VerificationMeta(
    'durationMicros',
  );
  @override
  late final GeneratedColumn<int> durationMicros = GeneratedColumn<int>(
    'duration_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawSpeedCpmMeta = const VerificationMeta(
    'rawSpeedCpm',
  );
  @override
  late final GeneratedColumn<double> rawSpeedCpm = GeneratedColumn<double>(
    'raw_speed_cpm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netSpeedCpmMeta = const VerificationMeta(
    'netSpeedCpm',
  );
  @override
  late final GeneratedColumn<double> netSpeedCpm = GeneratedColumn<double>(
    'net_speed_cpm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyPctMeta = const VerificationMeta(
    'accuracyPct',
  );
  @override
  late final GeneratedColumn<double> accuracyPct = GeneratedColumn<double>(
    'accuracy_pct',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consistencyScoreMeta = const VerificationMeta(
    'consistencyScore',
  );
  @override
  late final GeneratedColumn<double> consistencyScore = GeneratedColumn<double>(
    'consistency_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxStreakMeta = const VerificationMeta(
    'maxStreak',
  );
  @override
  late final GeneratedColumn<int> maxStreak = GeneratedColumn<int>(
    'max_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatigueFirstThirdCpmMeta =
      const VerificationMeta('fatigueFirstThirdCpm');
  @override
  late final GeneratedColumn<double> fatigueFirstThirdCpm =
      GeneratedColumn<double>(
        'fatigue_first_third_cpm',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fatigueMiddleThirdCpmMeta =
      const VerificationMeta('fatigueMiddleThirdCpm');
  @override
  late final GeneratedColumn<double> fatigueMiddleThirdCpm =
      GeneratedColumn<double>(
        'fatigue_middle_third_cpm',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fatigueLastThirdCpmMeta =
      const VerificationMeta('fatigueLastThirdCpm');
  @override
  late final GeneratedColumn<double> fatigueLastThirdCpm =
      GeneratedColumn<double>(
        'fatigue_last_third_cpm',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _handBalanceRatioMeta = const VerificationMeta(
    'handBalanceRatio',
  );
  @override
  late final GeneratedColumn<double> handBalanceRatio = GeneratedColumn<double>(
    'hand_balance_ratio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passedMeta = const VerificationMeta('passed');
  @override
  late final GeneratedColumn<bool> passed = GeneratedColumn<bool>(
    'passed',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("passed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _xpAwardedMeta = const VerificationMeta(
    'xpAwarded',
  );
  @override
  late final GeneratedColumn<int> xpAwarded = GeneratedColumn<int>(
    'xp_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFirstCompletionMeta = const VerificationMeta(
    'isFirstCompletion',
  );
  @override
  late final GeneratedColumn<bool> isFirstCompletion = GeneratedColumn<bool>(
    'is_first_completion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_first_completion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    mode,
    lessonId,
    snippetId,
    snippetRevision,
    category,
    difficulty,
    startedAtUtcMicros,
    durationMicros,
    rawSpeedCpm,
    netSpeedCpm,
    accuracyPct,
    consistencyScore,
    maxStreak,
    fatigueFirstThirdCpm,
    fatigueMiddleThirdCpm,
    fatigueLastThirdCpm,
    handBalanceRatio,
    passed,
    xpAwarded,
    isFirstCompletion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'typing_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TypingSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    }
    if (data.containsKey('snippet_id')) {
      context.handle(
        _snippetIdMeta,
        snippetId.isAcceptableOrUnknown(data['snippet_id']!, _snippetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_snippetIdMeta);
    }
    if (data.containsKey('snippet_revision')) {
      context.handle(
        _snippetRevisionMeta,
        snippetRevision.isAcceptableOrUnknown(
          data['snippet_revision']!,
          _snippetRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snippetRevisionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('started_at_utc_micros')) {
      context.handle(
        _startedAtUtcMicrosMeta,
        startedAtUtcMicros.isAcceptableOrUnknown(
          data['started_at_utc_micros']!,
          _startedAtUtcMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtUtcMicrosMeta);
    }
    if (data.containsKey('duration_micros')) {
      context.handle(
        _durationMicrosMeta,
        durationMicros.isAcceptableOrUnknown(
          data['duration_micros']!,
          _durationMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMicrosMeta);
    }
    if (data.containsKey('raw_speed_cpm')) {
      context.handle(
        _rawSpeedCpmMeta,
        rawSpeedCpm.isAcceptableOrUnknown(
          data['raw_speed_cpm']!,
          _rawSpeedCpmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawSpeedCpmMeta);
    }
    if (data.containsKey('net_speed_cpm')) {
      context.handle(
        _netSpeedCpmMeta,
        netSpeedCpm.isAcceptableOrUnknown(
          data['net_speed_cpm']!,
          _netSpeedCpmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_netSpeedCpmMeta);
    }
    if (data.containsKey('accuracy_pct')) {
      context.handle(
        _accuracyPctMeta,
        accuracyPct.isAcceptableOrUnknown(
          data['accuracy_pct']!,
          _accuracyPctMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accuracyPctMeta);
    }
    if (data.containsKey('consistency_score')) {
      context.handle(
        _consistencyScoreMeta,
        consistencyScore.isAcceptableOrUnknown(
          data['consistency_score']!,
          _consistencyScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consistencyScoreMeta);
    }
    if (data.containsKey('max_streak')) {
      context.handle(
        _maxStreakMeta,
        maxStreak.isAcceptableOrUnknown(data['max_streak']!, _maxStreakMeta),
      );
    } else if (isInserting) {
      context.missing(_maxStreakMeta);
    }
    if (data.containsKey('fatigue_first_third_cpm')) {
      context.handle(
        _fatigueFirstThirdCpmMeta,
        fatigueFirstThirdCpm.isAcceptableOrUnknown(
          data['fatigue_first_third_cpm']!,
          _fatigueFirstThirdCpmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fatigueFirstThirdCpmMeta);
    }
    if (data.containsKey('fatigue_middle_third_cpm')) {
      context.handle(
        _fatigueMiddleThirdCpmMeta,
        fatigueMiddleThirdCpm.isAcceptableOrUnknown(
          data['fatigue_middle_third_cpm']!,
          _fatigueMiddleThirdCpmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fatigueMiddleThirdCpmMeta);
    }
    if (data.containsKey('fatigue_last_third_cpm')) {
      context.handle(
        _fatigueLastThirdCpmMeta,
        fatigueLastThirdCpm.isAcceptableOrUnknown(
          data['fatigue_last_third_cpm']!,
          _fatigueLastThirdCpmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fatigueLastThirdCpmMeta);
    }
    if (data.containsKey('hand_balance_ratio')) {
      context.handle(
        _handBalanceRatioMeta,
        handBalanceRatio.isAcceptableOrUnknown(
          data['hand_balance_ratio']!,
          _handBalanceRatioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_handBalanceRatioMeta);
    }
    if (data.containsKey('passed')) {
      context.handle(
        _passedMeta,
        passed.isAcceptableOrUnknown(data['passed']!, _passedMeta),
      );
    }
    if (data.containsKey('xp_awarded')) {
      context.handle(
        _xpAwardedMeta,
        xpAwarded.isAcceptableOrUnknown(data['xp_awarded']!, _xpAwardedMeta),
      );
    }
    if (data.containsKey('is_first_completion')) {
      context.handle(
        _isFirstCompletionMeta,
        isFirstCompletion.isAcceptableOrUnknown(
          data['is_first_completion']!,
          _isFirstCompletionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TypingSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TypingSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      ),
      snippetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snippet_id'],
      )!,
      snippetRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snippet_revision'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      startedAtUtcMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_utc_micros'],
      )!,
      durationMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_micros'],
      )!,
      rawSpeedCpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}raw_speed_cpm'],
      )!,
      netSpeedCpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}net_speed_cpm'],
      )!,
      accuracyPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_pct'],
      )!,
      consistencyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}consistency_score'],
      )!,
      maxStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_streak'],
      )!,
      fatigueFirstThirdCpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fatigue_first_third_cpm'],
      )!,
      fatigueMiddleThirdCpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fatigue_middle_third_cpm'],
      )!,
      fatigueLastThirdCpm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fatigue_last_third_cpm'],
      )!,
      handBalanceRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hand_balance_ratio'],
      )!,
      passed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}passed'],
      ),
      xpAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_awarded'],
      )!,
      isFirstCompletion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_first_completion'],
      )!,
    );
  }

  @override
  $TypingSessionsTable createAlias(String alias) {
    return $TypingSessionsTable(attachedDatabase, alias);
  }
}

class TypingSessionRow extends DataClass
    implements Insertable<TypingSessionRow> {
  /// The `TypingSessionId` value.
  final String id;

  /// The `ProfileId` of whoever ran this session.
  final String profileId;

  /// `PracticeMode`'s discriminator name (`zen`, `sprint`, `precision`,
  /// `learningRouteLesson`).
  final String mode;

  /// The `learning_paths` lesson id, only set when [mode] is
  /// `learningRouteLesson`.
  final String? lessonId;

  /// The `SnippetId` typed during this session.
  final String snippetId;

  /// The snippet revision typed, so historical sessions stay
  /// interpretable even after the snippet is corrected.
  final int snippetRevision;

  /// The snippet's `ContentCategory`, denormalized for query convenience.
  final String category;

  /// The snippet's `Difficulty`, denormalized for query convenience.
  final String difficulty;

  /// When this session started, as UTC microseconds since epoch.
  final int startedAtUtcMicros;

  /// Total elapsed session time, in microseconds.
  final int durationMicros;

  /// Raw (all keystrokes) speed, in characters per minute.
  final double rawSpeedCpm;

  /// Net (correct-only) speed, in characters per minute.
  final double netSpeedCpm;

  /// Percentage of characters correct on the first try.
  final double accuracyPct;

  /// 0-100 rhythm-uniformity score; higher is more consistent.
  final double consistencyScore;

  /// Longest run of consecutive correct-first-try characters.
  final int maxStreak;

  /// CPM during the first third of the session.
  final double fatigueFirstThirdCpm;

  /// CPM during the middle third of the session.
  final double fatigueMiddleThirdCpm;

  /// CPM during the last third of the session.
  final double fatigueLastThirdCpm;

  /// Ratio of the less-used hand to the more-used hand (thumb excluded).
  final double handBalanceRatio;

  /// Pass/fail outcome; always `null` for Zen sessions.
  final bool? passed;

  /// XP granted for this session — written as `0` by `practice`, then
  /// backfilled with the real value by `progression`'s
  /// `RecomputeProgressSnapshotUseCase` right after this row is written.
  final int xpAwarded;

  /// Whether this was the first-ever completion of this snippet id —
  /// written as `false` by `practice`, then backfilled by `progression`,
  /// same as [xpAwarded].
  final bool isFirstCompletion;
  const TypingSessionRow({
    required this.id,
    required this.profileId,
    required this.mode,
    this.lessonId,
    required this.snippetId,
    required this.snippetRevision,
    required this.category,
    required this.difficulty,
    required this.startedAtUtcMicros,
    required this.durationMicros,
    required this.rawSpeedCpm,
    required this.netSpeedCpm,
    required this.accuracyPct,
    required this.consistencyScore,
    required this.maxStreak,
    required this.fatigueFirstThirdCpm,
    required this.fatigueMiddleThirdCpm,
    required this.fatigueLastThirdCpm,
    required this.handBalanceRatio,
    this.passed,
    required this.xpAwarded,
    required this.isFirstCompletion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || lessonId != null) {
      map['lesson_id'] = Variable<String>(lessonId);
    }
    map['snippet_id'] = Variable<String>(snippetId);
    map['snippet_revision'] = Variable<int>(snippetRevision);
    map['category'] = Variable<String>(category);
    map['difficulty'] = Variable<String>(difficulty);
    map['started_at_utc_micros'] = Variable<int>(startedAtUtcMicros);
    map['duration_micros'] = Variable<int>(durationMicros);
    map['raw_speed_cpm'] = Variable<double>(rawSpeedCpm);
    map['net_speed_cpm'] = Variable<double>(netSpeedCpm);
    map['accuracy_pct'] = Variable<double>(accuracyPct);
    map['consistency_score'] = Variable<double>(consistencyScore);
    map['max_streak'] = Variable<int>(maxStreak);
    map['fatigue_first_third_cpm'] = Variable<double>(fatigueFirstThirdCpm);
    map['fatigue_middle_third_cpm'] = Variable<double>(fatigueMiddleThirdCpm);
    map['fatigue_last_third_cpm'] = Variable<double>(fatigueLastThirdCpm);
    map['hand_balance_ratio'] = Variable<double>(handBalanceRatio);
    if (!nullToAbsent || passed != null) {
      map['passed'] = Variable<bool>(passed);
    }
    map['xp_awarded'] = Variable<int>(xpAwarded);
    map['is_first_completion'] = Variable<bool>(isFirstCompletion);
    return map;
  }

  TypingSessionsCompanion toCompanion(bool nullToAbsent) {
    return TypingSessionsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      mode: Value(mode),
      lessonId: lessonId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonId),
      snippetId: Value(snippetId),
      snippetRevision: Value(snippetRevision),
      category: Value(category),
      difficulty: Value(difficulty),
      startedAtUtcMicros: Value(startedAtUtcMicros),
      durationMicros: Value(durationMicros),
      rawSpeedCpm: Value(rawSpeedCpm),
      netSpeedCpm: Value(netSpeedCpm),
      accuracyPct: Value(accuracyPct),
      consistencyScore: Value(consistencyScore),
      maxStreak: Value(maxStreak),
      fatigueFirstThirdCpm: Value(fatigueFirstThirdCpm),
      fatigueMiddleThirdCpm: Value(fatigueMiddleThirdCpm),
      fatigueLastThirdCpm: Value(fatigueLastThirdCpm),
      handBalanceRatio: Value(handBalanceRatio),
      passed: passed == null && nullToAbsent
          ? const Value.absent()
          : Value(passed),
      xpAwarded: Value(xpAwarded),
      isFirstCompletion: Value(isFirstCompletion),
    );
  }

  factory TypingSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TypingSessionRow(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      mode: serializer.fromJson<String>(json['mode']),
      lessonId: serializer.fromJson<String?>(json['lessonId']),
      snippetId: serializer.fromJson<String>(json['snippetId']),
      snippetRevision: serializer.fromJson<int>(json['snippetRevision']),
      category: serializer.fromJson<String>(json['category']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      startedAtUtcMicros: serializer.fromJson<int>(json['startedAtUtcMicros']),
      durationMicros: serializer.fromJson<int>(json['durationMicros']),
      rawSpeedCpm: serializer.fromJson<double>(json['rawSpeedCpm']),
      netSpeedCpm: serializer.fromJson<double>(json['netSpeedCpm']),
      accuracyPct: serializer.fromJson<double>(json['accuracyPct']),
      consistencyScore: serializer.fromJson<double>(json['consistencyScore']),
      maxStreak: serializer.fromJson<int>(json['maxStreak']),
      fatigueFirstThirdCpm: serializer.fromJson<double>(
        json['fatigueFirstThirdCpm'],
      ),
      fatigueMiddleThirdCpm: serializer.fromJson<double>(
        json['fatigueMiddleThirdCpm'],
      ),
      fatigueLastThirdCpm: serializer.fromJson<double>(
        json['fatigueLastThirdCpm'],
      ),
      handBalanceRatio: serializer.fromJson<double>(json['handBalanceRatio']),
      passed: serializer.fromJson<bool?>(json['passed']),
      xpAwarded: serializer.fromJson<int>(json['xpAwarded']),
      isFirstCompletion: serializer.fromJson<bool>(json['isFirstCompletion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'mode': serializer.toJson<String>(mode),
      'lessonId': serializer.toJson<String?>(lessonId),
      'snippetId': serializer.toJson<String>(snippetId),
      'snippetRevision': serializer.toJson<int>(snippetRevision),
      'category': serializer.toJson<String>(category),
      'difficulty': serializer.toJson<String>(difficulty),
      'startedAtUtcMicros': serializer.toJson<int>(startedAtUtcMicros),
      'durationMicros': serializer.toJson<int>(durationMicros),
      'rawSpeedCpm': serializer.toJson<double>(rawSpeedCpm),
      'netSpeedCpm': serializer.toJson<double>(netSpeedCpm),
      'accuracyPct': serializer.toJson<double>(accuracyPct),
      'consistencyScore': serializer.toJson<double>(consistencyScore),
      'maxStreak': serializer.toJson<int>(maxStreak),
      'fatigueFirstThirdCpm': serializer.toJson<double>(fatigueFirstThirdCpm),
      'fatigueMiddleThirdCpm': serializer.toJson<double>(fatigueMiddleThirdCpm),
      'fatigueLastThirdCpm': serializer.toJson<double>(fatigueLastThirdCpm),
      'handBalanceRatio': serializer.toJson<double>(handBalanceRatio),
      'passed': serializer.toJson<bool?>(passed),
      'xpAwarded': serializer.toJson<int>(xpAwarded),
      'isFirstCompletion': serializer.toJson<bool>(isFirstCompletion),
    };
  }

  TypingSessionRow copyWith({
    String? id,
    String? profileId,
    String? mode,
    Value<String?> lessonId = const Value.absent(),
    String? snippetId,
    int? snippetRevision,
    String? category,
    String? difficulty,
    int? startedAtUtcMicros,
    int? durationMicros,
    double? rawSpeedCpm,
    double? netSpeedCpm,
    double? accuracyPct,
    double? consistencyScore,
    int? maxStreak,
    double? fatigueFirstThirdCpm,
    double? fatigueMiddleThirdCpm,
    double? fatigueLastThirdCpm,
    double? handBalanceRatio,
    Value<bool?> passed = const Value.absent(),
    int? xpAwarded,
    bool? isFirstCompletion,
  }) => TypingSessionRow(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    mode: mode ?? this.mode,
    lessonId: lessonId.present ? lessonId.value : this.lessonId,
    snippetId: snippetId ?? this.snippetId,
    snippetRevision: snippetRevision ?? this.snippetRevision,
    category: category ?? this.category,
    difficulty: difficulty ?? this.difficulty,
    startedAtUtcMicros: startedAtUtcMicros ?? this.startedAtUtcMicros,
    durationMicros: durationMicros ?? this.durationMicros,
    rawSpeedCpm: rawSpeedCpm ?? this.rawSpeedCpm,
    netSpeedCpm: netSpeedCpm ?? this.netSpeedCpm,
    accuracyPct: accuracyPct ?? this.accuracyPct,
    consistencyScore: consistencyScore ?? this.consistencyScore,
    maxStreak: maxStreak ?? this.maxStreak,
    fatigueFirstThirdCpm: fatigueFirstThirdCpm ?? this.fatigueFirstThirdCpm,
    fatigueMiddleThirdCpm: fatigueMiddleThirdCpm ?? this.fatigueMiddleThirdCpm,
    fatigueLastThirdCpm: fatigueLastThirdCpm ?? this.fatigueLastThirdCpm,
    handBalanceRatio: handBalanceRatio ?? this.handBalanceRatio,
    passed: passed.present ? passed.value : this.passed,
    xpAwarded: xpAwarded ?? this.xpAwarded,
    isFirstCompletion: isFirstCompletion ?? this.isFirstCompletion,
  );
  TypingSessionRow copyWithCompanion(TypingSessionsCompanion data) {
    return TypingSessionRow(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      mode: data.mode.present ? data.mode.value : this.mode,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      snippetId: data.snippetId.present ? data.snippetId.value : this.snippetId,
      snippetRevision: data.snippetRevision.present
          ? data.snippetRevision.value
          : this.snippetRevision,
      category: data.category.present ? data.category.value : this.category,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      startedAtUtcMicros: data.startedAtUtcMicros.present
          ? data.startedAtUtcMicros.value
          : this.startedAtUtcMicros,
      durationMicros: data.durationMicros.present
          ? data.durationMicros.value
          : this.durationMicros,
      rawSpeedCpm: data.rawSpeedCpm.present
          ? data.rawSpeedCpm.value
          : this.rawSpeedCpm,
      netSpeedCpm: data.netSpeedCpm.present
          ? data.netSpeedCpm.value
          : this.netSpeedCpm,
      accuracyPct: data.accuracyPct.present
          ? data.accuracyPct.value
          : this.accuracyPct,
      consistencyScore: data.consistencyScore.present
          ? data.consistencyScore.value
          : this.consistencyScore,
      maxStreak: data.maxStreak.present ? data.maxStreak.value : this.maxStreak,
      fatigueFirstThirdCpm: data.fatigueFirstThirdCpm.present
          ? data.fatigueFirstThirdCpm.value
          : this.fatigueFirstThirdCpm,
      fatigueMiddleThirdCpm: data.fatigueMiddleThirdCpm.present
          ? data.fatigueMiddleThirdCpm.value
          : this.fatigueMiddleThirdCpm,
      fatigueLastThirdCpm: data.fatigueLastThirdCpm.present
          ? data.fatigueLastThirdCpm.value
          : this.fatigueLastThirdCpm,
      handBalanceRatio: data.handBalanceRatio.present
          ? data.handBalanceRatio.value
          : this.handBalanceRatio,
      passed: data.passed.present ? data.passed.value : this.passed,
      xpAwarded: data.xpAwarded.present ? data.xpAwarded.value : this.xpAwarded,
      isFirstCompletion: data.isFirstCompletion.present
          ? data.isFirstCompletion.value
          : this.isFirstCompletion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TypingSessionRow(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('mode: $mode, ')
          ..write('lessonId: $lessonId, ')
          ..write('snippetId: $snippetId, ')
          ..write('snippetRevision: $snippetRevision, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('startedAtUtcMicros: $startedAtUtcMicros, ')
          ..write('durationMicros: $durationMicros, ')
          ..write('rawSpeedCpm: $rawSpeedCpm, ')
          ..write('netSpeedCpm: $netSpeedCpm, ')
          ..write('accuracyPct: $accuracyPct, ')
          ..write('consistencyScore: $consistencyScore, ')
          ..write('maxStreak: $maxStreak, ')
          ..write('fatigueFirstThirdCpm: $fatigueFirstThirdCpm, ')
          ..write('fatigueMiddleThirdCpm: $fatigueMiddleThirdCpm, ')
          ..write('fatigueLastThirdCpm: $fatigueLastThirdCpm, ')
          ..write('handBalanceRatio: $handBalanceRatio, ')
          ..write('passed: $passed, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('isFirstCompletion: $isFirstCompletion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    profileId,
    mode,
    lessonId,
    snippetId,
    snippetRevision,
    category,
    difficulty,
    startedAtUtcMicros,
    durationMicros,
    rawSpeedCpm,
    netSpeedCpm,
    accuracyPct,
    consistencyScore,
    maxStreak,
    fatigueFirstThirdCpm,
    fatigueMiddleThirdCpm,
    fatigueLastThirdCpm,
    handBalanceRatio,
    passed,
    xpAwarded,
    isFirstCompletion,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TypingSessionRow &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.mode == this.mode &&
          other.lessonId == this.lessonId &&
          other.snippetId == this.snippetId &&
          other.snippetRevision == this.snippetRevision &&
          other.category == this.category &&
          other.difficulty == this.difficulty &&
          other.startedAtUtcMicros == this.startedAtUtcMicros &&
          other.durationMicros == this.durationMicros &&
          other.rawSpeedCpm == this.rawSpeedCpm &&
          other.netSpeedCpm == this.netSpeedCpm &&
          other.accuracyPct == this.accuracyPct &&
          other.consistencyScore == this.consistencyScore &&
          other.maxStreak == this.maxStreak &&
          other.fatigueFirstThirdCpm == this.fatigueFirstThirdCpm &&
          other.fatigueMiddleThirdCpm == this.fatigueMiddleThirdCpm &&
          other.fatigueLastThirdCpm == this.fatigueLastThirdCpm &&
          other.handBalanceRatio == this.handBalanceRatio &&
          other.passed == this.passed &&
          other.xpAwarded == this.xpAwarded &&
          other.isFirstCompletion == this.isFirstCompletion);
}

class TypingSessionsCompanion extends UpdateCompanion<TypingSessionRow> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> mode;
  final Value<String?> lessonId;
  final Value<String> snippetId;
  final Value<int> snippetRevision;
  final Value<String> category;
  final Value<String> difficulty;
  final Value<int> startedAtUtcMicros;
  final Value<int> durationMicros;
  final Value<double> rawSpeedCpm;
  final Value<double> netSpeedCpm;
  final Value<double> accuracyPct;
  final Value<double> consistencyScore;
  final Value<int> maxStreak;
  final Value<double> fatigueFirstThirdCpm;
  final Value<double> fatigueMiddleThirdCpm;
  final Value<double> fatigueLastThirdCpm;
  final Value<double> handBalanceRatio;
  final Value<bool?> passed;
  final Value<int> xpAwarded;
  final Value<bool> isFirstCompletion;
  final Value<int> rowid;
  const TypingSessionsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.mode = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.snippetRevision = const Value.absent(),
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.startedAtUtcMicros = const Value.absent(),
    this.durationMicros = const Value.absent(),
    this.rawSpeedCpm = const Value.absent(),
    this.netSpeedCpm = const Value.absent(),
    this.accuracyPct = const Value.absent(),
    this.consistencyScore = const Value.absent(),
    this.maxStreak = const Value.absent(),
    this.fatigueFirstThirdCpm = const Value.absent(),
    this.fatigueMiddleThirdCpm = const Value.absent(),
    this.fatigueLastThirdCpm = const Value.absent(),
    this.handBalanceRatio = const Value.absent(),
    this.passed = const Value.absent(),
    this.xpAwarded = const Value.absent(),
    this.isFirstCompletion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TypingSessionsCompanion.insert({
    required String id,
    required String profileId,
    required String mode,
    this.lessonId = const Value.absent(),
    required String snippetId,
    required int snippetRevision,
    required String category,
    required String difficulty,
    required int startedAtUtcMicros,
    required int durationMicros,
    required double rawSpeedCpm,
    required double netSpeedCpm,
    required double accuracyPct,
    required double consistencyScore,
    required int maxStreak,
    required double fatigueFirstThirdCpm,
    required double fatigueMiddleThirdCpm,
    required double fatigueLastThirdCpm,
    required double handBalanceRatio,
    this.passed = const Value.absent(),
    this.xpAwarded = const Value.absent(),
    this.isFirstCompletion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       mode = Value(mode),
       snippetId = Value(snippetId),
       snippetRevision = Value(snippetRevision),
       category = Value(category),
       difficulty = Value(difficulty),
       startedAtUtcMicros = Value(startedAtUtcMicros),
       durationMicros = Value(durationMicros),
       rawSpeedCpm = Value(rawSpeedCpm),
       netSpeedCpm = Value(netSpeedCpm),
       accuracyPct = Value(accuracyPct),
       consistencyScore = Value(consistencyScore),
       maxStreak = Value(maxStreak),
       fatigueFirstThirdCpm = Value(fatigueFirstThirdCpm),
       fatigueMiddleThirdCpm = Value(fatigueMiddleThirdCpm),
       fatigueLastThirdCpm = Value(fatigueLastThirdCpm),
       handBalanceRatio = Value(handBalanceRatio);
  static Insertable<TypingSessionRow> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? mode,
    Expression<String>? lessonId,
    Expression<String>? snippetId,
    Expression<int>? snippetRevision,
    Expression<String>? category,
    Expression<String>? difficulty,
    Expression<int>? startedAtUtcMicros,
    Expression<int>? durationMicros,
    Expression<double>? rawSpeedCpm,
    Expression<double>? netSpeedCpm,
    Expression<double>? accuracyPct,
    Expression<double>? consistencyScore,
    Expression<int>? maxStreak,
    Expression<double>? fatigueFirstThirdCpm,
    Expression<double>? fatigueMiddleThirdCpm,
    Expression<double>? fatigueLastThirdCpm,
    Expression<double>? handBalanceRatio,
    Expression<bool>? passed,
    Expression<int>? xpAwarded,
    Expression<bool>? isFirstCompletion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (mode != null) 'mode': mode,
      if (lessonId != null) 'lesson_id': lessonId,
      if (snippetId != null) 'snippet_id': snippetId,
      if (snippetRevision != null) 'snippet_revision': snippetRevision,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
      if (startedAtUtcMicros != null)
        'started_at_utc_micros': startedAtUtcMicros,
      if (durationMicros != null) 'duration_micros': durationMicros,
      if (rawSpeedCpm != null) 'raw_speed_cpm': rawSpeedCpm,
      if (netSpeedCpm != null) 'net_speed_cpm': netSpeedCpm,
      if (accuracyPct != null) 'accuracy_pct': accuracyPct,
      if (consistencyScore != null) 'consistency_score': consistencyScore,
      if (maxStreak != null) 'max_streak': maxStreak,
      if (fatigueFirstThirdCpm != null)
        'fatigue_first_third_cpm': fatigueFirstThirdCpm,
      if (fatigueMiddleThirdCpm != null)
        'fatigue_middle_third_cpm': fatigueMiddleThirdCpm,
      if (fatigueLastThirdCpm != null)
        'fatigue_last_third_cpm': fatigueLastThirdCpm,
      if (handBalanceRatio != null) 'hand_balance_ratio': handBalanceRatio,
      if (passed != null) 'passed': passed,
      if (xpAwarded != null) 'xp_awarded': xpAwarded,
      if (isFirstCompletion != null) 'is_first_completion': isFirstCompletion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TypingSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? mode,
    Value<String?>? lessonId,
    Value<String>? snippetId,
    Value<int>? snippetRevision,
    Value<String>? category,
    Value<String>? difficulty,
    Value<int>? startedAtUtcMicros,
    Value<int>? durationMicros,
    Value<double>? rawSpeedCpm,
    Value<double>? netSpeedCpm,
    Value<double>? accuracyPct,
    Value<double>? consistencyScore,
    Value<int>? maxStreak,
    Value<double>? fatigueFirstThirdCpm,
    Value<double>? fatigueMiddleThirdCpm,
    Value<double>? fatigueLastThirdCpm,
    Value<double>? handBalanceRatio,
    Value<bool?>? passed,
    Value<int>? xpAwarded,
    Value<bool>? isFirstCompletion,
    Value<int>? rowid,
  }) {
    return TypingSessionsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      mode: mode ?? this.mode,
      lessonId: lessonId ?? this.lessonId,
      snippetId: snippetId ?? this.snippetId,
      snippetRevision: snippetRevision ?? this.snippetRevision,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      startedAtUtcMicros: startedAtUtcMicros ?? this.startedAtUtcMicros,
      durationMicros: durationMicros ?? this.durationMicros,
      rawSpeedCpm: rawSpeedCpm ?? this.rawSpeedCpm,
      netSpeedCpm: netSpeedCpm ?? this.netSpeedCpm,
      accuracyPct: accuracyPct ?? this.accuracyPct,
      consistencyScore: consistencyScore ?? this.consistencyScore,
      maxStreak: maxStreak ?? this.maxStreak,
      fatigueFirstThirdCpm: fatigueFirstThirdCpm ?? this.fatigueFirstThirdCpm,
      fatigueMiddleThirdCpm:
          fatigueMiddleThirdCpm ?? this.fatigueMiddleThirdCpm,
      fatigueLastThirdCpm: fatigueLastThirdCpm ?? this.fatigueLastThirdCpm,
      handBalanceRatio: handBalanceRatio ?? this.handBalanceRatio,
      passed: passed ?? this.passed,
      xpAwarded: xpAwarded ?? this.xpAwarded,
      isFirstCompletion: isFirstCompletion ?? this.isFirstCompletion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (snippetId.present) {
      map['snippet_id'] = Variable<String>(snippetId.value);
    }
    if (snippetRevision.present) {
      map['snippet_revision'] = Variable<int>(snippetRevision.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (startedAtUtcMicros.present) {
      map['started_at_utc_micros'] = Variable<int>(startedAtUtcMicros.value);
    }
    if (durationMicros.present) {
      map['duration_micros'] = Variable<int>(durationMicros.value);
    }
    if (rawSpeedCpm.present) {
      map['raw_speed_cpm'] = Variable<double>(rawSpeedCpm.value);
    }
    if (netSpeedCpm.present) {
      map['net_speed_cpm'] = Variable<double>(netSpeedCpm.value);
    }
    if (accuracyPct.present) {
      map['accuracy_pct'] = Variable<double>(accuracyPct.value);
    }
    if (consistencyScore.present) {
      map['consistency_score'] = Variable<double>(consistencyScore.value);
    }
    if (maxStreak.present) {
      map['max_streak'] = Variable<int>(maxStreak.value);
    }
    if (fatigueFirstThirdCpm.present) {
      map['fatigue_first_third_cpm'] = Variable<double>(
        fatigueFirstThirdCpm.value,
      );
    }
    if (fatigueMiddleThirdCpm.present) {
      map['fatigue_middle_third_cpm'] = Variable<double>(
        fatigueMiddleThirdCpm.value,
      );
    }
    if (fatigueLastThirdCpm.present) {
      map['fatigue_last_third_cpm'] = Variable<double>(
        fatigueLastThirdCpm.value,
      );
    }
    if (handBalanceRatio.present) {
      map['hand_balance_ratio'] = Variable<double>(handBalanceRatio.value);
    }
    if (passed.present) {
      map['passed'] = Variable<bool>(passed.value);
    }
    if (xpAwarded.present) {
      map['xp_awarded'] = Variable<int>(xpAwarded.value);
    }
    if (isFirstCompletion.present) {
      map['is_first_completion'] = Variable<bool>(isFirstCompletion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TypingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('mode: $mode, ')
          ..write('lessonId: $lessonId, ')
          ..write('snippetId: $snippetId, ')
          ..write('snippetRevision: $snippetRevision, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('startedAtUtcMicros: $startedAtUtcMicros, ')
          ..write('durationMicros: $durationMicros, ')
          ..write('rawSpeedCpm: $rawSpeedCpm, ')
          ..write('netSpeedCpm: $netSpeedCpm, ')
          ..write('accuracyPct: $accuracyPct, ')
          ..write('consistencyScore: $consistencyScore, ')
          ..write('maxStreak: $maxStreak, ')
          ..write('fatigueFirstThirdCpm: $fatigueFirstThirdCpm, ')
          ..write('fatigueMiddleThirdCpm: $fatigueMiddleThirdCpm, ')
          ..write('fatigueLastThirdCpm: $fatigueLastThirdCpm, ')
          ..write('handBalanceRatio: $handBalanceRatio, ')
          ..write('passed: $passed, ')
          ..write('xpAwarded: $xpAwarded, ')
          ..write('isFirstCompletion: $isFirstCompletion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KeystrokeEventsTable extends KeystrokeEvents
    with TableInfo<$KeystrokeEventsTable, KeystrokeEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeystrokeEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionStartedAtUtcMicrosMeta =
      const VerificationMeta('sessionStartedAtUtcMicros');
  @override
  late final GeneratedColumn<int> sessionStartedAtUtcMicros =
      GeneratedColumn<int>(
        'session_started_at_utc_micros',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _expectedCharMeta = const VerificationMeta(
    'expectedChar',
  );
  @override
  late final GeneratedColumn<String> expectedChar = GeneratedColumn<String>(
    'expected_char',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualCharMeta = const VerificationMeta(
    'actualChar',
  );
  @override
  late final GeneratedColumn<String> actualChar = GeneratedColumn<String>(
    'actual_char',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectionMeta = const VerificationMeta(
    'isCorrection',
  );
  @override
  late final GeneratedColumn<bool> isCorrection = GeneratedColumn<bool>(
    'is_correction',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correction" IN (0, 1))',
    ),
  );
  static const VerificationMeta _physicalKeyIdMeta = const VerificationMeta(
    'physicalKeyId',
  );
  @override
  late final GeneratedColumn<String> physicalKeyId = GeneratedColumn<String>(
    'physical_key_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerMeta = const VerificationMeta('finger');
  @override
  late final GeneratedColumn<String> finger = GeneratedColumn<String>(
    'finger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyboardRowMeta = const VerificationMeta(
    'keyboardRow',
  );
  @override
  late final GeneratedColumn<String> keyboardRow = GeneratedColumn<String>(
    'keyboard_row',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dwellMicrosMeta = const VerificationMeta(
    'dwellMicros',
  );
  @override
  late final GeneratedColumn<int> dwellMicros = GeneratedColumn<int>(
    'dwell_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flightMicrosMeta = const VerificationMeta(
    'flightMicros',
  );
  @override
  late final GeneratedColumn<int> flightMicros = GeneratedColumn<int>(
    'flight_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thirdIndexMeta = const VerificationMeta(
    'thirdIndex',
  );
  @override
  late final GeneratedColumn<int> thirdIndex = GeneratedColumn<int>(
    'third_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    seq,
    sessionStartedAtUtcMicros,
    expectedChar,
    actualChar,
    result,
    isCorrection,
    physicalKeyId,
    finger,
    keyboardRow,
    dwellMicros,
    flightMicros,
    thirdIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'keystroke_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<KeystrokeEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('session_started_at_utc_micros')) {
      context.handle(
        _sessionStartedAtUtcMicrosMeta,
        sessionStartedAtUtcMicros.isAcceptableOrUnknown(
          data['session_started_at_utc_micros']!,
          _sessionStartedAtUtcMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionStartedAtUtcMicrosMeta);
    }
    if (data.containsKey('expected_char')) {
      context.handle(
        _expectedCharMeta,
        expectedChar.isAcceptableOrUnknown(
          data['expected_char']!,
          _expectedCharMeta,
        ),
      );
    }
    if (data.containsKey('actual_char')) {
      context.handle(
        _actualCharMeta,
        actualChar.isAcceptableOrUnknown(data['actual_char']!, _actualCharMeta),
      );
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('is_correction')) {
      context.handle(
        _isCorrectionMeta,
        isCorrection.isAcceptableOrUnknown(
          data['is_correction']!,
          _isCorrectionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isCorrectionMeta);
    }
    if (data.containsKey('physical_key_id')) {
      context.handle(
        _physicalKeyIdMeta,
        physicalKeyId.isAcceptableOrUnknown(
          data['physical_key_id']!,
          _physicalKeyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_physicalKeyIdMeta);
    }
    if (data.containsKey('finger')) {
      context.handle(
        _fingerMeta,
        finger.isAcceptableOrUnknown(data['finger']!, _fingerMeta),
      );
    } else if (isInserting) {
      context.missing(_fingerMeta);
    }
    if (data.containsKey('keyboard_row')) {
      context.handle(
        _keyboardRowMeta,
        keyboardRow.isAcceptableOrUnknown(
          data['keyboard_row']!,
          _keyboardRowMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_keyboardRowMeta);
    }
    if (data.containsKey('dwell_micros')) {
      context.handle(
        _dwellMicrosMeta,
        dwellMicros.isAcceptableOrUnknown(
          data['dwell_micros']!,
          _dwellMicrosMeta,
        ),
      );
    }
    if (data.containsKey('flight_micros')) {
      context.handle(
        _flightMicrosMeta,
        flightMicros.isAcceptableOrUnknown(
          data['flight_micros']!,
          _flightMicrosMeta,
        ),
      );
    }
    if (data.containsKey('third_index')) {
      context.handle(
        _thirdIndexMeta,
        thirdIndex.isAcceptableOrUnknown(data['third_index']!, _thirdIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_thirdIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, seq};
  @override
  KeystrokeEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeystrokeEventRow(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      sessionStartedAtUtcMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_started_at_utc_micros'],
      )!,
      expectedChar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expected_char'],
      ),
      actualChar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actual_char'],
      ),
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      isCorrection: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correction'],
      )!,
      physicalKeyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}physical_key_id'],
      )!,
      finger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finger'],
      )!,
      keyboardRow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyboard_row'],
      )!,
      dwellMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dwell_micros'],
      ),
      flightMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flight_micros'],
      ),
      thirdIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}third_index'],
      )!,
    );
  }

  @override
  $KeystrokeEventsTable createAlias(String alias) {
    return $KeystrokeEventsTable(attachedDatabase, alias);
  }
}

class KeystrokeEventRow extends DataClass
    implements Insertable<KeystrokeEventRow> {
  /// The owning session's `TypingSessionId` value.
  final String sessionId;

  /// Monotonically increasing per-session sequence number.
  final int seq;

  /// The owning session's start time, denormalized onto every row purely
  /// as an index/partition key (not a second source of truth) so
  /// window-bounded queries never need to join back to
  /// `typing_sessions` just to filter by recency.
  final int sessionStartedAtUtcMicros;

  /// The character expected at this position, or `null` for a pure
  /// insertion (no expected character) or when not applicable.
  final String? expectedChar;

  /// The character actually typed, or `null` for a correction event
  /// (nothing remains typed at that position after a backspace).
  final String? actualChar;

  /// `KeystrokeResult`'s enum name.
  final String result;

  /// Whether this row is a backspace/correction event rather than a
  /// forward-typed character.
  final bool isCorrection;

  /// `PhysicalKeyId`'s enum name.
  final String physicalKeyId;

  /// `Finger`'s enum name.
  final String finger;

  /// `KeyboardRow`'s enum name.
  final String keyboardRow;

  /// Key-down-to-key-up duration for this key, in microseconds, when the
  /// platform allows measuring it.
  final int? dwellMicros;

  /// Duration since the previous keydown, in microseconds.
  final int? flightMicros;

  /// Which third (0, 1, or 2) of the session this event falls in,
  /// precomputed once at finish time (SPEC.md §4.2's fatigue curve).
  final int thirdIndex;
  const KeystrokeEventRow({
    required this.sessionId,
    required this.seq,
    required this.sessionStartedAtUtcMicros,
    this.expectedChar,
    this.actualChar,
    required this.result,
    required this.isCorrection,
    required this.physicalKeyId,
    required this.finger,
    required this.keyboardRow,
    this.dwellMicros,
    this.flightMicros,
    required this.thirdIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['seq'] = Variable<int>(seq);
    map['session_started_at_utc_micros'] = Variable<int>(
      sessionStartedAtUtcMicros,
    );
    if (!nullToAbsent || expectedChar != null) {
      map['expected_char'] = Variable<String>(expectedChar);
    }
    if (!nullToAbsent || actualChar != null) {
      map['actual_char'] = Variable<String>(actualChar);
    }
    map['result'] = Variable<String>(result);
    map['is_correction'] = Variable<bool>(isCorrection);
    map['physical_key_id'] = Variable<String>(physicalKeyId);
    map['finger'] = Variable<String>(finger);
    map['keyboard_row'] = Variable<String>(keyboardRow);
    if (!nullToAbsent || dwellMicros != null) {
      map['dwell_micros'] = Variable<int>(dwellMicros);
    }
    if (!nullToAbsent || flightMicros != null) {
      map['flight_micros'] = Variable<int>(flightMicros);
    }
    map['third_index'] = Variable<int>(thirdIndex);
    return map;
  }

  KeystrokeEventsCompanion toCompanion(bool nullToAbsent) {
    return KeystrokeEventsCompanion(
      sessionId: Value(sessionId),
      seq: Value(seq),
      sessionStartedAtUtcMicros: Value(sessionStartedAtUtcMicros),
      expectedChar: expectedChar == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedChar),
      actualChar: actualChar == null && nullToAbsent
          ? const Value.absent()
          : Value(actualChar),
      result: Value(result),
      isCorrection: Value(isCorrection),
      physicalKeyId: Value(physicalKeyId),
      finger: Value(finger),
      keyboardRow: Value(keyboardRow),
      dwellMicros: dwellMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(dwellMicros),
      flightMicros: flightMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(flightMicros),
      thirdIndex: Value(thirdIndex),
    );
  }

  factory KeystrokeEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeystrokeEventRow(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      seq: serializer.fromJson<int>(json['seq']),
      sessionStartedAtUtcMicros: serializer.fromJson<int>(
        json['sessionStartedAtUtcMicros'],
      ),
      expectedChar: serializer.fromJson<String?>(json['expectedChar']),
      actualChar: serializer.fromJson<String?>(json['actualChar']),
      result: serializer.fromJson<String>(json['result']),
      isCorrection: serializer.fromJson<bool>(json['isCorrection']),
      physicalKeyId: serializer.fromJson<String>(json['physicalKeyId']),
      finger: serializer.fromJson<String>(json['finger']),
      keyboardRow: serializer.fromJson<String>(json['keyboardRow']),
      dwellMicros: serializer.fromJson<int?>(json['dwellMicros']),
      flightMicros: serializer.fromJson<int?>(json['flightMicros']),
      thirdIndex: serializer.fromJson<int>(json['thirdIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'seq': serializer.toJson<int>(seq),
      'sessionStartedAtUtcMicros': serializer.toJson<int>(
        sessionStartedAtUtcMicros,
      ),
      'expectedChar': serializer.toJson<String?>(expectedChar),
      'actualChar': serializer.toJson<String?>(actualChar),
      'result': serializer.toJson<String>(result),
      'isCorrection': serializer.toJson<bool>(isCorrection),
      'physicalKeyId': serializer.toJson<String>(physicalKeyId),
      'finger': serializer.toJson<String>(finger),
      'keyboardRow': serializer.toJson<String>(keyboardRow),
      'dwellMicros': serializer.toJson<int?>(dwellMicros),
      'flightMicros': serializer.toJson<int?>(flightMicros),
      'thirdIndex': serializer.toJson<int>(thirdIndex),
    };
  }

  KeystrokeEventRow copyWith({
    String? sessionId,
    int? seq,
    int? sessionStartedAtUtcMicros,
    Value<String?> expectedChar = const Value.absent(),
    Value<String?> actualChar = const Value.absent(),
    String? result,
    bool? isCorrection,
    String? physicalKeyId,
    String? finger,
    String? keyboardRow,
    Value<int?> dwellMicros = const Value.absent(),
    Value<int?> flightMicros = const Value.absent(),
    int? thirdIndex,
  }) => KeystrokeEventRow(
    sessionId: sessionId ?? this.sessionId,
    seq: seq ?? this.seq,
    sessionStartedAtUtcMicros:
        sessionStartedAtUtcMicros ?? this.sessionStartedAtUtcMicros,
    expectedChar: expectedChar.present ? expectedChar.value : this.expectedChar,
    actualChar: actualChar.present ? actualChar.value : this.actualChar,
    result: result ?? this.result,
    isCorrection: isCorrection ?? this.isCorrection,
    physicalKeyId: physicalKeyId ?? this.physicalKeyId,
    finger: finger ?? this.finger,
    keyboardRow: keyboardRow ?? this.keyboardRow,
    dwellMicros: dwellMicros.present ? dwellMicros.value : this.dwellMicros,
    flightMicros: flightMicros.present ? flightMicros.value : this.flightMicros,
    thirdIndex: thirdIndex ?? this.thirdIndex,
  );
  KeystrokeEventRow copyWithCompanion(KeystrokeEventsCompanion data) {
    return KeystrokeEventRow(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      seq: data.seq.present ? data.seq.value : this.seq,
      sessionStartedAtUtcMicros: data.sessionStartedAtUtcMicros.present
          ? data.sessionStartedAtUtcMicros.value
          : this.sessionStartedAtUtcMicros,
      expectedChar: data.expectedChar.present
          ? data.expectedChar.value
          : this.expectedChar,
      actualChar: data.actualChar.present
          ? data.actualChar.value
          : this.actualChar,
      result: data.result.present ? data.result.value : this.result,
      isCorrection: data.isCorrection.present
          ? data.isCorrection.value
          : this.isCorrection,
      physicalKeyId: data.physicalKeyId.present
          ? data.physicalKeyId.value
          : this.physicalKeyId,
      finger: data.finger.present ? data.finger.value : this.finger,
      keyboardRow: data.keyboardRow.present
          ? data.keyboardRow.value
          : this.keyboardRow,
      dwellMicros: data.dwellMicros.present
          ? data.dwellMicros.value
          : this.dwellMicros,
      flightMicros: data.flightMicros.present
          ? data.flightMicros.value
          : this.flightMicros,
      thirdIndex: data.thirdIndex.present
          ? data.thirdIndex.value
          : this.thirdIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeystrokeEventRow(')
          ..write('sessionId: $sessionId, ')
          ..write('seq: $seq, ')
          ..write('sessionStartedAtUtcMicros: $sessionStartedAtUtcMicros, ')
          ..write('expectedChar: $expectedChar, ')
          ..write('actualChar: $actualChar, ')
          ..write('result: $result, ')
          ..write('isCorrection: $isCorrection, ')
          ..write('physicalKeyId: $physicalKeyId, ')
          ..write('finger: $finger, ')
          ..write('keyboardRow: $keyboardRow, ')
          ..write('dwellMicros: $dwellMicros, ')
          ..write('flightMicros: $flightMicros, ')
          ..write('thirdIndex: $thirdIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    seq,
    sessionStartedAtUtcMicros,
    expectedChar,
    actualChar,
    result,
    isCorrection,
    physicalKeyId,
    finger,
    keyboardRow,
    dwellMicros,
    flightMicros,
    thirdIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeystrokeEventRow &&
          other.sessionId == this.sessionId &&
          other.seq == this.seq &&
          other.sessionStartedAtUtcMicros == this.sessionStartedAtUtcMicros &&
          other.expectedChar == this.expectedChar &&
          other.actualChar == this.actualChar &&
          other.result == this.result &&
          other.isCorrection == this.isCorrection &&
          other.physicalKeyId == this.physicalKeyId &&
          other.finger == this.finger &&
          other.keyboardRow == this.keyboardRow &&
          other.dwellMicros == this.dwellMicros &&
          other.flightMicros == this.flightMicros &&
          other.thirdIndex == this.thirdIndex);
}

class KeystrokeEventsCompanion extends UpdateCompanion<KeystrokeEventRow> {
  final Value<String> sessionId;
  final Value<int> seq;
  final Value<int> sessionStartedAtUtcMicros;
  final Value<String?> expectedChar;
  final Value<String?> actualChar;
  final Value<String> result;
  final Value<bool> isCorrection;
  final Value<String> physicalKeyId;
  final Value<String> finger;
  final Value<String> keyboardRow;
  final Value<int?> dwellMicros;
  final Value<int?> flightMicros;
  final Value<int> thirdIndex;
  final Value<int> rowid;
  const KeystrokeEventsCompanion({
    this.sessionId = const Value.absent(),
    this.seq = const Value.absent(),
    this.sessionStartedAtUtcMicros = const Value.absent(),
    this.expectedChar = const Value.absent(),
    this.actualChar = const Value.absent(),
    this.result = const Value.absent(),
    this.isCorrection = const Value.absent(),
    this.physicalKeyId = const Value.absent(),
    this.finger = const Value.absent(),
    this.keyboardRow = const Value.absent(),
    this.dwellMicros = const Value.absent(),
    this.flightMicros = const Value.absent(),
    this.thirdIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeystrokeEventsCompanion.insert({
    required String sessionId,
    required int seq,
    required int sessionStartedAtUtcMicros,
    this.expectedChar = const Value.absent(),
    this.actualChar = const Value.absent(),
    required String result,
    required bool isCorrection,
    required String physicalKeyId,
    required String finger,
    required String keyboardRow,
    this.dwellMicros = const Value.absent(),
    this.flightMicros = const Value.absent(),
    required int thirdIndex,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       seq = Value(seq),
       sessionStartedAtUtcMicros = Value(sessionStartedAtUtcMicros),
       result = Value(result),
       isCorrection = Value(isCorrection),
       physicalKeyId = Value(physicalKeyId),
       finger = Value(finger),
       keyboardRow = Value(keyboardRow),
       thirdIndex = Value(thirdIndex);
  static Insertable<KeystrokeEventRow> custom({
    Expression<String>? sessionId,
    Expression<int>? seq,
    Expression<int>? sessionStartedAtUtcMicros,
    Expression<String>? expectedChar,
    Expression<String>? actualChar,
    Expression<String>? result,
    Expression<bool>? isCorrection,
    Expression<String>? physicalKeyId,
    Expression<String>? finger,
    Expression<String>? keyboardRow,
    Expression<int>? dwellMicros,
    Expression<int>? flightMicros,
    Expression<int>? thirdIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (seq != null) 'seq': seq,
      if (sessionStartedAtUtcMicros != null)
        'session_started_at_utc_micros': sessionStartedAtUtcMicros,
      if (expectedChar != null) 'expected_char': expectedChar,
      if (actualChar != null) 'actual_char': actualChar,
      if (result != null) 'result': result,
      if (isCorrection != null) 'is_correction': isCorrection,
      if (physicalKeyId != null) 'physical_key_id': physicalKeyId,
      if (finger != null) 'finger': finger,
      if (keyboardRow != null) 'keyboard_row': keyboardRow,
      if (dwellMicros != null) 'dwell_micros': dwellMicros,
      if (flightMicros != null) 'flight_micros': flightMicros,
      if (thirdIndex != null) 'third_index': thirdIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeystrokeEventsCompanion copyWith({
    Value<String>? sessionId,
    Value<int>? seq,
    Value<int>? sessionStartedAtUtcMicros,
    Value<String?>? expectedChar,
    Value<String?>? actualChar,
    Value<String>? result,
    Value<bool>? isCorrection,
    Value<String>? physicalKeyId,
    Value<String>? finger,
    Value<String>? keyboardRow,
    Value<int?>? dwellMicros,
    Value<int?>? flightMicros,
    Value<int>? thirdIndex,
    Value<int>? rowid,
  }) {
    return KeystrokeEventsCompanion(
      sessionId: sessionId ?? this.sessionId,
      seq: seq ?? this.seq,
      sessionStartedAtUtcMicros:
          sessionStartedAtUtcMicros ?? this.sessionStartedAtUtcMicros,
      expectedChar: expectedChar ?? this.expectedChar,
      actualChar: actualChar ?? this.actualChar,
      result: result ?? this.result,
      isCorrection: isCorrection ?? this.isCorrection,
      physicalKeyId: physicalKeyId ?? this.physicalKeyId,
      finger: finger ?? this.finger,
      keyboardRow: keyboardRow ?? this.keyboardRow,
      dwellMicros: dwellMicros ?? this.dwellMicros,
      flightMicros: flightMicros ?? this.flightMicros,
      thirdIndex: thirdIndex ?? this.thirdIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (sessionStartedAtUtcMicros.present) {
      map['session_started_at_utc_micros'] = Variable<int>(
        sessionStartedAtUtcMicros.value,
      );
    }
    if (expectedChar.present) {
      map['expected_char'] = Variable<String>(expectedChar.value);
    }
    if (actualChar.present) {
      map['actual_char'] = Variable<String>(actualChar.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (isCorrection.present) {
      map['is_correction'] = Variable<bool>(isCorrection.value);
    }
    if (physicalKeyId.present) {
      map['physical_key_id'] = Variable<String>(physicalKeyId.value);
    }
    if (finger.present) {
      map['finger'] = Variable<String>(finger.value);
    }
    if (keyboardRow.present) {
      map['keyboard_row'] = Variable<String>(keyboardRow.value);
    }
    if (dwellMicros.present) {
      map['dwell_micros'] = Variable<int>(dwellMicros.value);
    }
    if (flightMicros.present) {
      map['flight_micros'] = Variable<int>(flightMicros.value);
    }
    if (thirdIndex.present) {
      map['third_index'] = Variable<int>(thirdIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeystrokeEventsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('seq: $seq, ')
          ..write('sessionStartedAtUtcMicros: $sessionStartedAtUtcMicros, ')
          ..write('expectedChar: $expectedChar, ')
          ..write('actualChar: $actualChar, ')
          ..write('result: $result, ')
          ..write('isCorrection: $isCorrection, ')
          ..write('physicalKeyId: $physicalKeyId, ')
          ..write('finger: $finger, ')
          ..write('keyboardRow: $keyboardRow, ')
          ..write('dwellMicros: $dwellMicros, ')
          ..write('flightMicros: $flightMicros, ')
          ..write('thirdIndex: $thirdIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressSnapshotCacheTable extends ProgressSnapshotCache
    with TableInfo<$ProgressSnapshotCacheTable, ProgressSnapshotCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressSnapshotCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalXpMeta = const VerificationMeta(
    'totalXp',
  );
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
    'total_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpAtCurrentLevelMeta = const VerificationMeta(
    'xpAtCurrentLevel',
  );
  @override
  late final GeneratedColumn<int> xpAtCurrentLevel = GeneratedColumn<int>(
    'xp_at_current_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpForNextLevelMeta = const VerificationMeta(
    'xpForNextLevel',
  );
  @override
  late final GeneratedColumn<int> xpForNextLevel = GeneratedColumn<int>(
    'xp_for_next_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStreakDaysMeta = const VerificationMeta(
    'currentStreakDays',
  );
  @override
  late final GeneratedColumn<int> currentStreakDays = GeneratedColumn<int>(
    'current_streak_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weaknessReportJsonMeta =
      const VerificationMeta('weaknessReportJson');
  @override
  late final GeneratedColumn<String> weaknessReportJson =
      GeneratedColumn<String>(
        'weakness_report_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _activityReportJsonMeta =
      const VerificationMeta('activityReportJson');
  @override
  late final GeneratedColumn<String> activityReportJson =
      GeneratedColumn<String>(
        'activity_report_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _computedAtUtcMicrosMeta =
      const VerificationMeta('computedAtUtcMicros');
  @override
  late final GeneratedColumn<int> computedAtUtcMicros = GeneratedColumn<int>(
    'computed_at_utc_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    totalXp,
    level,
    xpAtCurrentLevel,
    xpForNextLevel,
    currentStreakDays,
    weaknessReportJson,
    activityReportJson,
    computedAtUtcMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_snapshot_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressSnapshotCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('total_xp')) {
      context.handle(
        _totalXpMeta,
        totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta),
      );
    } else if (isInserting) {
      context.missing(_totalXpMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('xp_at_current_level')) {
      context.handle(
        _xpAtCurrentLevelMeta,
        xpAtCurrentLevel.isAcceptableOrUnknown(
          data['xp_at_current_level']!,
          _xpAtCurrentLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_xpAtCurrentLevelMeta);
    }
    if (data.containsKey('xp_for_next_level')) {
      context.handle(
        _xpForNextLevelMeta,
        xpForNextLevel.isAcceptableOrUnknown(
          data['xp_for_next_level']!,
          _xpForNextLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_xpForNextLevelMeta);
    }
    if (data.containsKey('current_streak_days')) {
      context.handle(
        _currentStreakDaysMeta,
        currentStreakDays.isAcceptableOrUnknown(
          data['current_streak_days']!,
          _currentStreakDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentStreakDaysMeta);
    }
    if (data.containsKey('weakness_report_json')) {
      context.handle(
        _weaknessReportJsonMeta,
        weaknessReportJson.isAcceptableOrUnknown(
          data['weakness_report_json']!,
          _weaknessReportJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weaknessReportJsonMeta);
    }
    if (data.containsKey('activity_report_json')) {
      context.handle(
        _activityReportJsonMeta,
        activityReportJson.isAcceptableOrUnknown(
          data['activity_report_json']!,
          _activityReportJsonMeta,
        ),
      );
    }
    if (data.containsKey('computed_at_utc_micros')) {
      context.handle(
        _computedAtUtcMicrosMeta,
        computedAtUtcMicros.isAcceptableOrUnknown(
          data['computed_at_utc_micros']!,
          _computedAtUtcMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_computedAtUtcMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  ProgressSnapshotCacheRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressSnapshotCacheRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      totalXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_xp'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      xpAtCurrentLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_at_current_level'],
      )!,
      xpForNextLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_for_next_level'],
      )!,
      currentStreakDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak_days'],
      )!,
      weaknessReportJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weakness_report_json'],
      )!,
      activityReportJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_report_json'],
      ),
      computedAtUtcMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}computed_at_utc_micros'],
      )!,
    );
  }

  @override
  $ProgressSnapshotCacheTable createAlias(String alias) {
    return $ProgressSnapshotCacheTable(attachedDatabase, alias);
  }
}

class ProgressSnapshotCacheRow extends DataClass
    implements Insertable<ProgressSnapshotCacheRow> {
  /// The `ProfileId` this snapshot belongs to — one row per profile.
  final String profileId;

  /// Lifetime XP total.
  final int totalXp;

  /// Current account level.
  final int level;

  /// The XP threshold the current level started at.
  final int xpAtCurrentLevel;

  /// The XP threshold the next level requires.
  final int xpForNextLevel;

  /// Consecutive local-calendar days with at least one finished session.
  final int currentStreakDays;

  /// JSON-encoded `WeaknessReportDto` — see this table's class doc.
  final String weaknessReportJson;

  /// JSON-encoded `ActivityReportDto`, same blob-cache reasoning as
  /// [weaknessReportJson]. Nullable because it was added in a later
  /// migration than this table itself — rows cached before that
  /// migration have no value until the next recompute backfills one;
  /// `null` maps to `ActivityReport.empty` in the meantime.
  final String? activityReportJson;

  /// When this snapshot was computed, as UTC microseconds since epoch.
  final int computedAtUtcMicros;
  const ProgressSnapshotCacheRow({
    required this.profileId,
    required this.totalXp,
    required this.level,
    required this.xpAtCurrentLevel,
    required this.xpForNextLevel,
    required this.currentStreakDays,
    required this.weaknessReportJson,
    this.activityReportJson,
    required this.computedAtUtcMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['total_xp'] = Variable<int>(totalXp);
    map['level'] = Variable<int>(level);
    map['xp_at_current_level'] = Variable<int>(xpAtCurrentLevel);
    map['xp_for_next_level'] = Variable<int>(xpForNextLevel);
    map['current_streak_days'] = Variable<int>(currentStreakDays);
    map['weakness_report_json'] = Variable<String>(weaknessReportJson);
    if (!nullToAbsent || activityReportJson != null) {
      map['activity_report_json'] = Variable<String>(activityReportJson);
    }
    map['computed_at_utc_micros'] = Variable<int>(computedAtUtcMicros);
    return map;
  }

  ProgressSnapshotCacheCompanion toCompanion(bool nullToAbsent) {
    return ProgressSnapshotCacheCompanion(
      profileId: Value(profileId),
      totalXp: Value(totalXp),
      level: Value(level),
      xpAtCurrentLevel: Value(xpAtCurrentLevel),
      xpForNextLevel: Value(xpForNextLevel),
      currentStreakDays: Value(currentStreakDays),
      weaknessReportJson: Value(weaknessReportJson),
      activityReportJson: activityReportJson == null && nullToAbsent
          ? const Value.absent()
          : Value(activityReportJson),
      computedAtUtcMicros: Value(computedAtUtcMicros),
    );
  }

  factory ProgressSnapshotCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressSnapshotCacheRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
      level: serializer.fromJson<int>(json['level']),
      xpAtCurrentLevel: serializer.fromJson<int>(json['xpAtCurrentLevel']),
      xpForNextLevel: serializer.fromJson<int>(json['xpForNextLevel']),
      currentStreakDays: serializer.fromJson<int>(json['currentStreakDays']),
      weaknessReportJson: serializer.fromJson<String>(
        json['weaknessReportJson'],
      ),
      activityReportJson: serializer.fromJson<String?>(
        json['activityReportJson'],
      ),
      computedAtUtcMicros: serializer.fromJson<int>(
        json['computedAtUtcMicros'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'totalXp': serializer.toJson<int>(totalXp),
      'level': serializer.toJson<int>(level),
      'xpAtCurrentLevel': serializer.toJson<int>(xpAtCurrentLevel),
      'xpForNextLevel': serializer.toJson<int>(xpForNextLevel),
      'currentStreakDays': serializer.toJson<int>(currentStreakDays),
      'weaknessReportJson': serializer.toJson<String>(weaknessReportJson),
      'activityReportJson': serializer.toJson<String?>(activityReportJson),
      'computedAtUtcMicros': serializer.toJson<int>(computedAtUtcMicros),
    };
  }

  ProgressSnapshotCacheRow copyWith({
    String? profileId,
    int? totalXp,
    int? level,
    int? xpAtCurrentLevel,
    int? xpForNextLevel,
    int? currentStreakDays,
    String? weaknessReportJson,
    Value<String?> activityReportJson = const Value.absent(),
    int? computedAtUtcMicros,
  }) => ProgressSnapshotCacheRow(
    profileId: profileId ?? this.profileId,
    totalXp: totalXp ?? this.totalXp,
    level: level ?? this.level,
    xpAtCurrentLevel: xpAtCurrentLevel ?? this.xpAtCurrentLevel,
    xpForNextLevel: xpForNextLevel ?? this.xpForNextLevel,
    currentStreakDays: currentStreakDays ?? this.currentStreakDays,
    weaknessReportJson: weaknessReportJson ?? this.weaknessReportJson,
    activityReportJson: activityReportJson.present
        ? activityReportJson.value
        : this.activityReportJson,
    computedAtUtcMicros: computedAtUtcMicros ?? this.computedAtUtcMicros,
  );
  ProgressSnapshotCacheRow copyWithCompanion(
    ProgressSnapshotCacheCompanion data,
  ) {
    return ProgressSnapshotCacheRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
      level: data.level.present ? data.level.value : this.level,
      xpAtCurrentLevel: data.xpAtCurrentLevel.present
          ? data.xpAtCurrentLevel.value
          : this.xpAtCurrentLevel,
      xpForNextLevel: data.xpForNextLevel.present
          ? data.xpForNextLevel.value
          : this.xpForNextLevel,
      currentStreakDays: data.currentStreakDays.present
          ? data.currentStreakDays.value
          : this.currentStreakDays,
      weaknessReportJson: data.weaknessReportJson.present
          ? data.weaknessReportJson.value
          : this.weaknessReportJson,
      activityReportJson: data.activityReportJson.present
          ? data.activityReportJson.value
          : this.activityReportJson,
      computedAtUtcMicros: data.computedAtUtcMicros.present
          ? data.computedAtUtcMicros.value
          : this.computedAtUtcMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressSnapshotCacheRow(')
          ..write('profileId: $profileId, ')
          ..write('totalXp: $totalXp, ')
          ..write('level: $level, ')
          ..write('xpAtCurrentLevel: $xpAtCurrentLevel, ')
          ..write('xpForNextLevel: $xpForNextLevel, ')
          ..write('currentStreakDays: $currentStreakDays, ')
          ..write('weaknessReportJson: $weaknessReportJson, ')
          ..write('activityReportJson: $activityReportJson, ')
          ..write('computedAtUtcMicros: $computedAtUtcMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    totalXp,
    level,
    xpAtCurrentLevel,
    xpForNextLevel,
    currentStreakDays,
    weaknessReportJson,
    activityReportJson,
    computedAtUtcMicros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressSnapshotCacheRow &&
          other.profileId == this.profileId &&
          other.totalXp == this.totalXp &&
          other.level == this.level &&
          other.xpAtCurrentLevel == this.xpAtCurrentLevel &&
          other.xpForNextLevel == this.xpForNextLevel &&
          other.currentStreakDays == this.currentStreakDays &&
          other.weaknessReportJson == this.weaknessReportJson &&
          other.activityReportJson == this.activityReportJson &&
          other.computedAtUtcMicros == this.computedAtUtcMicros);
}

class ProgressSnapshotCacheCompanion
    extends UpdateCompanion<ProgressSnapshotCacheRow> {
  final Value<String> profileId;
  final Value<int> totalXp;
  final Value<int> level;
  final Value<int> xpAtCurrentLevel;
  final Value<int> xpForNextLevel;
  final Value<int> currentStreakDays;
  final Value<String> weaknessReportJson;
  final Value<String?> activityReportJson;
  final Value<int> computedAtUtcMicros;
  final Value<int> rowid;
  const ProgressSnapshotCacheCompanion({
    this.profileId = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.level = const Value.absent(),
    this.xpAtCurrentLevel = const Value.absent(),
    this.xpForNextLevel = const Value.absent(),
    this.currentStreakDays = const Value.absent(),
    this.weaknessReportJson = const Value.absent(),
    this.activityReportJson = const Value.absent(),
    this.computedAtUtcMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressSnapshotCacheCompanion.insert({
    required String profileId,
    required int totalXp,
    required int level,
    required int xpAtCurrentLevel,
    required int xpForNextLevel,
    required int currentStreakDays,
    required String weaknessReportJson,
    this.activityReportJson = const Value.absent(),
    required int computedAtUtcMicros,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       totalXp = Value(totalXp),
       level = Value(level),
       xpAtCurrentLevel = Value(xpAtCurrentLevel),
       xpForNextLevel = Value(xpForNextLevel),
       currentStreakDays = Value(currentStreakDays),
       weaknessReportJson = Value(weaknessReportJson),
       computedAtUtcMicros = Value(computedAtUtcMicros);
  static Insertable<ProgressSnapshotCacheRow> custom({
    Expression<String>? profileId,
    Expression<int>? totalXp,
    Expression<int>? level,
    Expression<int>? xpAtCurrentLevel,
    Expression<int>? xpForNextLevel,
    Expression<int>? currentStreakDays,
    Expression<String>? weaknessReportJson,
    Expression<String>? activityReportJson,
    Expression<int>? computedAtUtcMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (totalXp != null) 'total_xp': totalXp,
      if (level != null) 'level': level,
      if (xpAtCurrentLevel != null) 'xp_at_current_level': xpAtCurrentLevel,
      if (xpForNextLevel != null) 'xp_for_next_level': xpForNextLevel,
      if (currentStreakDays != null) 'current_streak_days': currentStreakDays,
      if (weaknessReportJson != null)
        'weakness_report_json': weaknessReportJson,
      if (activityReportJson != null)
        'activity_report_json': activityReportJson,
      if (computedAtUtcMicros != null)
        'computed_at_utc_micros': computedAtUtcMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressSnapshotCacheCompanion copyWith({
    Value<String>? profileId,
    Value<int>? totalXp,
    Value<int>? level,
    Value<int>? xpAtCurrentLevel,
    Value<int>? xpForNextLevel,
    Value<int>? currentStreakDays,
    Value<String>? weaknessReportJson,
    Value<String?>? activityReportJson,
    Value<int>? computedAtUtcMicros,
    Value<int>? rowid,
  }) {
    return ProgressSnapshotCacheCompanion(
      profileId: profileId ?? this.profileId,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      xpAtCurrentLevel: xpAtCurrentLevel ?? this.xpAtCurrentLevel,
      xpForNextLevel: xpForNextLevel ?? this.xpForNextLevel,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      weaknessReportJson: weaknessReportJson ?? this.weaknessReportJson,
      activityReportJson: activityReportJson ?? this.activityReportJson,
      computedAtUtcMicros: computedAtUtcMicros ?? this.computedAtUtcMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (xpAtCurrentLevel.present) {
      map['xp_at_current_level'] = Variable<int>(xpAtCurrentLevel.value);
    }
    if (xpForNextLevel.present) {
      map['xp_for_next_level'] = Variable<int>(xpForNextLevel.value);
    }
    if (currentStreakDays.present) {
      map['current_streak_days'] = Variable<int>(currentStreakDays.value);
    }
    if (weaknessReportJson.present) {
      map['weakness_report_json'] = Variable<String>(weaknessReportJson.value);
    }
    if (activityReportJson.present) {
      map['activity_report_json'] = Variable<String>(activityReportJson.value);
    }
    if (computedAtUtcMicros.present) {
      map['computed_at_utc_micros'] = Variable<int>(computedAtUtcMicros.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressSnapshotCacheCompanion(')
          ..write('profileId: $profileId, ')
          ..write('totalXp: $totalXp, ')
          ..write('level: $level, ')
          ..write('xpAtCurrentLevel: $xpAtCurrentLevel, ')
          ..write('xpForNextLevel: $xpForNextLevel, ')
          ..write('currentStreakDays: $currentStreakDays, ')
          ..write('weaknessReportJson: $weaknessReportJson, ')
          ..write('activityReportJson: $activityReportJson, ')
          ..write('computedAtUtcMicros: $computedAtUtcMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MasteryStatusCacheTable extends MasteryStatusCache
    with TableInfo<$MasteryStatusCacheTable, MasteryStatusCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasteryStatusCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMasteredMeta = const VerificationMeta(
    'isMastered',
  );
  @override
  late final GeneratedColumn<bool> isMastered = GeneratedColumn<bool>(
    'is_mastered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mastered" IN (0, 1))',
    ),
  );
  static const VerificationMeta _passCountInLastFiveMeta =
      const VerificationMeta('passCountInLastFive');
  @override
  late final GeneratedColumn<int> passCountInLastFive = GeneratedColumn<int>(
    'pass_count_in_last_five',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _evaluatedAtUtcMicrosMeta =
      const VerificationMeta('evaluatedAtUtcMicros');
  @override
  late final GeneratedColumn<int> evaluatedAtUtcMicros = GeneratedColumn<int>(
    'evaluated_at_utc_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    category,
    difficulty,
    isMastered,
    passCountInLastFive,
    evaluatedAtUtcMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mastery_status_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<MasteryStatusCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('is_mastered')) {
      context.handle(
        _isMasteredMeta,
        isMastered.isAcceptableOrUnknown(data['is_mastered']!, _isMasteredMeta),
      );
    } else if (isInserting) {
      context.missing(_isMasteredMeta);
    }
    if (data.containsKey('pass_count_in_last_five')) {
      context.handle(
        _passCountInLastFiveMeta,
        passCountInLastFive.isAcceptableOrUnknown(
          data['pass_count_in_last_five']!,
          _passCountInLastFiveMeta,
        ),
      );
    }
    if (data.containsKey('evaluated_at_utc_micros')) {
      context.handle(
        _evaluatedAtUtcMicrosMeta,
        evaluatedAtUtcMicros.isAcceptableOrUnknown(
          data['evaluated_at_utc_micros']!,
          _evaluatedAtUtcMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_evaluatedAtUtcMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, category, difficulty};
  @override
  MasteryStatusCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasteryStatusCacheRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      isMastered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_mastered'],
      )!,
      passCountInLastFive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pass_count_in_last_five'],
      ),
      evaluatedAtUtcMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evaluated_at_utc_micros'],
      )!,
    );
  }

  @override
  $MasteryStatusCacheTable createAlias(String alias) {
    return $MasteryStatusCacheTable(attachedDatabase, alias);
  }
}

class MasteryStatusCacheRow extends DataClass
    implements Insertable<MasteryStatusCacheRow> {
  /// The `ProfileId` this status belongs to.
  final String profileId;

  /// `ContentCategory`'s enum name.
  final String category;

  /// `Difficulty`'s enum name.
  final String difficulty;

  /// Whether this (category, difficulty) is currently certified as
  /// mastered.
  final bool isMastered;

  /// How many of the trailing 5 Precision results passed — `null` when
  /// fewer than 5 have ever been played (not enough history to certify
  /// or decay yet).
  final int? passCountInLastFive;

  /// When this status was last evaluated, as UTC microseconds since
  /// epoch.
  final int evaluatedAtUtcMicros;
  const MasteryStatusCacheRow({
    required this.profileId,
    required this.category,
    required this.difficulty,
    required this.isMastered,
    this.passCountInLastFive,
    required this.evaluatedAtUtcMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['category'] = Variable<String>(category);
    map['difficulty'] = Variable<String>(difficulty);
    map['is_mastered'] = Variable<bool>(isMastered);
    if (!nullToAbsent || passCountInLastFive != null) {
      map['pass_count_in_last_five'] = Variable<int>(passCountInLastFive);
    }
    map['evaluated_at_utc_micros'] = Variable<int>(evaluatedAtUtcMicros);
    return map;
  }

  MasteryStatusCacheCompanion toCompanion(bool nullToAbsent) {
    return MasteryStatusCacheCompanion(
      profileId: Value(profileId),
      category: Value(category),
      difficulty: Value(difficulty),
      isMastered: Value(isMastered),
      passCountInLastFive: passCountInLastFive == null && nullToAbsent
          ? const Value.absent()
          : Value(passCountInLastFive),
      evaluatedAtUtcMicros: Value(evaluatedAtUtcMicros),
    );
  }

  factory MasteryStatusCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasteryStatusCacheRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      category: serializer.fromJson<String>(json['category']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      isMastered: serializer.fromJson<bool>(json['isMastered']),
      passCountInLastFive: serializer.fromJson<int?>(
        json['passCountInLastFive'],
      ),
      evaluatedAtUtcMicros: serializer.fromJson<int>(
        json['evaluatedAtUtcMicros'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'category': serializer.toJson<String>(category),
      'difficulty': serializer.toJson<String>(difficulty),
      'isMastered': serializer.toJson<bool>(isMastered),
      'passCountInLastFive': serializer.toJson<int?>(passCountInLastFive),
      'evaluatedAtUtcMicros': serializer.toJson<int>(evaluatedAtUtcMicros),
    };
  }

  MasteryStatusCacheRow copyWith({
    String? profileId,
    String? category,
    String? difficulty,
    bool? isMastered,
    Value<int?> passCountInLastFive = const Value.absent(),
    int? evaluatedAtUtcMicros,
  }) => MasteryStatusCacheRow(
    profileId: profileId ?? this.profileId,
    category: category ?? this.category,
    difficulty: difficulty ?? this.difficulty,
    isMastered: isMastered ?? this.isMastered,
    passCountInLastFive: passCountInLastFive.present
        ? passCountInLastFive.value
        : this.passCountInLastFive,
    evaluatedAtUtcMicros: evaluatedAtUtcMicros ?? this.evaluatedAtUtcMicros,
  );
  MasteryStatusCacheRow copyWithCompanion(MasteryStatusCacheCompanion data) {
    return MasteryStatusCacheRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      category: data.category.present ? data.category.value : this.category,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      isMastered: data.isMastered.present
          ? data.isMastered.value
          : this.isMastered,
      passCountInLastFive: data.passCountInLastFive.present
          ? data.passCountInLastFive.value
          : this.passCountInLastFive,
      evaluatedAtUtcMicros: data.evaluatedAtUtcMicros.present
          ? data.evaluatedAtUtcMicros.value
          : this.evaluatedAtUtcMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasteryStatusCacheRow(')
          ..write('profileId: $profileId, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('isMastered: $isMastered, ')
          ..write('passCountInLastFive: $passCountInLastFive, ')
          ..write('evaluatedAtUtcMicros: $evaluatedAtUtcMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    category,
    difficulty,
    isMastered,
    passCountInLastFive,
    evaluatedAtUtcMicros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasteryStatusCacheRow &&
          other.profileId == this.profileId &&
          other.category == this.category &&
          other.difficulty == this.difficulty &&
          other.isMastered == this.isMastered &&
          other.passCountInLastFive == this.passCountInLastFive &&
          other.evaluatedAtUtcMicros == this.evaluatedAtUtcMicros);
}

class MasteryStatusCacheCompanion
    extends UpdateCompanion<MasteryStatusCacheRow> {
  final Value<String> profileId;
  final Value<String> category;
  final Value<String> difficulty;
  final Value<bool> isMastered;
  final Value<int?> passCountInLastFive;
  final Value<int> evaluatedAtUtcMicros;
  final Value<int> rowid;
  const MasteryStatusCacheCompanion({
    this.profileId = const Value.absent(),
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.isMastered = const Value.absent(),
    this.passCountInLastFive = const Value.absent(),
    this.evaluatedAtUtcMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasteryStatusCacheCompanion.insert({
    required String profileId,
    required String category,
    required String difficulty,
    required bool isMastered,
    this.passCountInLastFive = const Value.absent(),
    required int evaluatedAtUtcMicros,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       category = Value(category),
       difficulty = Value(difficulty),
       isMastered = Value(isMastered),
       evaluatedAtUtcMicros = Value(evaluatedAtUtcMicros);
  static Insertable<MasteryStatusCacheRow> custom({
    Expression<String>? profileId,
    Expression<String>? category,
    Expression<String>? difficulty,
    Expression<bool>? isMastered,
    Expression<int>? passCountInLastFive,
    Expression<int>? evaluatedAtUtcMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
      if (isMastered != null) 'is_mastered': isMastered,
      if (passCountInLastFive != null)
        'pass_count_in_last_five': passCountInLastFive,
      if (evaluatedAtUtcMicros != null)
        'evaluated_at_utc_micros': evaluatedAtUtcMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MasteryStatusCacheCompanion copyWith({
    Value<String>? profileId,
    Value<String>? category,
    Value<String>? difficulty,
    Value<bool>? isMastered,
    Value<int?>? passCountInLastFive,
    Value<int>? evaluatedAtUtcMicros,
    Value<int>? rowid,
  }) {
    return MasteryStatusCacheCompanion(
      profileId: profileId ?? this.profileId,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      isMastered: isMastered ?? this.isMastered,
      passCountInLastFive: passCountInLastFive ?? this.passCountInLastFive,
      evaluatedAtUtcMicros: evaluatedAtUtcMicros ?? this.evaluatedAtUtcMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (isMastered.present) {
      map['is_mastered'] = Variable<bool>(isMastered.value);
    }
    if (passCountInLastFive.present) {
      map['pass_count_in_last_five'] = Variable<int>(passCountInLastFive.value);
    }
    if (evaluatedAtUtcMicros.present) {
      map['evaluated_at_utc_micros'] = Variable<int>(
        evaluatedAtUtcMicros.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasteryStatusCacheCompanion(')
          ..write('profileId: $profileId, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('isMastered: $isMastered, ')
          ..write('passCountInLastFive: $passCountInLastFive, ')
          ..write('evaluatedAtUtcMicros: $evaluatedAtUtcMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProcessedSessionsTable extends ProcessedSessions
    with TableInfo<$ProcessedSessionsTable, ProcessedSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProcessedSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processedAtUtcMicrosMeta =
      const VerificationMeta('processedAtUtcMicros');
  @override
  late final GeneratedColumn<int> processedAtUtcMicros = GeneratedColumn<int>(
    'processed_at_utc_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    profileId,
    processedAtUtcMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'processed_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProcessedSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('processed_at_utc_micros')) {
      context.handle(
        _processedAtUtcMicrosMeta,
        processedAtUtcMicros.isAcceptableOrUnknown(
          data['processed_at_utc_micros']!,
          _processedAtUtcMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processedAtUtcMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  ProcessedSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProcessedSessionRow(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      processedAtUtcMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processed_at_utc_micros'],
      )!,
    );
  }

  @override
  $ProcessedSessionsTable createAlias(String alias) {
    return $ProcessedSessionsTable(attachedDatabase, alias);
  }
}

class ProcessedSessionRow extends DataClass
    implements Insertable<ProcessedSessionRow> {
  /// The `TypingSessionId` value of the session this row marks processed.
  final String sessionId;

  /// The `ProfileId` that session belongs to, denormalized so a
  /// per-profile lookup never needs to join back to `typing_sessions`.
  final String profileId;

  /// When this session was processed, as UTC microseconds since epoch.
  final int processedAtUtcMicros;
  const ProcessedSessionRow({
    required this.sessionId,
    required this.profileId,
    required this.processedAtUtcMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['profile_id'] = Variable<String>(profileId);
    map['processed_at_utc_micros'] = Variable<int>(processedAtUtcMicros);
    return map;
  }

  ProcessedSessionsCompanion toCompanion(bool nullToAbsent) {
    return ProcessedSessionsCompanion(
      sessionId: Value(sessionId),
      profileId: Value(profileId),
      processedAtUtcMicros: Value(processedAtUtcMicros),
    );
  }

  factory ProcessedSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProcessedSessionRow(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      processedAtUtcMicros: serializer.fromJson<int>(
        json['processedAtUtcMicros'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'profileId': serializer.toJson<String>(profileId),
      'processedAtUtcMicros': serializer.toJson<int>(processedAtUtcMicros),
    };
  }

  ProcessedSessionRow copyWith({
    String? sessionId,
    String? profileId,
    int? processedAtUtcMicros,
  }) => ProcessedSessionRow(
    sessionId: sessionId ?? this.sessionId,
    profileId: profileId ?? this.profileId,
    processedAtUtcMicros: processedAtUtcMicros ?? this.processedAtUtcMicros,
  );
  ProcessedSessionRow copyWithCompanion(ProcessedSessionsCompanion data) {
    return ProcessedSessionRow(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      processedAtUtcMicros: data.processedAtUtcMicros.present
          ? data.processedAtUtcMicros.value
          : this.processedAtUtcMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProcessedSessionRow(')
          ..write('sessionId: $sessionId, ')
          ..write('profileId: $profileId, ')
          ..write('processedAtUtcMicros: $processedAtUtcMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sessionId, profileId, processedAtUtcMicros);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProcessedSessionRow &&
          other.sessionId == this.sessionId &&
          other.profileId == this.profileId &&
          other.processedAtUtcMicros == this.processedAtUtcMicros);
}

class ProcessedSessionsCompanion extends UpdateCompanion<ProcessedSessionRow> {
  final Value<String> sessionId;
  final Value<String> profileId;
  final Value<int> processedAtUtcMicros;
  final Value<int> rowid;
  const ProcessedSessionsCompanion({
    this.sessionId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.processedAtUtcMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProcessedSessionsCompanion.insert({
    required String sessionId,
    required String profileId,
    required int processedAtUtcMicros,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       profileId = Value(profileId),
       processedAtUtcMicros = Value(processedAtUtcMicros);
  static Insertable<ProcessedSessionRow> custom({
    Expression<String>? sessionId,
    Expression<String>? profileId,
    Expression<int>? processedAtUtcMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (profileId != null) 'profile_id': profileId,
      if (processedAtUtcMicros != null)
        'processed_at_utc_micros': processedAtUtcMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProcessedSessionsCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? profileId,
    Value<int>? processedAtUtcMicros,
    Value<int>? rowid,
  }) {
    return ProcessedSessionsCompanion(
      sessionId: sessionId ?? this.sessionId,
      profileId: profileId ?? this.profileId,
      processedAtUtcMicros: processedAtUtcMicros ?? this.processedAtUtcMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (processedAtUtcMicros.present) {
      map['processed_at_utc_micros'] = Variable<int>(
        processedAtUtcMicros.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProcessedSessionsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('profileId: $profileId, ')
          ..write('processedAtUtcMicros: $processedAtUtcMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressCacheTable extends LessonProgressCache
    with TableInfo<$LessonProgressCacheTable, LessonProgressCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathIdMeta = const VerificationMeta('pathId');
  @override
  late final GeneratedColumn<String> pathId = GeneratedColumn<String>(
    'path_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bestAccuracyPctMeta = const VerificationMeta(
    'bestAccuracyPct',
  );
  @override
  late final GeneratedColumn<double> bestAccuracyPct = GeneratedColumn<double>(
    'best_accuracy_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtUtcMicrosMeta =
      const VerificationMeta('completedAtUtcMicros');
  @override
  late final GeneratedColumn<int> completedAtUtcMicros = GeneratedColumn<int>(
    'completed_at_utc_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    pathId,
    lessonId,
    status,
    bestAccuracyPct,
    completedAtUtcMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonProgressCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('path_id')) {
      context.handle(
        _pathIdMeta,
        pathId.isAcceptableOrUnknown(data['path_id']!, _pathIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pathIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('best_accuracy_pct')) {
      context.handle(
        _bestAccuracyPctMeta,
        bestAccuracyPct.isAcceptableOrUnknown(
          data['best_accuracy_pct']!,
          _bestAccuracyPctMeta,
        ),
      );
    }
    if (data.containsKey('completed_at_utc_micros')) {
      context.handle(
        _completedAtUtcMicrosMeta,
        completedAtUtcMicros.isAcceptableOrUnknown(
          data['completed_at_utc_micros']!,
          _completedAtUtcMicrosMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, lessonId};
  @override
  LessonProgressCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressCacheRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      pathId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      bestAccuracyPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}best_accuracy_pct'],
      ),
      completedAtUtcMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_utc_micros'],
      ),
    );
  }

  @override
  $LessonProgressCacheTable createAlias(String alias) {
    return $LessonProgressCacheTable(attachedDatabase, alias);
  }
}

class LessonProgressCacheRow extends DataClass
    implements Insertable<LessonProgressCacheRow> {
  /// The `ProfileId` this row belongs to.
  final String profileId;

  /// The `LearningPathId` the lesson in this row belongs to.
  final String pathId;

  /// The `LessonId` this row is about.
  final String lessonId;

  /// `LessonStatus` enum name, stored as plain text.
  final String status;

  /// The best accuracy ever recorded across every attempt at this
  /// lesson, or `null` if it's never been attempted.
  final double? bestAccuracyPct;

  /// When this lesson was first completed, as UTC microseconds since
  /// epoch, or `null` if it isn't completed yet.
  final int? completedAtUtcMicros;
  const LessonProgressCacheRow({
    required this.profileId,
    required this.pathId,
    required this.lessonId,
    required this.status,
    this.bestAccuracyPct,
    this.completedAtUtcMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['path_id'] = Variable<String>(pathId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || bestAccuracyPct != null) {
      map['best_accuracy_pct'] = Variable<double>(bestAccuracyPct);
    }
    if (!nullToAbsent || completedAtUtcMicros != null) {
      map['completed_at_utc_micros'] = Variable<int>(completedAtUtcMicros);
    }
    return map;
  }

  LessonProgressCacheCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressCacheCompanion(
      profileId: Value(profileId),
      pathId: Value(pathId),
      lessonId: Value(lessonId),
      status: Value(status),
      bestAccuracyPct: bestAccuracyPct == null && nullToAbsent
          ? const Value.absent()
          : Value(bestAccuracyPct),
      completedAtUtcMicros: completedAtUtcMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAtUtcMicros),
    );
  }

  factory LessonProgressCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressCacheRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      pathId: serializer.fromJson<String>(json['pathId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      status: serializer.fromJson<String>(json['status']),
      bestAccuracyPct: serializer.fromJson<double?>(json['bestAccuracyPct']),
      completedAtUtcMicros: serializer.fromJson<int?>(
        json['completedAtUtcMicros'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'pathId': serializer.toJson<String>(pathId),
      'lessonId': serializer.toJson<String>(lessonId),
      'status': serializer.toJson<String>(status),
      'bestAccuracyPct': serializer.toJson<double?>(bestAccuracyPct),
      'completedAtUtcMicros': serializer.toJson<int?>(completedAtUtcMicros),
    };
  }

  LessonProgressCacheRow copyWith({
    String? profileId,
    String? pathId,
    String? lessonId,
    String? status,
    Value<double?> bestAccuracyPct = const Value.absent(),
    Value<int?> completedAtUtcMicros = const Value.absent(),
  }) => LessonProgressCacheRow(
    profileId: profileId ?? this.profileId,
    pathId: pathId ?? this.pathId,
    lessonId: lessonId ?? this.lessonId,
    status: status ?? this.status,
    bestAccuracyPct: bestAccuracyPct.present
        ? bestAccuracyPct.value
        : this.bestAccuracyPct,
    completedAtUtcMicros: completedAtUtcMicros.present
        ? completedAtUtcMicros.value
        : this.completedAtUtcMicros,
  );
  LessonProgressCacheRow copyWithCompanion(LessonProgressCacheCompanion data) {
    return LessonProgressCacheRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      pathId: data.pathId.present ? data.pathId.value : this.pathId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      status: data.status.present ? data.status.value : this.status,
      bestAccuracyPct: data.bestAccuracyPct.present
          ? data.bestAccuracyPct.value
          : this.bestAccuracyPct,
      completedAtUtcMicros: data.completedAtUtcMicros.present
          ? data.completedAtUtcMicros.value
          : this.completedAtUtcMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressCacheRow(')
          ..write('profileId: $profileId, ')
          ..write('pathId: $pathId, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('bestAccuracyPct: $bestAccuracyPct, ')
          ..write('completedAtUtcMicros: $completedAtUtcMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    pathId,
    lessonId,
    status,
    bestAccuracyPct,
    completedAtUtcMicros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressCacheRow &&
          other.profileId == this.profileId &&
          other.pathId == this.pathId &&
          other.lessonId == this.lessonId &&
          other.status == this.status &&
          other.bestAccuracyPct == this.bestAccuracyPct &&
          other.completedAtUtcMicros == this.completedAtUtcMicros);
}

class LessonProgressCacheCompanion
    extends UpdateCompanion<LessonProgressCacheRow> {
  final Value<String> profileId;
  final Value<String> pathId;
  final Value<String> lessonId;
  final Value<String> status;
  final Value<double?> bestAccuracyPct;
  final Value<int?> completedAtUtcMicros;
  final Value<int> rowid;
  const LessonProgressCacheCompanion({
    this.profileId = const Value.absent(),
    this.pathId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.status = const Value.absent(),
    this.bestAccuracyPct = const Value.absent(),
    this.completedAtUtcMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonProgressCacheCompanion.insert({
    required String profileId,
    required String pathId,
    required String lessonId,
    required String status,
    this.bestAccuracyPct = const Value.absent(),
    this.completedAtUtcMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       pathId = Value(pathId),
       lessonId = Value(lessonId),
       status = Value(status);
  static Insertable<LessonProgressCacheRow> custom({
    Expression<String>? profileId,
    Expression<String>? pathId,
    Expression<String>? lessonId,
    Expression<String>? status,
    Expression<double>? bestAccuracyPct,
    Expression<int>? completedAtUtcMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (pathId != null) 'path_id': pathId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (status != null) 'status': status,
      if (bestAccuracyPct != null) 'best_accuracy_pct': bestAccuracyPct,
      if (completedAtUtcMicros != null)
        'completed_at_utc_micros': completedAtUtcMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonProgressCacheCompanion copyWith({
    Value<String>? profileId,
    Value<String>? pathId,
    Value<String>? lessonId,
    Value<String>? status,
    Value<double?>? bestAccuracyPct,
    Value<int?>? completedAtUtcMicros,
    Value<int>? rowid,
  }) {
    return LessonProgressCacheCompanion(
      profileId: profileId ?? this.profileId,
      pathId: pathId ?? this.pathId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      bestAccuracyPct: bestAccuracyPct ?? this.bestAccuracyPct,
      completedAtUtcMicros: completedAtUtcMicros ?? this.completedAtUtcMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (pathId.present) {
      map['path_id'] = Variable<String>(pathId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (bestAccuracyPct.present) {
      map['best_accuracy_pct'] = Variable<double>(bestAccuracyPct.value);
    }
    if (completedAtUtcMicros.present) {
      map['completed_at_utc_micros'] = Variable<int>(
        completedAtUtcMicros.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressCacheCompanion(')
          ..write('profileId: $profileId, ')
          ..write('pathId: $pathId, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('bestAccuracyPct: $bestAccuracyPct, ')
          ..write('completedAtUtcMicros: $completedAtUtcMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsUnlockedTable extends AchievementsUnlocked
    with TableInfo<$AchievementsUnlockedTable, AchievementUnlockedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsUnlockedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievementIdMeta = const VerificationMeta(
    'achievementId',
  );
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
    'achievement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtUtcMicrosMeta =
      const VerificationMeta('unlockedAtUtcMicros');
  @override
  late final GeneratedColumn<int> unlockedAtUtcMicros = GeneratedColumn<int>(
    'unlocked_at_utc_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggerSessionIdMeta = const VerificationMeta(
    'triggerSessionId',
  );
  @override
  late final GeneratedColumn<String> triggerSessionId = GeneratedColumn<String>(
    'trigger_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    achievementId,
    unlockedAtUtcMicros,
    triggerSessionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements_unlocked';
  @override
  VerificationContext validateIntegrity(
    Insertable<AchievementUnlockedRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('achievement_id')) {
      context.handle(
        _achievementIdMeta,
        achievementId.isAcceptableOrUnknown(
          data['achievement_id']!,
          _achievementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('unlocked_at_utc_micros')) {
      context.handle(
        _unlockedAtUtcMicrosMeta,
        unlockedAtUtcMicros.isAcceptableOrUnknown(
          data['unlocked_at_utc_micros']!,
          _unlockedAtUtcMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unlockedAtUtcMicrosMeta);
    }
    if (data.containsKey('trigger_session_id')) {
      context.handle(
        _triggerSessionIdMeta,
        triggerSessionId.isAcceptableOrUnknown(
          data['trigger_session_id']!,
          _triggerSessionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, achievementId};
  @override
  AchievementUnlockedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementUnlockedRow(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      achievementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_id'],
      )!,
      unlockedAtUtcMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unlocked_at_utc_micros'],
      )!,
      triggerSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_session_id'],
      ),
    );
  }

  @override
  $AchievementsUnlockedTable createAlias(String alias) {
    return $AchievementsUnlockedTable(attachedDatabase, alias);
  }
}

class AchievementUnlockedRow extends DataClass
    implements Insertable<AchievementUnlockedRow> {
  /// The `ProfileId` this unlock belongs to.
  final String profileId;

  /// `AchievementId.storageKey` — see that getter's class doc for the
  /// encoding.
  final String achievementId;

  /// When this achievement was first unlocked, as UTC microseconds since
  /// epoch — never updated after the row is first inserted.
  final int unlockedAtUtcMicros;

  /// The `TypingSessionId` that triggered this unlock, when the
  /// achievement is tied to one specific session ("Cero Errores"/
  /// "Ambidiestro") — `null` for streak/mastery/marathon badges.
  final String? triggerSessionId;
  const AchievementUnlockedRow({
    required this.profileId,
    required this.achievementId,
    required this.unlockedAtUtcMicros,
    this.triggerSessionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['achievement_id'] = Variable<String>(achievementId);
    map['unlocked_at_utc_micros'] = Variable<int>(unlockedAtUtcMicros);
    if (!nullToAbsent || triggerSessionId != null) {
      map['trigger_session_id'] = Variable<String>(triggerSessionId);
    }
    return map;
  }

  AchievementsUnlockedCompanion toCompanion(bool nullToAbsent) {
    return AchievementsUnlockedCompanion(
      profileId: Value(profileId),
      achievementId: Value(achievementId),
      unlockedAtUtcMicros: Value(unlockedAtUtcMicros),
      triggerSessionId: triggerSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerSessionId),
    );
  }

  factory AchievementUnlockedRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementUnlockedRow(
      profileId: serializer.fromJson<String>(json['profileId']),
      achievementId: serializer.fromJson<String>(json['achievementId']),
      unlockedAtUtcMicros: serializer.fromJson<int>(
        json['unlockedAtUtcMicros'],
      ),
      triggerSessionId: serializer.fromJson<String?>(json['triggerSessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'achievementId': serializer.toJson<String>(achievementId),
      'unlockedAtUtcMicros': serializer.toJson<int>(unlockedAtUtcMicros),
      'triggerSessionId': serializer.toJson<String?>(triggerSessionId),
    };
  }

  AchievementUnlockedRow copyWith({
    String? profileId,
    String? achievementId,
    int? unlockedAtUtcMicros,
    Value<String?> triggerSessionId = const Value.absent(),
  }) => AchievementUnlockedRow(
    profileId: profileId ?? this.profileId,
    achievementId: achievementId ?? this.achievementId,
    unlockedAtUtcMicros: unlockedAtUtcMicros ?? this.unlockedAtUtcMicros,
    triggerSessionId: triggerSessionId.present
        ? triggerSessionId.value
        : this.triggerSessionId,
  );
  AchievementUnlockedRow copyWithCompanion(AchievementsUnlockedCompanion data) {
    return AchievementUnlockedRow(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      unlockedAtUtcMicros: data.unlockedAtUtcMicros.present
          ? data.unlockedAtUtcMicros.value
          : this.unlockedAtUtcMicros,
      triggerSessionId: data.triggerSessionId.present
          ? data.triggerSessionId.value
          : this.triggerSessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementUnlockedRow(')
          ..write('profileId: $profileId, ')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAtUtcMicros: $unlockedAtUtcMicros, ')
          ..write('triggerSessionId: $triggerSessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    achievementId,
    unlockedAtUtcMicros,
    triggerSessionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementUnlockedRow &&
          other.profileId == this.profileId &&
          other.achievementId == this.achievementId &&
          other.unlockedAtUtcMicros == this.unlockedAtUtcMicros &&
          other.triggerSessionId == this.triggerSessionId);
}

class AchievementsUnlockedCompanion
    extends UpdateCompanion<AchievementUnlockedRow> {
  final Value<String> profileId;
  final Value<String> achievementId;
  final Value<int> unlockedAtUtcMicros;
  final Value<String?> triggerSessionId;
  final Value<int> rowid;
  const AchievementsUnlockedCompanion({
    this.profileId = const Value.absent(),
    this.achievementId = const Value.absent(),
    this.unlockedAtUtcMicros = const Value.absent(),
    this.triggerSessionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsUnlockedCompanion.insert({
    required String profileId,
    required String achievementId,
    required int unlockedAtUtcMicros,
    this.triggerSessionId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       achievementId = Value(achievementId),
       unlockedAtUtcMicros = Value(unlockedAtUtcMicros);
  static Insertable<AchievementUnlockedRow> custom({
    Expression<String>? profileId,
    Expression<String>? achievementId,
    Expression<int>? unlockedAtUtcMicros,
    Expression<String>? triggerSessionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (achievementId != null) 'achievement_id': achievementId,
      if (unlockedAtUtcMicros != null)
        'unlocked_at_utc_micros': unlockedAtUtcMicros,
      if (triggerSessionId != null) 'trigger_session_id': triggerSessionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsUnlockedCompanion copyWith({
    Value<String>? profileId,
    Value<String>? achievementId,
    Value<int>? unlockedAtUtcMicros,
    Value<String?>? triggerSessionId,
    Value<int>? rowid,
  }) {
    return AchievementsUnlockedCompanion(
      profileId: profileId ?? this.profileId,
      achievementId: achievementId ?? this.achievementId,
      unlockedAtUtcMicros: unlockedAtUtcMicros ?? this.unlockedAtUtcMicros,
      triggerSessionId: triggerSessionId ?? this.triggerSessionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (unlockedAtUtcMicros.present) {
      map['unlocked_at_utc_micros'] = Variable<int>(unlockedAtUtcMicros.value);
    }
    if (triggerSessionId.present) {
      map['trigger_session_id'] = Variable<String>(triggerSessionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsUnlockedCompanion(')
          ..write('profileId: $profileId, ')
          ..write('achievementId: $achievementId, ')
          ..write('unlockedAtUtcMicros: $unlockedAtUtcMicros, ')
          ..write('triggerSessionId: $triggerSessionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GuestProfilesTable guestProfiles = $GuestProfilesTable(this);
  late final $SnippetsTable snippets = $SnippetsTable(this);
  late final $TypingSessionsTable typingSessions = $TypingSessionsTable(this);
  late final $KeystrokeEventsTable keystrokeEvents = $KeystrokeEventsTable(
    this,
  );
  late final $ProgressSnapshotCacheTable progressSnapshotCache =
      $ProgressSnapshotCacheTable(this);
  late final $MasteryStatusCacheTable masteryStatusCache =
      $MasteryStatusCacheTable(this);
  late final $ProcessedSessionsTable processedSessions =
      $ProcessedSessionsTable(this);
  late final $LessonProgressCacheTable lessonProgressCache =
      $LessonProgressCacheTable(this);
  late final $AchievementsUnlockedTable achievementsUnlocked =
      $AchievementsUnlockedTable(this);
  late final GuestProfileDao guestProfileDao = GuestProfileDao(
    this as AppDatabase,
  );
  late final SnippetDao snippetDao = SnippetDao(this as AppDatabase);
  late final PracticeDao practiceDao = PracticeDao(this as AppDatabase);
  late final ProgressionDao progressionDao = ProgressionDao(
    this as AppDatabase,
  );
  late final LessonProgressDao lessonProgressDao = LessonProgressDao(
    this as AppDatabase,
  );
  late final AchievementDao achievementDao = AchievementDao(
    this as AppDatabase,
  );
  late final DataResetDao dataResetDao = DataResetDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    guestProfiles,
    snippets,
    typingSessions,
    keystrokeEvents,
    progressSnapshotCache,
    masteryStatusCache,
    processedSessions,
    lessonProgressCache,
    achievementsUnlocked,
  ];
}

typedef $$GuestProfilesTableCreateCompanionBuilder =
    GuestProfilesCompanion Function({
      required String id,
      required String username,
      required DateTime createdAt,
      Value<String?> favoriteLanguages,
      Value<String?> keyboardLayout,
      Value<String?> keyboardBrand,
      Value<String?> keyboardModel,
      Value<String?> favoriteQuote,
      Value<String?> favoriteProgrammer,
      Value<String?> platform,
      Value<String?> operatingSystemVersion,
      Value<String?> deviceModel,
      Value<int> rowid,
    });
typedef $$GuestProfilesTableUpdateCompanionBuilder =
    GuestProfilesCompanion Function({
      Value<String> id,
      Value<String> username,
      Value<DateTime> createdAt,
      Value<String?> favoriteLanguages,
      Value<String?> keyboardLayout,
      Value<String?> keyboardBrand,
      Value<String?> keyboardModel,
      Value<String?> favoriteQuote,
      Value<String?> favoriteProgrammer,
      Value<String?> platform,
      Value<String?> operatingSystemVersion,
      Value<String?> deviceModel,
      Value<int> rowid,
    });

class $$GuestProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $GuestProfilesTable> {
  $$GuestProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get favoriteLanguages => $composableBuilder(
    column: $table.favoriteLanguages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyboardLayout => $composableBuilder(
    column: $table.keyboardLayout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyboardBrand => $composableBuilder(
    column: $table.keyboardBrand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyboardModel => $composableBuilder(
    column: $table.keyboardModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get favoriteQuote => $composableBuilder(
    column: $table.favoriteQuote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get favoriteProgrammer => $composableBuilder(
    column: $table.favoriteProgrammer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operatingSystemVersion => $composableBuilder(
    column: $table.operatingSystemVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GuestProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $GuestProfilesTable> {
  $$GuestProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favoriteLanguages => $composableBuilder(
    column: $table.favoriteLanguages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyboardLayout => $composableBuilder(
    column: $table.keyboardLayout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyboardBrand => $composableBuilder(
    column: $table.keyboardBrand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyboardModel => $composableBuilder(
    column: $table.keyboardModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favoriteQuote => $composableBuilder(
    column: $table.favoriteQuote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favoriteProgrammer => $composableBuilder(
    column: $table.favoriteProgrammer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operatingSystemVersion => $composableBuilder(
    column: $table.operatingSystemVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GuestProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuestProfilesTable> {
  $$GuestProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get favoriteLanguages => $composableBuilder(
    column: $table.favoriteLanguages,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keyboardLayout => $composableBuilder(
    column: $table.keyboardLayout,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keyboardBrand => $composableBuilder(
    column: $table.keyboardBrand,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keyboardModel => $composableBuilder(
    column: $table.keyboardModel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get favoriteQuote => $composableBuilder(
    column: $table.favoriteQuote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get favoriteProgrammer => $composableBuilder(
    column: $table.favoriteProgrammer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get operatingSystemVersion => $composableBuilder(
    column: $table.operatingSystemVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => column,
  );
}

class $$GuestProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GuestProfilesTable,
          GuestProfileRow,
          $$GuestProfilesTableFilterComposer,
          $$GuestProfilesTableOrderingComposer,
          $$GuestProfilesTableAnnotationComposer,
          $$GuestProfilesTableCreateCompanionBuilder,
          $$GuestProfilesTableUpdateCompanionBuilder,
          (
            GuestProfileRow,
            BaseReferences<_$AppDatabase, $GuestProfilesTable, GuestProfileRow>,
          ),
          GuestProfileRow,
          PrefetchHooks Function()
        > {
  $$GuestProfilesTableTableManager(_$AppDatabase db, $GuestProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuestProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuestProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuestProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> favoriteLanguages = const Value.absent(),
                Value<String?> keyboardLayout = const Value.absent(),
                Value<String?> keyboardBrand = const Value.absent(),
                Value<String?> keyboardModel = const Value.absent(),
                Value<String?> favoriteQuote = const Value.absent(),
                Value<String?> favoriteProgrammer = const Value.absent(),
                Value<String?> platform = const Value.absent(),
                Value<String?> operatingSystemVersion = const Value.absent(),
                Value<String?> deviceModel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuestProfilesCompanion(
                id: id,
                username: username,
                createdAt: createdAt,
                favoriteLanguages: favoriteLanguages,
                keyboardLayout: keyboardLayout,
                keyboardBrand: keyboardBrand,
                keyboardModel: keyboardModel,
                favoriteQuote: favoriteQuote,
                favoriteProgrammer: favoriteProgrammer,
                platform: platform,
                operatingSystemVersion: operatingSystemVersion,
                deviceModel: deviceModel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String username,
                required DateTime createdAt,
                Value<String?> favoriteLanguages = const Value.absent(),
                Value<String?> keyboardLayout = const Value.absent(),
                Value<String?> keyboardBrand = const Value.absent(),
                Value<String?> keyboardModel = const Value.absent(),
                Value<String?> favoriteQuote = const Value.absent(),
                Value<String?> favoriteProgrammer = const Value.absent(),
                Value<String?> platform = const Value.absent(),
                Value<String?> operatingSystemVersion = const Value.absent(),
                Value<String?> deviceModel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuestProfilesCompanion.insert(
                id: id,
                username: username,
                createdAt: createdAt,
                favoriteLanguages: favoriteLanguages,
                keyboardLayout: keyboardLayout,
                keyboardBrand: keyboardBrand,
                keyboardModel: keyboardModel,
                favoriteQuote: favoriteQuote,
                favoriteProgrammer: favoriteProgrammer,
                platform: platform,
                operatingSystemVersion: operatingSystemVersion,
                deviceModel: deviceModel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GuestProfilesTable, GuestProfileRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GuestProfilesTable,
                    GuestProfileRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GuestProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GuestProfilesTable,
      GuestProfileRow,
      $$GuestProfilesTableFilterComposer,
      $$GuestProfilesTableOrderingComposer,
      $$GuestProfilesTableAnnotationComposer,
      $$GuestProfilesTableCreateCompanionBuilder,
      $$GuestProfilesTableUpdateCompanionBuilder,
      (
        GuestProfileRow,
        BaseReferences<_$AppDatabase, $GuestProfilesTable, GuestProfileRow>,
      ),
      GuestProfileRow,
      PrefetchHooks Function()
    >;
typedef $$SnippetsTableCreateCompanionBuilder = SnippetsCompanion Function({
  required String id,
  required int revision,
  required String language,
  required String difficulty,
  required String category,
  Value<String?> symbolFocus,
  required String length,
  Value<String> titleEn,
  Value<String> titleEs,
  required String code,
  required String sourceAttribution,
  Value<String> tldrEn,
  Value<String> tldrEs,
  Value<String> explanationEn,
  Value<String> explanationEs,
  required int charCount,
  required bool isActive,
  Value<int> rowid,
});
typedef $$SnippetsTableUpdateCompanionBuilder = SnippetsCompanion Function({
  Value<String> id,
  Value<int> revision,
  Value<String> language,
  Value<String> difficulty,
  Value<String> category,
  Value<String?> symbolFocus,
  Value<String> length,
  Value<String> titleEn,
  Value<String> titleEs,
  Value<String> code,
  Value<String> sourceAttribution,
  Value<String> tldrEn,
  Value<String> tldrEs,
  Value<String> explanationEn,
  Value<String> explanationEs,
  Value<int> charCount,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$SnippetsTableFilterComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbolFocus => $composableBuilder(
    column: $table.symbolFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get length => $composableBuilder(
    column: $table.length,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEs => $composableBuilder(
    column: $table.titleEs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceAttribution => $composableBuilder(
    column: $table.sourceAttribution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tldrEn => $composableBuilder(
    column: $table.tldrEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tldrEs => $composableBuilder(
    column: $table.tldrEs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationEn => $composableBuilder(
    column: $table.explanationEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationEs => $composableBuilder(
    column: $table.explanationEs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get charCount => $composableBuilder(
    column: $table.charCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SnippetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbolFocus => $composableBuilder(
    column: $table.symbolFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get length => $composableBuilder(
    column: $table.length,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEs => $composableBuilder(
    column: $table.titleEs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceAttribution => $composableBuilder(
    column: $table.sourceAttribution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tldrEn => $composableBuilder(
    column: $table.tldrEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tldrEs => $composableBuilder(
    column: $table.tldrEs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationEn => $composableBuilder(
    column: $table.explanationEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationEs => $composableBuilder(
    column: $table.explanationEs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get charCount => $composableBuilder(
    column: $table.charCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SnippetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get symbolFocus => $composableBuilder(
    column: $table.symbolFocus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get length =>
      $composableBuilder(column: $table.length, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleEs =>
      $composableBuilder(column: $table.titleEs, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get sourceAttribution => $composableBuilder(
    column: $table.sourceAttribution,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tldrEn =>
      $composableBuilder(column: $table.tldrEn, builder: (column) => column);

  GeneratedColumn<String> get tldrEs =>
      $composableBuilder(column: $table.tldrEs, builder: (column) => column);

  GeneratedColumn<String> get explanationEn => $composableBuilder(
    column: $table.explanationEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationEs => $composableBuilder(
    column: $table.explanationEs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get charCount =>
      $composableBuilder(column: $table.charCount, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$SnippetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnippetsTable,
          SnippetRow,
          $$SnippetsTableFilterComposer,
          $$SnippetsTableOrderingComposer,
          $$SnippetsTableAnnotationComposer,
          $$SnippetsTableCreateCompanionBuilder,
          $$SnippetsTableUpdateCompanionBuilder,
          (
            SnippetRow,
            BaseReferences<_$AppDatabase, $SnippetsTable, SnippetRow>,
          ),
          SnippetRow,
          PrefetchHooks Function()
        > {
  $$SnippetsTableTableManager(_$AppDatabase db, $SnippetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnippetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnippetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnippetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> symbolFocus = const Value.absent(),
                Value<String> length = const Value.absent(),
                Value<String> titleEn = const Value.absent(),
                Value<String> titleEs = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> sourceAttribution = const Value.absent(),
                Value<String> tldrEn = const Value.absent(),
                Value<String> tldrEs = const Value.absent(),
                Value<String> explanationEn = const Value.absent(),
                Value<String> explanationEs = const Value.absent(),
                Value<int> charCount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnippetsCompanion(
                id: id,
                revision: revision,
                language: language,
                difficulty: difficulty,
                category: category,
                symbolFocus: symbolFocus,
                length: length,
                titleEn: titleEn,
                titleEs: titleEs,
                code: code,
                sourceAttribution: sourceAttribution,
                tldrEn: tldrEn,
                tldrEs: tldrEs,
                explanationEn: explanationEn,
                explanationEs: explanationEs,
                charCount: charCount,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int revision,
                required String language,
                required String difficulty,
                required String category,
                Value<String?> symbolFocus = const Value.absent(),
                required String length,
                Value<String> titleEn = const Value.absent(),
                Value<String> titleEs = const Value.absent(),
                required String code,
                required String sourceAttribution,
                Value<String> tldrEn = const Value.absent(),
                Value<String> tldrEs = const Value.absent(),
                Value<String> explanationEn = const Value.absent(),
                Value<String> explanationEs = const Value.absent(),
                required int charCount,
                required bool isActive,
                Value<int> rowid = const Value.absent(),
              }) => SnippetsCompanion.insert(
                id: id,
                revision: revision,
                language: language,
                difficulty: difficulty,
                category: category,
                symbolFocus: symbolFocus,
                length: length,
                titleEn: titleEn,
                titleEs: titleEs,
                code: code,
                sourceAttribution: sourceAttribution,
                tldrEn: tldrEn,
                tldrEs: tldrEs,
                explanationEn: explanationEn,
                explanationEs: explanationEs,
                charCount: charCount,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SnippetsTable, SnippetRow>(table),
                  BaseReferences<_$AppDatabase, $SnippetsTable, SnippetRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SnippetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnippetsTable,
      SnippetRow,
      $$SnippetsTableFilterComposer,
      $$SnippetsTableOrderingComposer,
      $$SnippetsTableAnnotationComposer,
      $$SnippetsTableCreateCompanionBuilder,
      $$SnippetsTableUpdateCompanionBuilder,
      (SnippetRow, BaseReferences<_$AppDatabase, $SnippetsTable, SnippetRow>),
      SnippetRow,
      PrefetchHooks Function()
    >;
typedef $$TypingSessionsTableCreateCompanionBuilder =
    TypingSessionsCompanion Function({
      required String id,
      required String profileId,
      required String mode,
      Value<String?> lessonId,
      required String snippetId,
      required int snippetRevision,
      required String category,
      required String difficulty,
      required int startedAtUtcMicros,
      required int durationMicros,
      required double rawSpeedCpm,
      required double netSpeedCpm,
      required double accuracyPct,
      required double consistencyScore,
      required int maxStreak,
      required double fatigueFirstThirdCpm,
      required double fatigueMiddleThirdCpm,
      required double fatigueLastThirdCpm,
      required double handBalanceRatio,
      Value<bool?> passed,
      Value<int> xpAwarded,
      Value<bool> isFirstCompletion,
      Value<int> rowid,
    });
typedef $$TypingSessionsTableUpdateCompanionBuilder =
    TypingSessionsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> mode,
      Value<String?> lessonId,
      Value<String> snippetId,
      Value<int> snippetRevision,
      Value<String> category,
      Value<String> difficulty,
      Value<int> startedAtUtcMicros,
      Value<int> durationMicros,
      Value<double> rawSpeedCpm,
      Value<double> netSpeedCpm,
      Value<double> accuracyPct,
      Value<double> consistencyScore,
      Value<int> maxStreak,
      Value<double> fatigueFirstThirdCpm,
      Value<double> fatigueMiddleThirdCpm,
      Value<double> fatigueLastThirdCpm,
      Value<double> handBalanceRatio,
      Value<bool?> passed,
      Value<int> xpAwarded,
      Value<bool> isFirstCompletion,
      Value<int> rowid,
    });

class $$TypingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $TypingSessionsTable> {
  $$TypingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snippetId => $composableBuilder(
    column: $table.snippetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get snippetRevision => $composableBuilder(
    column: $table.snippetRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtUtcMicros => $composableBuilder(
    column: $table.startedAtUtcMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMicros => $composableBuilder(
    column: $table.durationMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rawSpeedCpm => $composableBuilder(
    column: $table.rawSpeedCpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get netSpeedCpm => $composableBuilder(
    column: $table.netSpeedCpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyPct => $composableBuilder(
    column: $table.accuracyPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get consistencyScore => $composableBuilder(
    column: $table.consistencyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxStreak => $composableBuilder(
    column: $table.maxStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatigueFirstThirdCpm => $composableBuilder(
    column: $table.fatigueFirstThirdCpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatigueMiddleThirdCpm => $composableBuilder(
    column: $table.fatigueMiddleThirdCpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatigueLastThirdCpm => $composableBuilder(
    column: $table.fatigueLastThirdCpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get handBalanceRatio => $composableBuilder(
    column: $table.handBalanceRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpAwarded => $composableBuilder(
    column: $table.xpAwarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFirstCompletion => $composableBuilder(
    column: $table.isFirstCompletion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TypingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TypingSessionsTable> {
  $$TypingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snippetId => $composableBuilder(
    column: $table.snippetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snippetRevision => $composableBuilder(
    column: $table.snippetRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtUtcMicros => $composableBuilder(
    column: $table.startedAtUtcMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMicros => $composableBuilder(
    column: $table.durationMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rawSpeedCpm => $composableBuilder(
    column: $table.rawSpeedCpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get netSpeedCpm => $composableBuilder(
    column: $table.netSpeedCpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyPct => $composableBuilder(
    column: $table.accuracyPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get consistencyScore => $composableBuilder(
    column: $table.consistencyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxStreak => $composableBuilder(
    column: $table.maxStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatigueFirstThirdCpm => $composableBuilder(
    column: $table.fatigueFirstThirdCpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatigueMiddleThirdCpm => $composableBuilder(
    column: $table.fatigueMiddleThirdCpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatigueLastThirdCpm => $composableBuilder(
    column: $table.fatigueLastThirdCpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get handBalanceRatio => $composableBuilder(
    column: $table.handBalanceRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpAwarded => $composableBuilder(
    column: $table.xpAwarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFirstCompletion => $composableBuilder(
    column: $table.isFirstCompletion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TypingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TypingSessionsTable> {
  $$TypingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get snippetId =>
      $composableBuilder(column: $table.snippetId, builder: (column) => column);

  GeneratedColumn<int> get snippetRevision => $composableBuilder(
    column: $table.snippetRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAtUtcMicros => $composableBuilder(
    column: $table.startedAtUtcMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMicros => $composableBuilder(
    column: $table.durationMicros,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rawSpeedCpm => $composableBuilder(
    column: $table.rawSpeedCpm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get netSpeedCpm => $composableBuilder(
    column: $table.netSpeedCpm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get accuracyPct => $composableBuilder(
    column: $table.accuracyPct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get consistencyScore => $composableBuilder(
    column: $table.consistencyScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxStreak =>
      $composableBuilder(column: $table.maxStreak, builder: (column) => column);

  GeneratedColumn<double> get fatigueFirstThirdCpm => $composableBuilder(
    column: $table.fatigueFirstThirdCpm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatigueMiddleThirdCpm => $composableBuilder(
    column: $table.fatigueMiddleThirdCpm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatigueLastThirdCpm => $composableBuilder(
    column: $table.fatigueLastThirdCpm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get handBalanceRatio => $composableBuilder(
    column: $table.handBalanceRatio,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get passed =>
      $composableBuilder(column: $table.passed, builder: (column) => column);

  GeneratedColumn<int> get xpAwarded =>
      $composableBuilder(column: $table.xpAwarded, builder: (column) => column);

  GeneratedColumn<bool> get isFirstCompletion => $composableBuilder(
    column: $table.isFirstCompletion,
    builder: (column) => column,
  );
}

class $$TypingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TypingSessionsTable,
          TypingSessionRow,
          $$TypingSessionsTableFilterComposer,
          $$TypingSessionsTableOrderingComposer,
          $$TypingSessionsTableAnnotationComposer,
          $$TypingSessionsTableCreateCompanionBuilder,
          $$TypingSessionsTableUpdateCompanionBuilder,
          (
            TypingSessionRow,
            BaseReferences<
              _$AppDatabase,
              $TypingSessionsTable,
              TypingSessionRow
            >,
          ),
          TypingSessionRow,
          PrefetchHooks Function()
        > {
  $$TypingSessionsTableTableManager(
    _$AppDatabase db,
    $TypingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TypingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TypingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TypingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> lessonId = const Value.absent(),
                Value<String> snippetId = const Value.absent(),
                Value<int> snippetRevision = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<int> startedAtUtcMicros = const Value.absent(),
                Value<int> durationMicros = const Value.absent(),
                Value<double> rawSpeedCpm = const Value.absent(),
                Value<double> netSpeedCpm = const Value.absent(),
                Value<double> accuracyPct = const Value.absent(),
                Value<double> consistencyScore = const Value.absent(),
                Value<int> maxStreak = const Value.absent(),
                Value<double> fatigueFirstThirdCpm = const Value.absent(),
                Value<double> fatigueMiddleThirdCpm = const Value.absent(),
                Value<double> fatigueLastThirdCpm = const Value.absent(),
                Value<double> handBalanceRatio = const Value.absent(),
                Value<bool?> passed = const Value.absent(),
                Value<int> xpAwarded = const Value.absent(),
                Value<bool> isFirstCompletion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TypingSessionsCompanion(
                id: id,
                profileId: profileId,
                mode: mode,
                lessonId: lessonId,
                snippetId: snippetId,
                snippetRevision: snippetRevision,
                category: category,
                difficulty: difficulty,
                startedAtUtcMicros: startedAtUtcMicros,
                durationMicros: durationMicros,
                rawSpeedCpm: rawSpeedCpm,
                netSpeedCpm: netSpeedCpm,
                accuracyPct: accuracyPct,
                consistencyScore: consistencyScore,
                maxStreak: maxStreak,
                fatigueFirstThirdCpm: fatigueFirstThirdCpm,
                fatigueMiddleThirdCpm: fatigueMiddleThirdCpm,
                fatigueLastThirdCpm: fatigueLastThirdCpm,
                handBalanceRatio: handBalanceRatio,
                passed: passed,
                xpAwarded: xpAwarded,
                isFirstCompletion: isFirstCompletion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String mode,
                Value<String?> lessonId = const Value.absent(),
                required String snippetId,
                required int snippetRevision,
                required String category,
                required String difficulty,
                required int startedAtUtcMicros,
                required int durationMicros,
                required double rawSpeedCpm,
                required double netSpeedCpm,
                required double accuracyPct,
                required double consistencyScore,
                required int maxStreak,
                required double fatigueFirstThirdCpm,
                required double fatigueMiddleThirdCpm,
                required double fatigueLastThirdCpm,
                required double handBalanceRatio,
                Value<bool?> passed = const Value.absent(),
                Value<int> xpAwarded = const Value.absent(),
                Value<bool> isFirstCompletion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TypingSessionsCompanion.insert(
                id: id,
                profileId: profileId,
                mode: mode,
                lessonId: lessonId,
                snippetId: snippetId,
                snippetRevision: snippetRevision,
                category: category,
                difficulty: difficulty,
                startedAtUtcMicros: startedAtUtcMicros,
                durationMicros: durationMicros,
                rawSpeedCpm: rawSpeedCpm,
                netSpeedCpm: netSpeedCpm,
                accuracyPct: accuracyPct,
                consistencyScore: consistencyScore,
                maxStreak: maxStreak,
                fatigueFirstThirdCpm: fatigueFirstThirdCpm,
                fatigueMiddleThirdCpm: fatigueMiddleThirdCpm,
                fatigueLastThirdCpm: fatigueLastThirdCpm,
                handBalanceRatio: handBalanceRatio,
                passed: passed,
                xpAwarded: xpAwarded,
                isFirstCompletion: isFirstCompletion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TypingSessionsTable, TypingSessionRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TypingSessionsTable,
                    TypingSessionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TypingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TypingSessionsTable,
      TypingSessionRow,
      $$TypingSessionsTableFilterComposer,
      $$TypingSessionsTableOrderingComposer,
      $$TypingSessionsTableAnnotationComposer,
      $$TypingSessionsTableCreateCompanionBuilder,
      $$TypingSessionsTableUpdateCompanionBuilder,
      (
        TypingSessionRow,
        BaseReferences<_$AppDatabase, $TypingSessionsTable, TypingSessionRow>,
      ),
      TypingSessionRow,
      PrefetchHooks Function()
    >;
typedef $$KeystrokeEventsTableCreateCompanionBuilder =
    KeystrokeEventsCompanion Function({
      required String sessionId,
      required int seq,
      required int sessionStartedAtUtcMicros,
      Value<String?> expectedChar,
      Value<String?> actualChar,
      required String result,
      required bool isCorrection,
      required String physicalKeyId,
      required String finger,
      required String keyboardRow,
      Value<int?> dwellMicros,
      Value<int?> flightMicros,
      required int thirdIndex,
      Value<int> rowid,
    });
typedef $$KeystrokeEventsTableUpdateCompanionBuilder =
    KeystrokeEventsCompanion Function({
      Value<String> sessionId,
      Value<int> seq,
      Value<int> sessionStartedAtUtcMicros,
      Value<String?> expectedChar,
      Value<String?> actualChar,
      Value<String> result,
      Value<bool> isCorrection,
      Value<String> physicalKeyId,
      Value<String> finger,
      Value<String> keyboardRow,
      Value<int?> dwellMicros,
      Value<int?> flightMicros,
      Value<int> thirdIndex,
      Value<int> rowid,
    });

class $$KeystrokeEventsTableFilterComposer
    extends Composer<_$AppDatabase, $KeystrokeEventsTable> {
  $$KeystrokeEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionStartedAtUtcMicros => $composableBuilder(
    column: $table.sessionStartedAtUtcMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectedChar => $composableBuilder(
    column: $table.expectedChar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actualChar => $composableBuilder(
    column: $table.actualChar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrection => $composableBuilder(
    column: $table.isCorrection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get physicalKeyId => $composableBuilder(
    column: $table.physicalKeyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finger => $composableBuilder(
    column: $table.finger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyboardRow => $composableBuilder(
    column: $table.keyboardRow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dwellMicros => $composableBuilder(
    column: $table.dwellMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flightMicros => $composableBuilder(
    column: $table.flightMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get thirdIndex => $composableBuilder(
    column: $table.thirdIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KeystrokeEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $KeystrokeEventsTable> {
  $$KeystrokeEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionStartedAtUtcMicros => $composableBuilder(
    column: $table.sessionStartedAtUtcMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedChar => $composableBuilder(
    column: $table.expectedChar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actualChar => $composableBuilder(
    column: $table.actualChar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrection => $composableBuilder(
    column: $table.isCorrection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get physicalKeyId => $composableBuilder(
    column: $table.physicalKeyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finger => $composableBuilder(
    column: $table.finger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyboardRow => $composableBuilder(
    column: $table.keyboardRow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dwellMicros => $composableBuilder(
    column: $table.dwellMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flightMicros => $composableBuilder(
    column: $table.flightMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get thirdIndex => $composableBuilder(
    column: $table.thirdIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KeystrokeEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeystrokeEventsTable> {
  $$KeystrokeEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<int> get sessionStartedAtUtcMicros => $composableBuilder(
    column: $table.sessionStartedAtUtcMicros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expectedChar => $composableBuilder(
    column: $table.expectedChar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actualChar => $composableBuilder(
    column: $table.actualChar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<bool> get isCorrection => $composableBuilder(
    column: $table.isCorrection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get physicalKeyId => $composableBuilder(
    column: $table.physicalKeyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get finger =>
      $composableBuilder(column: $table.finger, builder: (column) => column);

  GeneratedColumn<String> get keyboardRow => $composableBuilder(
    column: $table.keyboardRow,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dwellMicros => $composableBuilder(
    column: $table.dwellMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get flightMicros => $composableBuilder(
    column: $table.flightMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get thirdIndex => $composableBuilder(
    column: $table.thirdIndex,
    builder: (column) => column,
  );
}

class $$KeystrokeEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeystrokeEventsTable,
          KeystrokeEventRow,
          $$KeystrokeEventsTableFilterComposer,
          $$KeystrokeEventsTableOrderingComposer,
          $$KeystrokeEventsTableAnnotationComposer,
          $$KeystrokeEventsTableCreateCompanionBuilder,
          $$KeystrokeEventsTableUpdateCompanionBuilder,
          (
            KeystrokeEventRow,
            BaseReferences<
              _$AppDatabase,
              $KeystrokeEventsTable,
              KeystrokeEventRow
            >,
          ),
          KeystrokeEventRow,
          PrefetchHooks Function()
        > {
  $$KeystrokeEventsTableTableManager(
    _$AppDatabase db,
    $KeystrokeEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeystrokeEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeystrokeEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeystrokeEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<int> sessionStartedAtUtcMicros = const Value.absent(),
                Value<String?> expectedChar = const Value.absent(),
                Value<String?> actualChar = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<bool> isCorrection = const Value.absent(),
                Value<String> physicalKeyId = const Value.absent(),
                Value<String> finger = const Value.absent(),
                Value<String> keyboardRow = const Value.absent(),
                Value<int?> dwellMicros = const Value.absent(),
                Value<int?> flightMicros = const Value.absent(),
                Value<int> thirdIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KeystrokeEventsCompanion(
                sessionId: sessionId,
                seq: seq,
                sessionStartedAtUtcMicros: sessionStartedAtUtcMicros,
                expectedChar: expectedChar,
                actualChar: actualChar,
                result: result,
                isCorrection: isCorrection,
                physicalKeyId: physicalKeyId,
                finger: finger,
                keyboardRow: keyboardRow,
                dwellMicros: dwellMicros,
                flightMicros: flightMicros,
                thirdIndex: thirdIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required int seq,
                required int sessionStartedAtUtcMicros,
                Value<String?> expectedChar = const Value.absent(),
                Value<String?> actualChar = const Value.absent(),
                required String result,
                required bool isCorrection,
                required String physicalKeyId,
                required String finger,
                required String keyboardRow,
                Value<int?> dwellMicros = const Value.absent(),
                Value<int?> flightMicros = const Value.absent(),
                required int thirdIndex,
                Value<int> rowid = const Value.absent(),
              }) => KeystrokeEventsCompanion.insert(
                sessionId: sessionId,
                seq: seq,
                sessionStartedAtUtcMicros: sessionStartedAtUtcMicros,
                expectedChar: expectedChar,
                actualChar: actualChar,
                result: result,
                isCorrection: isCorrection,
                physicalKeyId: physicalKeyId,
                finger: finger,
                keyboardRow: keyboardRow,
                dwellMicros: dwellMicros,
                flightMicros: flightMicros,
                thirdIndex: thirdIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KeystrokeEventsTable, KeystrokeEventRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $KeystrokeEventsTable,
                    KeystrokeEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeystrokeEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeystrokeEventsTable,
      KeystrokeEventRow,
      $$KeystrokeEventsTableFilterComposer,
      $$KeystrokeEventsTableOrderingComposer,
      $$KeystrokeEventsTableAnnotationComposer,
      $$KeystrokeEventsTableCreateCompanionBuilder,
      $$KeystrokeEventsTableUpdateCompanionBuilder,
      (
        KeystrokeEventRow,
        BaseReferences<_$AppDatabase, $KeystrokeEventsTable, KeystrokeEventRow>,
      ),
      KeystrokeEventRow,
      PrefetchHooks Function()
    >;
typedef $$ProgressSnapshotCacheTableCreateCompanionBuilder =
    ProgressSnapshotCacheCompanion Function({
      required String profileId,
      required int totalXp,
      required int level,
      required int xpAtCurrentLevel,
      required int xpForNextLevel,
      required int currentStreakDays,
      required String weaknessReportJson,
      Value<String?> activityReportJson,
      required int computedAtUtcMicros,
      Value<int> rowid,
    });
typedef $$ProgressSnapshotCacheTableUpdateCompanionBuilder =
    ProgressSnapshotCacheCompanion Function({
      Value<String> profileId,
      Value<int> totalXp,
      Value<int> level,
      Value<int> xpAtCurrentLevel,
      Value<int> xpForNextLevel,
      Value<int> currentStreakDays,
      Value<String> weaknessReportJson,
      Value<String?> activityReportJson,
      Value<int> computedAtUtcMicros,
      Value<int> rowid,
    });

class $$ProgressSnapshotCacheTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressSnapshotCacheTable> {
  $$ProgressSnapshotCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpAtCurrentLevel => $composableBuilder(
    column: $table.xpAtCurrentLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpForNextLevel => $composableBuilder(
    column: $table.xpForNextLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreakDays => $composableBuilder(
    column: $table.currentStreakDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weaknessReportJson => $composableBuilder(
    column: $table.weaknessReportJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityReportJson => $composableBuilder(
    column: $table.activityReportJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get computedAtUtcMicros => $composableBuilder(
    column: $table.computedAtUtcMicros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgressSnapshotCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressSnapshotCacheTable> {
  $$ProgressSnapshotCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpAtCurrentLevel => $composableBuilder(
    column: $table.xpAtCurrentLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpForNextLevel => $composableBuilder(
    column: $table.xpForNextLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreakDays => $composableBuilder(
    column: $table.currentStreakDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weaknessReportJson => $composableBuilder(
    column: $table.weaknessReportJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityReportJson => $composableBuilder(
    column: $table.activityReportJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get computedAtUtcMicros => $composableBuilder(
    column: $table.computedAtUtcMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressSnapshotCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressSnapshotCacheTable> {
  $$ProgressSnapshotCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get xpAtCurrentLevel => $composableBuilder(
    column: $table.xpAtCurrentLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xpForNextLevel => $composableBuilder(
    column: $table.xpForNextLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStreakDays => $composableBuilder(
    column: $table.currentStreakDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weaknessReportJson => $composableBuilder(
    column: $table.weaknessReportJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activityReportJson => $composableBuilder(
    column: $table.activityReportJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get computedAtUtcMicros => $composableBuilder(
    column: $table.computedAtUtcMicros,
    builder: (column) => column,
  );
}

class $$ProgressSnapshotCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressSnapshotCacheTable,
          ProgressSnapshotCacheRow,
          $$ProgressSnapshotCacheTableFilterComposer,
          $$ProgressSnapshotCacheTableOrderingComposer,
          $$ProgressSnapshotCacheTableAnnotationComposer,
          $$ProgressSnapshotCacheTableCreateCompanionBuilder,
          $$ProgressSnapshotCacheTableUpdateCompanionBuilder,
          (
            ProgressSnapshotCacheRow,
            BaseReferences<
              _$AppDatabase,
              $ProgressSnapshotCacheTable,
              ProgressSnapshotCacheRow
            >,
          ),
          ProgressSnapshotCacheRow,
          PrefetchHooks Function()
        > {
  $$ProgressSnapshotCacheTableTableManager(
    _$AppDatabase db,
    $ProgressSnapshotCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressSnapshotCacheTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ProgressSnapshotCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProgressSnapshotCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> xpAtCurrentLevel = const Value.absent(),
                Value<int> xpForNextLevel = const Value.absent(),
                Value<int> currentStreakDays = const Value.absent(),
                Value<String> weaknessReportJson = const Value.absent(),
                Value<String?> activityReportJson = const Value.absent(),
                Value<int> computedAtUtcMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressSnapshotCacheCompanion(
                profileId: profileId,
                totalXp: totalXp,
                level: level,
                xpAtCurrentLevel: xpAtCurrentLevel,
                xpForNextLevel: xpForNextLevel,
                currentStreakDays: currentStreakDays,
                weaknessReportJson: weaknessReportJson,
                activityReportJson: activityReportJson,
                computedAtUtcMicros: computedAtUtcMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required int totalXp,
                required int level,
                required int xpAtCurrentLevel,
                required int xpForNextLevel,
                required int currentStreakDays,
                required String weaknessReportJson,
                Value<String?> activityReportJson = const Value.absent(),
                required int computedAtUtcMicros,
                Value<int> rowid = const Value.absent(),
              }) => ProgressSnapshotCacheCompanion.insert(
                profileId: profileId,
                totalXp: totalXp,
                level: level,
                xpAtCurrentLevel: xpAtCurrentLevel,
                xpForNextLevel: xpForNextLevel,
                currentStreakDays: currentStreakDays,
                weaknessReportJson: weaknessReportJson,
                activityReportJson: activityReportJson,
                computedAtUtcMicros: computedAtUtcMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ProgressSnapshotCacheTable,
                    ProgressSnapshotCacheRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProgressSnapshotCacheTable,
                    ProgressSnapshotCacheRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressSnapshotCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressSnapshotCacheTable,
      ProgressSnapshotCacheRow,
      $$ProgressSnapshotCacheTableFilterComposer,
      $$ProgressSnapshotCacheTableOrderingComposer,
      $$ProgressSnapshotCacheTableAnnotationComposer,
      $$ProgressSnapshotCacheTableCreateCompanionBuilder,
      $$ProgressSnapshotCacheTableUpdateCompanionBuilder,
      (
        ProgressSnapshotCacheRow,
        BaseReferences<
          _$AppDatabase,
          $ProgressSnapshotCacheTable,
          ProgressSnapshotCacheRow
        >,
      ),
      ProgressSnapshotCacheRow,
      PrefetchHooks Function()
    >;
typedef $$MasteryStatusCacheTableCreateCompanionBuilder =
    MasteryStatusCacheCompanion Function({
      required String profileId,
      required String category,
      required String difficulty,
      required bool isMastered,
      Value<int?> passCountInLastFive,
      required int evaluatedAtUtcMicros,
      Value<int> rowid,
    });
typedef $$MasteryStatusCacheTableUpdateCompanionBuilder =
    MasteryStatusCacheCompanion Function({
      Value<String> profileId,
      Value<String> category,
      Value<String> difficulty,
      Value<bool> isMastered,
      Value<int?> passCountInLastFive,
      Value<int> evaluatedAtUtcMicros,
      Value<int> rowid,
    });

class $$MasteryStatusCacheTableFilterComposer
    extends Composer<_$AppDatabase, $MasteryStatusCacheTable> {
  $$MasteryStatusCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get passCountInLastFive => $composableBuilder(
    column: $table.passCountInLastFive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get evaluatedAtUtcMicros => $composableBuilder(
    column: $table.evaluatedAtUtcMicros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MasteryStatusCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $MasteryStatusCacheTable> {
  $$MasteryStatusCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passCountInLastFive => $composableBuilder(
    column: $table.passCountInLastFive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get evaluatedAtUtcMicros => $composableBuilder(
    column: $table.evaluatedAtUtcMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MasteryStatusCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $MasteryStatusCacheTable> {
  $$MasteryStatusCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => column,
  );

  GeneratedColumn<int> get passCountInLastFive => $composableBuilder(
    column: $table.passCountInLastFive,
    builder: (column) => column,
  );

  GeneratedColumn<int> get evaluatedAtUtcMicros => $composableBuilder(
    column: $table.evaluatedAtUtcMicros,
    builder: (column) => column,
  );
}

class $$MasteryStatusCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MasteryStatusCacheTable,
          MasteryStatusCacheRow,
          $$MasteryStatusCacheTableFilterComposer,
          $$MasteryStatusCacheTableOrderingComposer,
          $$MasteryStatusCacheTableAnnotationComposer,
          $$MasteryStatusCacheTableCreateCompanionBuilder,
          $$MasteryStatusCacheTableUpdateCompanionBuilder,
          (
            MasteryStatusCacheRow,
            BaseReferences<
              _$AppDatabase,
              $MasteryStatusCacheTable,
              MasteryStatusCacheRow
            >,
          ),
          MasteryStatusCacheRow,
          PrefetchHooks Function()
        > {
  $$MasteryStatusCacheTableTableManager(
    _$AppDatabase db,
    $MasteryStatusCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasteryStatusCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MasteryStatusCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MasteryStatusCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<bool> isMastered = const Value.absent(),
                Value<int?> passCountInLastFive = const Value.absent(),
                Value<int> evaluatedAtUtcMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MasteryStatusCacheCompanion(
                profileId: profileId,
                category: category,
                difficulty: difficulty,
                isMastered: isMastered,
                passCountInLastFive: passCountInLastFive,
                evaluatedAtUtcMicros: evaluatedAtUtcMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String category,
                required String difficulty,
                required bool isMastered,
                Value<int?> passCountInLastFive = const Value.absent(),
                required int evaluatedAtUtcMicros,
                Value<int> rowid = const Value.absent(),
              }) => MasteryStatusCacheCompanion.insert(
                profileId: profileId,
                category: category,
                difficulty: difficulty,
                isMastered: isMastered,
                passCountInLastFive: passCountInLastFive,
                evaluatedAtUtcMicros: evaluatedAtUtcMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MasteryStatusCacheTable, MasteryStatusCacheRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $MasteryStatusCacheTable,
                    MasteryStatusCacheRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MasteryStatusCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MasteryStatusCacheTable,
      MasteryStatusCacheRow,
      $$MasteryStatusCacheTableFilterComposer,
      $$MasteryStatusCacheTableOrderingComposer,
      $$MasteryStatusCacheTableAnnotationComposer,
      $$MasteryStatusCacheTableCreateCompanionBuilder,
      $$MasteryStatusCacheTableUpdateCompanionBuilder,
      (
        MasteryStatusCacheRow,
        BaseReferences<
          _$AppDatabase,
          $MasteryStatusCacheTable,
          MasteryStatusCacheRow
        >,
      ),
      MasteryStatusCacheRow,
      PrefetchHooks Function()
    >;
typedef $$ProcessedSessionsTableCreateCompanionBuilder =
    ProcessedSessionsCompanion Function({
      required String sessionId,
      required String profileId,
      required int processedAtUtcMicros,
      Value<int> rowid,
    });
typedef $$ProcessedSessionsTableUpdateCompanionBuilder =
    ProcessedSessionsCompanion Function({
      Value<String> sessionId,
      Value<String> profileId,
      Value<int> processedAtUtcMicros,
      Value<int> rowid,
    });

class $$ProcessedSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ProcessedSessionsTable> {
  $$ProcessedSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get processedAtUtcMicros => $composableBuilder(
    column: $table.processedAtUtcMicros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProcessedSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProcessedSessionsTable> {
  $$ProcessedSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get processedAtUtcMicros => $composableBuilder(
    column: $table.processedAtUtcMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProcessedSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProcessedSessionsTable> {
  $$ProcessedSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get processedAtUtcMicros => $composableBuilder(
    column: $table.processedAtUtcMicros,
    builder: (column) => column,
  );
}

class $$ProcessedSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProcessedSessionsTable,
          ProcessedSessionRow,
          $$ProcessedSessionsTableFilterComposer,
          $$ProcessedSessionsTableOrderingComposer,
          $$ProcessedSessionsTableAnnotationComposer,
          $$ProcessedSessionsTableCreateCompanionBuilder,
          $$ProcessedSessionsTableUpdateCompanionBuilder,
          (
            ProcessedSessionRow,
            BaseReferences<
              _$AppDatabase,
              $ProcessedSessionsTable,
              ProcessedSessionRow
            >,
          ),
          ProcessedSessionRow,
          PrefetchHooks Function()
        > {
  $$ProcessedSessionsTableTableManager(
    _$AppDatabase db,
    $ProcessedSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProcessedSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProcessedSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProcessedSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> processedAtUtcMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProcessedSessionsCompanion(
                sessionId: sessionId,
                profileId: profileId,
                processedAtUtcMicros: processedAtUtcMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String profileId,
                required int processedAtUtcMicros,
                Value<int> rowid = const Value.absent(),
              }) => ProcessedSessionsCompanion.insert(
                sessionId: sessionId,
                profileId: profileId,
                processedAtUtcMicros: processedAtUtcMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProcessedSessionsTable, ProcessedSessionRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ProcessedSessionsTable,
                    ProcessedSessionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProcessedSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProcessedSessionsTable,
      ProcessedSessionRow,
      $$ProcessedSessionsTableFilterComposer,
      $$ProcessedSessionsTableOrderingComposer,
      $$ProcessedSessionsTableAnnotationComposer,
      $$ProcessedSessionsTableCreateCompanionBuilder,
      $$ProcessedSessionsTableUpdateCompanionBuilder,
      (
        ProcessedSessionRow,
        BaseReferences<
          _$AppDatabase,
          $ProcessedSessionsTable,
          ProcessedSessionRow
        >,
      ),
      ProcessedSessionRow,
      PrefetchHooks Function()
    >;
typedef $$LessonProgressCacheTableCreateCompanionBuilder =
    LessonProgressCacheCompanion Function({
      required String profileId,
      required String pathId,
      required String lessonId,
      required String status,
      Value<double?> bestAccuracyPct,
      Value<int?> completedAtUtcMicros,
      Value<int> rowid,
    });
typedef $$LessonProgressCacheTableUpdateCompanionBuilder =
    LessonProgressCacheCompanion Function({
      Value<String> profileId,
      Value<String> pathId,
      Value<String> lessonId,
      Value<String> status,
      Value<double?> bestAccuracyPct,
      Value<int?> completedAtUtcMicros,
      Value<int> rowid,
    });

class $$LessonProgressCacheTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressCacheTable> {
  $$LessonProgressCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pathId => $composableBuilder(
    column: $table.pathId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bestAccuracyPct => $composableBuilder(
    column: $table.bestAccuracyPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAtUtcMicros => $composableBuilder(
    column: $table.completedAtUtcMicros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LessonProgressCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressCacheTable> {
  $$LessonProgressCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pathId => $composableBuilder(
    column: $table.pathId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bestAccuracyPct => $composableBuilder(
    column: $table.bestAccuracyPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAtUtcMicros => $composableBuilder(
    column: $table.completedAtUtcMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonProgressCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressCacheTable> {
  $$LessonProgressCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get pathId =>
      $composableBuilder(column: $table.pathId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get bestAccuracyPct => $composableBuilder(
    column: $table.bestAccuracyPct,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAtUtcMicros => $composableBuilder(
    column: $table.completedAtUtcMicros,
    builder: (column) => column,
  );
}

class $$LessonProgressCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonProgressCacheTable,
          LessonProgressCacheRow,
          $$LessonProgressCacheTableFilterComposer,
          $$LessonProgressCacheTableOrderingComposer,
          $$LessonProgressCacheTableAnnotationComposer,
          $$LessonProgressCacheTableCreateCompanionBuilder,
          $$LessonProgressCacheTableUpdateCompanionBuilder,
          (
            LessonProgressCacheRow,
            BaseReferences<
              _$AppDatabase,
              $LessonProgressCacheTable,
              LessonProgressCacheRow
            >,
          ),
          LessonProgressCacheRow,
          PrefetchHooks Function()
        > {
  $$LessonProgressCacheTableTableManager(
    _$AppDatabase db,
    $LessonProgressCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LessonProgressCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> pathId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double?> bestAccuracyPct = const Value.absent(),
                Value<int?> completedAtUtcMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonProgressCacheCompanion(
                profileId: profileId,
                pathId: pathId,
                lessonId: lessonId,
                status: status,
                bestAccuracyPct: bestAccuracyPct,
                completedAtUtcMicros: completedAtUtcMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String pathId,
                required String lessonId,
                required String status,
                Value<double?> bestAccuracyPct = const Value.absent(),
                Value<int?> completedAtUtcMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonProgressCacheCompanion.insert(
                profileId: profileId,
                pathId: pathId,
                lessonId: lessonId,
                status: status,
                bestAccuracyPct: bestAccuracyPct,
                completedAtUtcMicros: completedAtUtcMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $LessonProgressCacheTable,
                    LessonProgressCacheRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LessonProgressCacheTable,
                    LessonProgressCacheRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LessonProgressCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonProgressCacheTable,
      LessonProgressCacheRow,
      $$LessonProgressCacheTableFilterComposer,
      $$LessonProgressCacheTableOrderingComposer,
      $$LessonProgressCacheTableAnnotationComposer,
      $$LessonProgressCacheTableCreateCompanionBuilder,
      $$LessonProgressCacheTableUpdateCompanionBuilder,
      (
        LessonProgressCacheRow,
        BaseReferences<
          _$AppDatabase,
          $LessonProgressCacheTable,
          LessonProgressCacheRow
        >,
      ),
      LessonProgressCacheRow,
      PrefetchHooks Function()
    >;
typedef $$AchievementsUnlockedTableCreateCompanionBuilder =
    AchievementsUnlockedCompanion Function({
      required String profileId,
      required String achievementId,
      required int unlockedAtUtcMicros,
      Value<String?> triggerSessionId,
      Value<int> rowid,
    });
typedef $$AchievementsUnlockedTableUpdateCompanionBuilder =
    AchievementsUnlockedCompanion Function({
      Value<String> profileId,
      Value<String> achievementId,
      Value<int> unlockedAtUtcMicros,
      Value<String?> triggerSessionId,
      Value<int> rowid,
    });

class $$AchievementsUnlockedTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsUnlockedTable> {
  $$AchievementsUnlockedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unlockedAtUtcMicros => $composableBuilder(
    column: $table.unlockedAtUtcMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerSessionId => $composableBuilder(
    column: $table.triggerSessionId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsUnlockedTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsUnlockedTable> {
  $$AchievementsUnlockedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unlockedAtUtcMicros => $composableBuilder(
    column: $table.unlockedAtUtcMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerSessionId => $composableBuilder(
    column: $table.triggerSessionId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsUnlockedTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsUnlockedTable> {
  $$AchievementsUnlockedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unlockedAtUtcMicros => $composableBuilder(
    column: $table.unlockedAtUtcMicros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get triggerSessionId => $composableBuilder(
    column: $table.triggerSessionId,
    builder: (column) => column,
  );
}

class $$AchievementsUnlockedTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsUnlockedTable,
          AchievementUnlockedRow,
          $$AchievementsUnlockedTableFilterComposer,
          $$AchievementsUnlockedTableOrderingComposer,
          $$AchievementsUnlockedTableAnnotationComposer,
          $$AchievementsUnlockedTableCreateCompanionBuilder,
          $$AchievementsUnlockedTableUpdateCompanionBuilder,
          (
            AchievementUnlockedRow,
            BaseReferences<
              _$AppDatabase,
              $AchievementsUnlockedTable,
              AchievementUnlockedRow
            >,
          ),
          AchievementUnlockedRow,
          PrefetchHooks Function()
        > {
  $$AchievementsUnlockedTableTableManager(
    _$AppDatabase db,
    $AchievementsUnlockedTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsUnlockedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsUnlockedTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AchievementsUnlockedTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> achievementId = const Value.absent(),
                Value<int> unlockedAtUtcMicros = const Value.absent(),
                Value<String?> triggerSessionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsUnlockedCompanion(
                profileId: profileId,
                achievementId: achievementId,
                unlockedAtUtcMicros: unlockedAtUtcMicros,
                triggerSessionId: triggerSessionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String achievementId,
                required int unlockedAtUtcMicros,
                Value<String?> triggerSessionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsUnlockedCompanion.insert(
                profileId: profileId,
                achievementId: achievementId,
                unlockedAtUtcMicros: unlockedAtUtcMicros,
                triggerSessionId: triggerSessionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AchievementsUnlockedTable,
                    AchievementUnlockedRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AchievementsUnlockedTable,
                    AchievementUnlockedRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsUnlockedTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsUnlockedTable,
      AchievementUnlockedRow,
      $$AchievementsUnlockedTableFilterComposer,
      $$AchievementsUnlockedTableOrderingComposer,
      $$AchievementsUnlockedTableAnnotationComposer,
      $$AchievementsUnlockedTableCreateCompanionBuilder,
      $$AchievementsUnlockedTableUpdateCompanionBuilder,
      (
        AchievementUnlockedRow,
        BaseReferences<
          _$AppDatabase,
          $AchievementsUnlockedTable,
          AchievementUnlockedRow
        >,
      ),
      AchievementUnlockedRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GuestProfilesTableTableManager get guestProfiles =>
      $$GuestProfilesTableTableManager(_db, _db.guestProfiles);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db, _db.snippets);
  $$TypingSessionsTableTableManager get typingSessions =>
      $$TypingSessionsTableTableManager(_db, _db.typingSessions);
  $$KeystrokeEventsTableTableManager get keystrokeEvents =>
      $$KeystrokeEventsTableTableManager(_db, _db.keystrokeEvents);
  $$ProgressSnapshotCacheTableTableManager get progressSnapshotCache =>
      $$ProgressSnapshotCacheTableTableManager(_db, _db.progressSnapshotCache);
  $$MasteryStatusCacheTableTableManager get masteryStatusCache =>
      $$MasteryStatusCacheTableTableManager(_db, _db.masteryStatusCache);
  $$ProcessedSessionsTableTableManager get processedSessions =>
      $$ProcessedSessionsTableTableManager(_db, _db.processedSessions);
  $$LessonProgressCacheTableTableManager get lessonProgressCache =>
      $$LessonProgressCacheTableTableManager(_db, _db.lessonProgressCache);
  $$AchievementsUnlockedTableTableManager get achievementsUnlocked =>
      $$AchievementsUnlockedTableTableManager(_db, _db.achievementsUnlocked);
}
