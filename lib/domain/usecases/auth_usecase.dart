import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for user authentication operations
class AuthUseCase {
  final UserRepository _userRepository;

  AuthUseCase(this._userRepository);

  /// Sign in with email and password
  Future<User> signInWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty');
    }

    return await _userRepository.signInWithEmail(email, password);
  }

  /// Sign up with email and password
  Future<User> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
      throw ArgumentError('Email, password, and display name cannot be empty');
    }

    return await _userRepository.signUpWithEmail(email, password, displayName);
  }

  /// Sign in with Google
  Future<User> signInWithGoogle() async {
    return await _userRepository.signInWithGoogle();
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _userRepository.signOut();
  }

  /// Get current user
  Future<User?> getCurrentUser() async {
    return await _userRepository.getCurrentUser();
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _userRepository.isAuthenticated;

  /// Update user profile
  Future<void> updateProfile(String displayName) async {
    if (displayName.isEmpty) {
      throw ArgumentError('Display name cannot be empty');
    }
    await _userRepository.updateProfile(displayName);
  }

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _userRepository.authStateChanges;
}
