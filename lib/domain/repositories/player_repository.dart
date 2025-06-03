import '../entities/player.dart';

/// Repository interface for player-related operations
abstract class PlayerRepository {
  /// Add player to game
  Future<void> addPlayer(String gameId, Player player);

  /// Remove player from game
  Future<void> removePlayer(String gameId, String playerId);

  /// Update player data
  Future<void> updatePlayer(String gameId, Player player);

  /// Get player by ID in a specific game
  Future<Player?> getPlayer(String gameId, String playerId);

  /// Get all players in a game
  Future<List<Player>> getPlayers(String gameId);

  /// Watch players in a game in real-time
  Stream<List<Player>> watchPlayers(String gameId);

  /// Watch specific player in real-time
  Stream<Player?> watchPlayer(String gameId, String playerId);

  /// Assign roles to players
  Future<void> assignRoles(String gameId, Map<String, String> playerRoles);

  /// Update player status
  Future<void> updatePlayerStatus(
    String gameId,
    String playerId,
    String status,
  );

  /// Get players by role
  Future<List<Player>> getPlayersByRole(String gameId, String role);

  /// Check if player is in game
  Future<bool> isPlayerInGame(String gameId, String playerId);
}
