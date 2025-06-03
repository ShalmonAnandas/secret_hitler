import '../entities/user.dart';

/// Repository interface for user-related operations
abstract class UserRepository {
  /// Get current authenticated user
  Future<User?> getCurrentUser();

  /// Get user by ID
  Future<User?> getUserById(String userId);

  /// Create or update user profile
  Future<void> createOrUpdateUser(User user);

  /// Update user profile
  Future<void> updateUser(User user);

  /// Update user profile with display name
  Future<void> updateProfile(String displayName);

  /// Delete user account
  Future<void> deleteUser(String userId);

  /// Sign in with email and password
  Future<User> signInWithEmail(String email, String password);

  /// Sign up with email and password
  Future<User> signUpWithEmail(
    String email,
    String password,
    String displayName,
  );

  /// Sign in with Google
  Future<User> signInWithGoogle();

  /// Sign out current user
  Future<void> signOut();

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;
}
