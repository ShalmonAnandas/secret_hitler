/// Helper class for rendering the game board based on player count
class GameBoardConfig {
  /// Get fascist board configuration based on player count
  static List<BoardSpace> getFascistTrack(int playerCount) {
    // Return fascist track configuration for different player counts
    final List<BoardSpace> track = [
      // First three spaces are common for all player counts
      BoardSpace.policy, // 1st Fascist Policy
      BoardSpace.policy, // 2nd Fascist Policy
      BoardSpace.policy, // 3rd Fascist Policy
    ];

    // 4th space varies based on player count
    if (playerCount <= 6) {
      // 5-6 players: Peek at top three policies
      track.add(BoardSpace.policyPeek);
    } else if (playerCount <= 8) {
      // 7-8 players: Investigate loyalty
      track.add(BoardSpace.investigateLoyalty);
    } else {
      // 9-10 players: Investigate loyalty
      track.add(BoardSpace.investigateLoyalty);
    }

    // 5th space varies based on player count
    if (playerCount <= 6) {
      // 5-6 players: Execution
      track.add(BoardSpace.execution);
    } else if (playerCount <= 8) {
      // 7-8 players: Special election
      track.add(BoardSpace.specialElection);
    } else {
      // 9-10 players: Special election
      track.add(BoardSpace.specialElection);
    }

    // 6th space is execution for all player counts (and game-winning space for fascists)
    track.add(BoardSpace.execution);

    return track;
  }

  /// Get liberal board configuration
  static List<BoardSpace> getLiberalTrack() {
    // Liberal track is the same for all player counts: 5 policy spaces
    return List<BoardSpace>.filled(5, BoardSpace.policy);
  }

  /// Get role distribution for a given player count
  static RoleDistribution getRoleDistribution(int playerCount) {
    switch (playerCount) {
      case 5:
        return RoleDistribution(liberals: 3, fascists: 1, hitler: 1);
      case 6:
        return RoleDistribution(liberals: 4, fascists: 1, hitler: 1);
      case 7:
        return RoleDistribution(liberals: 4, fascists: 2, hitler: 1);
      case 8:
        return RoleDistribution(liberals: 5, fascists: 2, hitler: 1);
      case 9:
        return RoleDistribution(liberals: 5, fascists: 3, hitler: 1);
      case 10:
        return RoleDistribution(liberals: 6, fascists: 3, hitler: 1);
      default:
        // Default to 5 players if invalid count provided
        return RoleDistribution(liberals: 3, fascists: 1, hitler: 1);
    }
  }

  /// Get whether fascists know each other's identity
  static bool fascistsKnowEachOther(int playerCount) {
    // In all player counts, fascists know each other
    return true;
  }

  /// Get whether Hitler knows who the fascists are
  static bool hitlerKnowsFascists(int playerCount) {
    // Hitler only knows who the fascists are in 5-6 player games
    return playerCount <= 6;
  }
}

/// Represents a space on the game board
enum BoardSpace {
  policy,
  policyPeek,
  investigateLoyalty,
  specialElection,
  execution,
}

/// Represents the role distribution for a game
class RoleDistribution {
  final int liberals;
  final int fascists;
  final int hitler;

  const RoleDistribution({
    required this.liberals,
    required this.fascists,
    required this.hitler,
  });

  /// Total number of players
  int get totalPlayers => liberals + fascists + hitler;
}
