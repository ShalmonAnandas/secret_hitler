import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../data/repositories/firebase_user_repository.dart';
import '../../data/repositories/firebase_game_repository.dart';
import '../../data/repositories/firebase_player_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/repositories/player_repository.dart';
import '../../domain/usecases/auth_usecase.dart';
import '../../domain/usecases/game_usecase.dart';

// Service providers
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Repository providers
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final authService = ref.read(authServiceProvider);
  final firestoreService = ref.read(firestoreServiceProvider);
  return FirebaseUserRepository(authService, firestoreService);
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return FirebaseGameRepository(firestoreService);
});

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return FirebasePlayerRepository(firestoreService);
});

// Use case providers
final authUseCaseProvider = Provider<AuthUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return AuthUseCase(userRepository);
});

final gameUseCaseProvider = Provider<GameUseCase>((ref) {
  final gameRepository = ref.read(gameRepositoryProvider);
  final playerRepository = ref.read(playerRepositoryProvider);
  return GameUseCase(gameRepository, playerRepository);
});
