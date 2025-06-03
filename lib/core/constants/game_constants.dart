/// Game-related constants for Secret Hitler
class GameConstants {
  // Player count constraints
  static const int minPlayers = 5;
  static const int maxPlayers = 10;
  static const int defaultMaxPlayers = 10;

  // Policy counts
  static const int totalLiberalPolicies = 6;
  static const int totalFascistPolicies = 11;
  static const int liberalPoliciesNeededToWin = 5;
  static const int fascistPoliciesNeededToWin = 6;

  // Election tracker
  static const int maxFailedElections = 3;

  // Presidential powers activation thresholds (varies by player count)
  static const Map<int, List<int>> presidentialPowersByPlayerCount = {
    5: [3, 4, 5], // 5-6 players: powers at 3rd, 4th, 5th fascist policy
    6: [3, 4, 5],
    7: [2, 3, 4, 5], // 7-8 players: powers at 2nd, 3rd, 4th, 5th fascist policy
    8: [2, 3, 4, 5],
    9: [1, 2, 3, 4, 5], // 9-10 players: powers at every fascist policy
    10: [1, 2, 3, 4, 5],
  };

  // Role distribution by player count
  static const Map<int, GameRoleDistribution> roleDistribution = {
    5: GameRoleDistribution(liberals: 3, fascists: 1, hitler: 1),
    6: GameRoleDistribution(liberals: 4, fascists: 1, hitler: 1),
    7: GameRoleDistribution(liberals: 4, fascists: 2, hitler: 1),
    8: GameRoleDistribution(liberals: 5, fascists: 2, hitler: 1),
    9: GameRoleDistribution(liberals: 5, fascists: 3, hitler: 1),
    10: GameRoleDistribution(liberals: 6, fascists: 3, hitler: 1),
  };

  // Game timing constants
  static const Duration votingTimeout = Duration(minutes: 2);
  static const Duration actionTimeout = Duration(minutes: 3);
  static const Duration lobbyTimeout = Duration(minutes: 30);
}

class GameRoleDistribution {
  final int liberals;
  final int fascists;
  final int hitler;

  const GameRoleDistribution({
    required this.liberals,
    required this.fascists,
    required this.hitler,
  });

  int get totalPlayers => liberals + fascists + hitler;
}

/// Firestore collection and field names
class FirestoreConstants {
  // Collection names
  static const String users = 'users';
  static const String games = 'games';
  static const String players = 'players';
  static const String policyDeck = 'policyDeck';
  static const String discardPile = 'discardPile';
  static const String chat = 'chat';

  // Common field names
  static const String id = 'id';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String userId = 'userId';
  static const String gameId = 'gameId';
}

/// App-wide UI constants
class AppConstants {
  // App info
  static const String appName = 'Secret Hitler';
  static const String appVersion = '1.0.0';

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
