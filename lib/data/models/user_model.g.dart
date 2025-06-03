// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  email: json['email'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastSeen: DateTime.parse(json['lastSeen'] as String),
  stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
  preferences: UserPreferences.fromJson(
    json['preferences'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'email': instance.email,
  'avatarUrl': instance.avatarUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastSeen': instance.lastSeen.toIso8601String(),
  'stats': instance.stats,
  'preferences': instance.preferences,
};

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
  gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
  gamesWon: (json['gamesWon'] as num?)?.toInt() ?? 0,
  liberalWins: (json['liberalWins'] as num?)?.toInt() ?? 0,
  fascistWins: (json['fascistWins'] as num?)?.toInt() ?? 0,
  hitlerWins: (json['hitlerWins'] as num?)?.toInt() ?? 0,
  timesAsPresident: (json['timesAsPresident'] as num?)?.toInt() ?? 0,
  timesAsChancellor: (json['timesAsChancellor'] as num?)?.toInt() ?? 0,
  timesExecuted: (json['timesExecuted'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
  'gamesPlayed': instance.gamesPlayed,
  'gamesWon': instance.gamesWon,
  'liberalWins': instance.liberalWins,
  'fascistWins': instance.fascistWins,
  'hitlerWins': instance.hitlerWins,
  'timesAsPresident': instance.timesAsPresident,
  'timesAsChancellor': instance.timesAsChancellor,
  'timesExecuted': instance.timesExecuted,
};

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      autoReadyEnabled: json['autoReadyEnabled'] as bool? ?? false,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'autoReadyEnabled': instance.autoReadyEnabled,
      'preferredLanguage': instance.preferredLanguage,
      'darkModeEnabled': instance.darkModeEnabled,
    };
