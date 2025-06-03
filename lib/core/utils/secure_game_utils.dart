import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Utility class for handling encryption and security for game data
class SecureGameUtils {
  /// Generate a secure random game code (6 characters)
  static String generateGameCode() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Removed similar looking chars
    Random rnd = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  /// Hash a player ID with game ID for secure lookup
  static String hashPlayerGameId(String playerId, String gameId) {
    final bytes = utf8.encode('$playerId:$gameId:secret_hitler');
    return sha256.convert(bytes).toString();
  }

  /// Securely shuffle a deck of policies
  /// This should ideally be done on the server side with Cloud Functions
  static List<String> secureShuffleDeck(List<String> deck) {
    final rng = Random.secure();
    // Fisher-Yates shuffle algorithm
    for (int i = deck.length - 1; i > 0; i--) {
      int j = rng.nextInt(i + 1);
      String temp = deck[i];
      deck[i] = deck[j];
      deck[j] = temp;
    }
    return deck;
  }

  /// Validate a game code format
  static bool isValidGameCode(String code) {
    // Game code should be 6 uppercase alphanumeric characters
    final RegExp codeRegex = RegExp(r'^[A-Z0-9]{6}$');
    return codeRegex.hasMatch(code);
  }

  /// Create a secure identifier for hidden game state
  static String createSecureStateId(String gameId, String stateType) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomSuffix = Random.secure().nextInt(10000);
    final bytes = utf8.encode('$gameId:$stateType:$timestamp:$randomSuffix');
    return sha256.convert(bytes).toString().substring(0, 20);
  }

  /// Verify player permissions for a specific action
  static bool canPerformAction(
    String playerId,
    String gameId,
    String actionType,
    Map<String, dynamic> gameState,
  ) {
    switch (actionType) {
      case 'vote':
        return gameState['phase'] == 'election' &&
            gameState['players'].contains(playerId) &&
            !gameState['votes'].containsKey(playerId);

      case 'nominateChancellor':
        return gameState['phase'] == 'nomination' &&
            gameState['currentPresidentId'] == playerId;

      case 'drawPolicies':
        return gameState['phase'] == 'legislative' &&
            gameState['currentPresidentId'] == playerId &&
            gameState['legislativeStage'] == 'draw';

      case 'passPolicies':
        return gameState['phase'] == 'legislative' &&
            gameState['currentPresidentId'] == playerId &&
            gameState['legislativeStage'] == 'president_discard';

      case 'enactPolicy':
        return gameState['phase'] == 'legislative' &&
            gameState['currentChancellorId'] == playerId &&
            gameState['legislativeStage'] == 'chancellor_discard';

      default:
        return false;
    }
  }
}
