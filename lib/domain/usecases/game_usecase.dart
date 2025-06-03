import '../../core/constants/game_constants.dart';
import '../../core/constants/enums.dart';
import '../../core/utils/game_utils.dart';
import '../entities/game.dart';
import '../entities/player.dart';
import '../repositories/game_repository.dart';
import '../repositories/player_repository.dart';

/// Use case for game management operations
class GameUseCase {
  final GameRepository _gameRepository;
  final PlayerRepository _playerRepository;

  GameUseCase(this._gameRepository, this._playerRepository);

  /// Create a new game
  Future<Game> createGame({
    required String hostId,
    required String hostName,
    int? maxPlayers,
  }) async {
    if (hostId.isEmpty || hostName.isEmpty) {
      throw ArgumentError('Host ID and name cannot be empty');
    }

    final gameCode = await _gameRepository.generateGameCode();
    final game = await _gameRepository.createGame(
      hostId: hostId,
      hostName: hostName,
      gameCode: gameCode,
      maxPlayers: maxPlayers ?? GameConstants.defaultMaxPlayers,
    ); // Add host as first player
    final hostPlayer = Player(
      id: hostId,
      userId: hostId,
      username: hostName,
      role: Role.liberal, // Temporary role, will be assigned when game starts
      team: Team.liberal, // Temporary team, will be assigned when game starts
      position: 0,
      isHost: true,
      joinedAt: DateTime.now(),
    );

    await _playerRepository.addPlayer(game.id, hostPlayer);

    return game;
  }

  /// Join an existing game
  Future<void> joinGame({
    required String gameCode,
    required String playerId,
    required String playerName,
  }) async {
    if (gameCode.isEmpty || playerId.isEmpty || playerName.isEmpty) {
      throw ArgumentError('Game code, player ID, and name cannot be empty');
    }

    final game = await _gameRepository.getGameByCode(gameCode);
    if (game == null) {
      throw Exception('Game not found');
    }

    if (game.status != GameStatus.waiting) {
      throw Exception('Game is not accepting new players');
    }

    final players = await _playerRepository.getPlayers(game.id);
    if (players.length >= game.maxPlayers) {
      throw Exception('Game is full');
    }

    // Check if player is already in game
    if (await _playerRepository.isPlayerInGame(game.id, playerId)) {
      throw Exception('Player is already in this game');
    }
    final existingPlayers = await _playerRepository.getPlayers(game.id);
    final playerPosition = existingPlayers.length; // Next available position

    final player = Player(
      id: playerId,
      userId: playerId,
      username: playerName,
      role: Role.liberal, // Temporary role, will be assigned when game starts
      team: Team.liberal, // Temporary team, will be assigned when game starts
      position: playerPosition,
      isHost: false,
      joinedAt: DateTime.now(),
    );

    await _playerRepository.addPlayer(game.id, player);
  }

  /// Leave a game
  Future<void> leaveGame(String gameId, String playerId) async {
    if (gameId.isEmpty || playerId.isEmpty) {
      throw ArgumentError('Game ID and player ID cannot be empty');
    }

    final game = await _gameRepository.getGameById(gameId);
    if (game == null) {
      throw Exception('Game not found');
    }

    await _playerRepository.removePlayer(gameId, playerId);

    // If host leaves, transfer host or end game
    final player = await _playerRepository.getPlayer(gameId, playerId);
    if (player?.isHost == true) {
      final remainingPlayers = await _playerRepository.getPlayers(gameId);
      if (remainingPlayers.isEmpty) {
        await _gameRepository.deleteGame(gameId);
      } else {
        // Transfer host to next player
        final newHost = remainingPlayers.first.copyWith(isHost: true);
        await _playerRepository.updatePlayer(gameId, newHost);
      }
    }
  }

  /// Start a game
  Future<void> startGame(String gameId, String hostId) async {
    if (gameId.isEmpty || hostId.isEmpty) {
      throw ArgumentError('Game ID and host ID cannot be empty');
    }

    final game = await _gameRepository.getGameById(gameId);
    if (game == null) {
      throw Exception('Game not found');
    }

    if (game.hostId != hostId) {
      throw Exception('Only the host can start the game');
    }

    final players = await _playerRepository.getPlayers(gameId);
    if (players.length < GameConstants.minPlayers) {
      throw Exception('Not enough players to start the game');
    }

    if (players.length > GameConstants.maxPlayers) {
      throw Exception('Too many players to start the game');
    } // Assign roles to players
    final roles = GameUtils.assignRoles(players.length);
    final playerRoles = <String, String>{};

    for (int i = 0; i < players.length; i++) {
      playerRoles[players[i].id] = roles[i].toString().split('.').last;
    }

    await _playerRepository.assignRoles(gameId, playerRoles);
    // Update game status
    final updatedGame = game.copyWith(
      status: GameStatus.inProgress,
      phase: GamePhase.election,
      updatedAt: DateTime.now(),
    );

    await _gameRepository.updateGame(updatedGame);
  }

  /// End a game
  Future<void> endGame(String gameId) async {
    if (gameId.isEmpty) {
      throw ArgumentError('Game ID cannot be empty');
    }

    final game = await _gameRepository.getGameById(gameId);
    if (game == null) {
      throw Exception('Game not found');
    }
    final updatedGame = game.copyWith(
      status: GameStatus.finished,
      updatedAt: DateTime.now(),
    );

    await _gameRepository.updateGame(updatedGame);
  }

  /// Get game by ID
  Future<Game?> getGameById(String gameId) async {
    return await _gameRepository.getGameById(gameId);
  }

  /// Get game by code
  Future<Game?> getGameByCode(String gameCode) async {
    return await _gameRepository.getGameByCode(gameCode);
  }

  /// Watch game changes
  Stream<Game?> watchGame(String gameId) {
    return _gameRepository.watchGame(gameId);
  }

  /// Get active games
  Future<List<Game>> getActiveGames() async {
    return await _gameRepository.getActiveGames();
  }

  /// Watch active games
  Stream<List<Game>> watchActiveGames() {
    return _gameRepository.watchActiveGames();
  }
}
