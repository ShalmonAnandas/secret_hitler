import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Represents a user's public profile information
@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime lastSeen;
  final UserStats stats;
  final UserPreferences preferences;

  const UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    required this.lastSeen,
    required this.stats,
    required this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastSeen,
    UserStats? stats,
    UserPreferences? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      stats: stats ?? this.stats,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    email,
    avatarUrl,
    createdAt,
    lastSeen,
    stats,
    preferences,
  ];
}

/// User game statistics
@JsonSerializable()
class UserStats extends Equatable {
  final int gamesPlayed;
  final int gamesWon;
  final int liberalWins;
  final int fascistWins;
  final int hitlerWins;
  final int timesAsPresident;
  final int timesAsChancellor;
  final int timesExecuted;

  const UserStats({
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.liberalWins = 0,
    this.fascistWins = 0,
    this.hitlerWins = 0,
    this.timesAsPresident = 0,
    this.timesAsChancellor = 0,
    this.timesExecuted = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsToJson(this);

  double get winRate => gamesPlayed > 0 ? gamesWon / gamesPlayed : 0.0;

  UserStats copyWith({
    int? gamesPlayed,
    int? gamesWon,
    int? liberalWins,
    int? fascistWins,
    int? hitlerWins,
    int? timesAsPresident,
    int? timesAsChancellor,
    int? timesExecuted,
  }) {
    return UserStats(
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
      liberalWins: liberalWins ?? this.liberalWins,
      fascistWins: fascistWins ?? this.fascistWins,
      hitlerWins: hitlerWins ?? this.hitlerWins,
      timesAsPresident: timesAsPresident ?? this.timesAsPresident,
      timesAsChancellor: timesAsChancellor ?? this.timesAsChancellor,
      timesExecuted: timesExecuted ?? this.timesExecuted,
    );
  }

  @override
  List<Object?> get props => [
    gamesPlayed,
    gamesWon,
    liberalWins,
    fascistWins,
    hitlerWins,
    timesAsPresident,
    timesAsChancellor,
    timesExecuted,
  ];
}

/// User preferences and settings
@JsonSerializable()
class UserPreferences extends Equatable {
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool autoReadyEnabled;
  final String preferredLanguage;
  final bool darkModeEnabled;

  const UserPreferences({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.autoReadyEnabled = false,
    this.preferredLanguage = 'en',
    this.darkModeEnabled = false,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? autoReadyEnabled,
    String? preferredLanguage,
    bool? darkModeEnabled,
  }) {
    return UserPreferences(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      autoReadyEnabled: autoReadyEnabled ?? this.autoReadyEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  @override
  List<Object?> get props => [
    soundEnabled,
    vibrationEnabled,
    autoReadyEnabled,
    preferredLanguage,
    darkModeEnabled,
  ];
}
