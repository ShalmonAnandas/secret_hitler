import 'dart:math';
import '../constants/enums.dart';
import '../constants/game_constants.dart';

/// Utility functions for Secret Hitler game logic
class GameUtils {
  /// Generates a random access code for private lobbies
  static String generateAccessCode({int length = 6}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Determines which presidential powers are available for a given player count and fascist policy count
  static List<PresidentialPower> getAvailablePresidentialPowers(
    int playerCount,
    int fascistPoliciesEnacted,
  ) {
    final powerIndices =
        GameConstants.presidentialPowersByPlayerCount[playerCount] ?? [];
    if (!powerIndices.contains(fascistPoliciesEnacted)) {
      return [];
    }

    // Powers are activated in order based on player count
    switch (playerCount) {
      case 5:
      case 6:
        switch (fascistPoliciesEnacted) {
          case 3:
            return [PresidentialPower.policyPeek];
          case 4:
            return [PresidentialPower.execution];
          case 5:
            return [PresidentialPower.execution];
          default:
            return [];
        }
      case 7:
      case 8:
        switch (fascistPoliciesEnacted) {
          case 2:
            return [PresidentialPower.investigateLoyalty];
          case 3:
            return [PresidentialPower.specialElection];
          case 4:
            return [PresidentialPower.execution];
          case 5:
            return [PresidentialPower.execution];
          default:
            return [];
        }
      case 9:
      case 10:
        switch (fascistPoliciesEnacted) {
          case 1:
            return [PresidentialPower.investigateLoyalty];
          case 2:
            return [PresidentialPower.investigateLoyalty];
          case 3:
            return [PresidentialPower.specialElection];
          case 4:
            return [PresidentialPower.execution];
          case 5:
            return [PresidentialPower.execution];
          default:
            return [];
        }
      default:
        return [];
    }
  }

  /// Checks if Hitler can be elected Chancellor (only after 3+ Fascist policies)
  static bool canHitlerBeElectedChancellor(int fascistPoliciesEnacted) {
    return fascistPoliciesEnacted >= 3;
  }

  /// Determines if a player is eligible to be nominated as Chancellor
  static bool isPlayerEligibleForChancellor(
    String playerId,
    String? currentPresidentId,
    String? previousChancellorId,
    List<String> alivePlayers,
  ) {
    // Cannot nominate yourself
    if (playerId == currentPresidentId) return false;

    // Cannot nominate the previous Chancellor (unless only 5 players total)
    if (playerId == previousChancellorId && alivePlayers.length > 5)
      return false;

    // Player must be alive
    if (!alivePlayers.contains(playerId)) return false;

    return true;
  }

  /// Calculates the next President in turn order
  static String getNextPresidentInOrder(
    List<String> playerOrder,
    String currentPresidentId,
    List<String> alivePlayers,
  ) {
    final currentIndex = playerOrder.indexOf(currentPresidentId);
    if (currentIndex == -1) return playerOrder.first;

    // Find next alive player in order
    for (int i = 1; i <= playerOrder.length; i++) {
      final nextIndex = (currentIndex + i) % playerOrder.length;
      final nextPlayerId = playerOrder[nextIndex];
      if (alivePlayers.contains(nextPlayerId)) {
        return nextPlayerId;
      }
    }

    // Fallback to first alive player
    return alivePlayers.first;
  }

  /// Checks if the game should end based on current state
  static GameResult? checkGameEndConditions(
    int liberalPoliciesEnacted,
    int fascistPoliciesEnacted,
    bool hitlerElectedChancellor,
    bool hitlerExecuted,
  ) {
    // Liberal victories
    if (liberalPoliciesEnacted >= GameConstants.liberalPoliciesNeededToWin) {
      return GameResult.liberalPolicyVictory;
    }
    if (hitlerExecuted) {
      return GameResult.hitlerAssassinatedVictory;
    }

    // Fascist victories
    if (fascistPoliciesEnacted >= GameConstants.fascistPoliciesNeededToWin) {
      return GameResult.fascistPolicyVictory;
    }
    if (hitlerElectedChancellor && fascistPoliciesEnacted >= 3) {
      return GameResult.hitlerElectedVictory;
    }

    return null;
  }

  /// Validates if a game action is allowed in the current game state
  static bool isActionAllowedInPhase(String action, GamePhase currentPhase) {
    switch (action) {
      case 'nominate_chancellor':
        return currentPhase == GamePhase.nomination;
      case 'vote':
        return currentPhase == GamePhase.election;
      case 'discard_policy':
      case 'enact_policy':
      case 'veto_policies':
        return currentPhase == GamePhase.legislative;
      case 'use_presidential_power':
        return currentPhase == GamePhase.presidentialPower;
      default:
        return false;
    }
  }

  /// Shuffles a list using Fisher-Yates algorithm
  static List<T> shuffleList<T>(List<T> list) {
    final shuffled = List<T>.from(list);
    final random = Random();

    for (int i = shuffled.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }

    return shuffled;
  }

  /// Creates a standard policy deck
  static List<PolicyType> createStandardPolicyDeck() {
    final deck = <PolicyType>[];

    // Add Liberal policies
    for (int i = 0; i < GameConstants.totalLiberalPolicies; i++) {
      deck.add(PolicyType.liberal);
    }

    // Add Fascist policies
    for (int i = 0; i < GameConstants.totalFascistPolicies; i++) {
      deck.add(PolicyType.fascist);
    }

    return shuffleList(deck);
  }

  /// Validates lobby configuration
  static bool isValidLobbyConfiguration(
    int playerCount,
    int minPlayers,
    int maxPlayers,
  ) {
    return playerCount >= minPlayers &&
        playerCount <= maxPlayers &&
        minPlayers >= GameConstants.minPlayers &&
        maxPlayers <= GameConstants.maxPlayers;
  }

  /// Assigns roles randomly to players based on player count
  static List<Role> assignRoles(int playerCount) {
    if (playerCount < GameConstants.minPlayers ||
        playerCount > GameConstants.maxPlayers) {
      throw ArgumentError('Invalid player count: $playerCount');
    }

    final distribution = GameConstants.roleDistribution[playerCount];
    if (distribution == null) {
      throw ArgumentError(
        'No role distribution found for $playerCount players',
      );
    }

    final roles = <Role>[];

    // Add Hitler
    for (int i = 0; i < distribution.hitler; i++) {
      roles.add(Role.hitler);
    }

    // Add Fascists
    for (int i = 0; i < distribution.fascists; i++) {
      roles.add(Role.fascist);
    }

    // Add Liberals
    for (int i = 0; i < distribution.liberals; i++) {
      roles.add(Role.liberal);
    }

    // Shuffle the roles randomly
    return shuffleList(roles);
  }
}
