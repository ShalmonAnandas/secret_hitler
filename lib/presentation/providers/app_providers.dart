import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/username_service.dart';
import '../../data/services/firestore_service.dart';
import '../../data/repositories/firebase_game_repository.dart';
import '../../data/repositories/firebase_player_repository.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/repositories/player_repository.dart';
import '../../domain/usecases/game_usecase.dart';

// Service providers
final usernameServiceProvider = Provider<UsernameService>((ref) {
  return UsernameService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Repository providers
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return FirebaseGameRepository(firestoreService);
});

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return FirebasePlayerRepository(firestoreService);
});

// Use case providers
final gameUseCaseProvider = Provider<GameUseCase>((ref) {
  final gameRepository = ref.read(gameRepositoryProvider);
  final playerRepository = ref.read(playerRepositoryProvider);
  return GameUseCase(gameRepository, playerRepository);
});
