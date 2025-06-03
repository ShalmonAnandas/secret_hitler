import 'package:equatable/equatable.dart';

/// Domain entity representing a user
class User extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime lastSeen;
  final UserStatistics stats;
  final UserPreferencesEntity preferences;

  const User({
    required this.id,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    required this.lastSeen,
    required this.stats,
    required this.preferences,
  });

  User copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastSeen,
    UserStatistics? stats,
    UserPreferencesEntity? preferences,
  }) {
    return User(
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

/// Domain entity for user statistics
class UserStatistics extends Equatable {
  final int gamesPlayed;
  final int gamesWon;
  final int liberalWins;
  final int fascistWins;
  final int hitlerWins;
  final int timesAsPresident;
  final int timesAsChancellor;
  final int timesExecuted;

  const UserStatistics({
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.liberalWins = 0,
    this.fascistWins = 0,
    this.hitlerWins = 0,
    this.timesAsPresident = 0,
    this.timesAsChancellor = 0,
    this.timesExecuted = 0,
  });

  double get winRate => gamesPlayed > 0 ? gamesWon / gamesPlayed : 0.0;

  UserStatistics copyWith({
    int? gamesPlayed,
    int? gamesWon,
    int? liberalWins,
    int? fascistWins,
    int? hitlerWins,
    int? timesAsPresident,
    int? timesAsChancellor,
    int? timesExecuted,
  }) {
    return UserStatistics(
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

/// Domain entity for user preferences
class UserPreferencesEntity extends Equatable {
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool autoReadyEnabled;
  final String preferredLanguage;
  final bool darkModeEnabled;

  const UserPreferencesEntity({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.autoReadyEnabled = false,
    this.preferredLanguage = 'en',
    this.darkModeEnabled = false,
  });

  UserPreferencesEntity copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? autoReadyEnabled,
    String? preferredLanguage,
    bool? darkModeEnabled,
  }) {
    return UserPreferencesEntity(
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
