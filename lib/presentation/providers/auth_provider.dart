import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/presentation/providers/app_providers.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecase.dart';

/// Provider for authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((
  ref,
) {
  final authUseCase = ref.read(authUseCaseProvider);
  return AuthNotifier(authUseCase);
});

/// Authentication state notifier
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthUseCase _authUseCase;

  AuthNotifier(this._authUseCase) : super(const AsyncValue.loading()) {
    _checkAuthState();
  }

  /// Check current authentication state
  Future<void> _checkAuthState() async {
    try {
      final user = await _authUseCase.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authUseCase.signInWithEmail(email, password);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authUseCase.signUpWithEmail(
        email,
        password,
        displayName,
      );
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authUseCase.signOut();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update user profile
  Future<void> updateProfile(String displayName) async {
    try {
      await _authUseCase.updateProfile(displayName);
      // Refresh current user state
      await _checkAuthState();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
