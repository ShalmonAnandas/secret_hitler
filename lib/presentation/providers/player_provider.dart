import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/player.dart';
import '../../domain/usecases/game_usecase.dart';
import 'app_providers.dart';

/// Provider for players in a specific game (stream)
final playersStreamProvider = StreamProvider.family<List<Player>, String>((
  ref,
  gameId,
) {
  final gameUseCase = ref.read(gameUseCaseProvider);
  return gameUseCase.watchPlayers(gameId);
});

/// Provider for a specific player in a game
final playerProvider = FutureProvider.family<Player?, PlayerRequest>((
  ref,
  request,
) async {
  final gameUseCase = ref.read(gameUseCaseProvider);
  return gameUseCase.getPlayer(request.gameId, request.playerId);
});

/// Provider for managing player actions
final playerActionsProvider =
    StateNotifierProvider<PlayerActionsNotifier, AsyncValue<void>>((ref) {
      final gameUseCase = ref.read(gameUseCaseProvider);
      return PlayerActionsNotifier(gameUseCase);
    });

/// Data class for player requests
class PlayerRequest {
  final String gameId;
  final String playerId;

  const PlayerRequest({required this.gameId, required this.playerId});
}

/// Notifier for player actions
class PlayerActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final GameUseCase _gameUseCase;

  PlayerActionsNotifier(this._gameUseCase) : super(const AsyncValue.data(null));

  /// Toggle player ready status
  Future<void> toggleReady(String gameId, String playerId) async {
    state = const AsyncValue.loading();
    try {
      await _gameUseCase.togglePlayerReady(gameId, playerId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Remove player from game
  Future<void> removePlayer(String gameId, String playerId) async {
    state = const AsyncValue.loading();
    try {
      await _gameUseCase.leaveGame(gameId, playerId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Transfer host privileges
  Future<void> transferHost(String gameId, String newHostId) async {
    state = const AsyncValue.loading();
    try {
      await _gameUseCase.transferHost(gameId, newHostId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
