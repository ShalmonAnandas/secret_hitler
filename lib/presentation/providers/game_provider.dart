import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/game.dart';
import '../../domain/usecases/game_usecase.dart';
import 'app_providers.dart';

// Use the gameUseCaseProvider directly from app_providers.dart

/// Provider for creating a new game
final createGameProvider =
    StateNotifierProvider<CreateGameNotifier, AsyncValue<Game?>>((ref) {
      final gameUseCase = ref.read(gameUseCaseProvider);
      return CreateGameNotifier(gameUseCase);
    });

/// Provider for joining a game
final joinGameProvider =
    StateNotifierProvider<JoinGameNotifier, AsyncValue<bool>>((ref) {
      final gameUseCase = ref.read(gameUseCaseProvider);
      return JoinGameNotifier(gameUseCase);
    });

/// Provider for watching a specific game
final gameProvider =
    StateNotifierProvider.family<GameNotifier, AsyncValue<Game?>, String>((
      ref,
      gameId,
    ) {
      final gameUseCase = ref.read(gameUseCaseProvider);
      return GameNotifier(gameUseCase, gameId);
    });

/// Provider for active games list
final activeGamesProvider =
    StateNotifierProvider<ActiveGamesNotifier, AsyncValue<List<Game>>>((ref) {
      final gameUseCase = ref.read(gameUseCaseProvider);
      return ActiveGamesNotifier(gameUseCase);
    });

/// Notifier for creating games
class CreateGameNotifier extends StateNotifier<AsyncValue<Game?>> {
  final GameUseCase _gameUseCase;

  CreateGameNotifier(this._gameUseCase) : super(const AsyncValue.data(null));

  Future<Game?> createGame({
    required String hostId,
    required String hostName,
    int? maxPlayers,
  }) async {
    state = const AsyncValue.loading();
    try {
      final game = await _gameUseCase.createGame(
        hostId: hostId,
        hostName: hostName,
        maxPlayers: maxPlayers,
      );
      state = AsyncValue.data(game);
      return game;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Notifier for joining games
class JoinGameNotifier extends StateNotifier<AsyncValue<bool>> {
  final GameUseCase _gameUseCase;

  JoinGameNotifier(this._gameUseCase) : super(const AsyncValue.data(false));

  Future<bool> joinGame({
    required String gameCode,
    required String playerId,
    required String playerName,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _gameUseCase.joinGame(
        gameCode: gameCode,
        playerId: playerId,
        playerName: playerName,
      );
      state = const AsyncValue.data(true);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(false);
  }
}

/// Notifier for game state
class GameNotifier extends StateNotifier<AsyncValue<Game?>> {
  final GameUseCase _gameUseCase;
  final String _gameId;

  GameNotifier(this._gameUseCase, this._gameId)
    : super(const AsyncValue.loading()) {
    _loadGame();
  }

  Future<void> _loadGame() async {
    try {
      final game = await _gameUseCase.getGameById(_gameId);
      state = AsyncValue.data(game);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> startGame({required String hostId}) async {
    try {
      await _gameUseCase.startGame(_gameId, hostId);
      await _loadGame(); // Refresh game state
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> leaveGame({required String playerId}) async {
    try {
      await _gameUseCase.leaveGame(_gameId, playerId);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> endGame() async {
    try {
      await _gameUseCase.endGame(_gameId);
      await _loadGame(); // Refresh game state
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void refresh() {
    _loadGame();
  }
}

/// Notifier for active games
class ActiveGamesNotifier extends StateNotifier<AsyncValue<List<Game>>> {
  final GameUseCase _gameUseCase;

  ActiveGamesNotifier(this._gameUseCase) : super(const AsyncValue.loading()) {
    _loadActiveGames();
  }

  Future<void> _loadActiveGames() async {
    try {
      final games = await _gameUseCase.getActiveGames();
      state = AsyncValue.data(games);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void refresh() {
    _loadActiveGames();
  }
}
