import '../entities/game.dart';

/// Repository interface for game-related operations
abstract class GameRepository {
  /// Create a new game
  Future<Game> createGame({
    required String hostId,
    required String hostName,
    String? gameCode,
    int? maxPlayers,
  });

  /// Get game by ID
  Future<Game?> getGameById(String gameId);

  /// Get game by code
  Future<Game?> getGameByCode(String gameCode);

  /// Update game state
  Future<void> updateGame(Game game);

  /// Delete game
  Future<void> deleteGame(String gameId);

  /// Join a game
  Future<void> joinGame(String gameId, String playerId, String playerName);

  /// Leave a game
  Future<void> leaveGame(String gameId, String playerId);

  /// Start a game
  Future<void> startGame(String gameId);

  /// End a game
  Future<void> endGame(String gameId);

  /// Get all active games
  Future<List<Game>> getActiveGames();

  /// Get games by host
  Future<List<Game>> getGamesByHost(String hostId);

  /// Watch game changes in real-time
  Stream<Game?> watchGame(String gameId);

  /// Watch active games in real-time
  Stream<List<Game>> watchActiveGames();

  /// Check if game code exists
  Future<bool> gameCodeExists(String gameCode);

  /// Generate unique game code
  Future<String> generateGameCode();
}
