import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

/// Firebase implementation of UserRepository
class FirebaseUserRepository implements UserRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  const FirebaseUserRepository(this._authService, this._firestoreService);

  /// Converts Firebase user to domain User entity
  Future<User?> _firebaseUserToDomainUser(
    firebase_auth.User? firebaseUser,
  ) async {
    if (firebaseUser == null) {
      return null;
    }

    // Check if user exists in Firestore
    final userDoc = await _firestoreService.getDocument(
      collection: _firestoreService.usersCollection,
      docId: firebaseUser.uid,
    );

    if (userDoc.exists) {
      // User exists in Firestore, use this data
      final userData = userDoc.data() as Map<String, dynamic>;

      return User(
        id: firebaseUser.uid,
        displayName: userData['displayName'] as String,
        email: userData['email'] as String,
        avatarUrl: userData['avatarUrl'] as String?,
        createdAt: (userData['createdAt'] as Timestamp).toDate(),
        lastSeen: (userData['lastSeen'] as Timestamp).toDate(),
        stats: _convertUserStats(
          userData['stats'] as Map<String, dynamic>? ?? {},
        ),
        preferences: _convertUserPreferences(
          userData['preferences'] as Map<String, dynamic>? ?? {},
        ),
      );
    } else {
      // User doesn't exist in Firestore yet, create with default values
      final now = DateTime.now();

      final user = User(
        id: firebaseUser.uid,
        displayName: firebaseUser.displayName ?? 'Anonymous',
        email: firebaseUser.email ?? '',
        avatarUrl: firebaseUser.photoURL,
        createdAt: now,
        lastSeen: now,
        stats: const UserStatistics(),
        preferences: const UserPreferencesEntity(),
      );

      // Save the new user to Firestore
      await createOrUpdateUser(user);

      return user;
    }
  }

  /// Convert Firestore user stats to domain UserStatistics
  UserStatistics _convertUserStats(Map<String, dynamic> data) {
    return UserStatistics(
      gamesPlayed: data['gamesPlayed'] as int? ?? 0,
      gamesWon: data['gamesWon'] as int? ?? 0,
      liberalWins: data['liberalWins'] as int? ?? 0,
      fascistWins: data['fascistWins'] as int? ?? 0,
      hitlerWins: data['hitlerWins'] as int? ?? 0,
      timesAsPresident: data['timesAsPresident'] as int? ?? 0,
      timesAsChancellor: data['timesAsChancellor'] as int? ?? 0,
      timesExecuted: data['timesExecuted'] as int? ?? 0,
    );
  }

  /// Convert Firestore user preferences to domain UserPreferencesEntity
  UserPreferencesEntity _convertUserPreferences(Map<String, dynamic> data) {
    return UserPreferencesEntity(
      soundEnabled: data['soundEnabled'] as bool? ?? true,
      vibrationEnabled: data['vibrationEnabled'] as bool? ?? true,
      autoReadyEnabled: data['autoReadyEnabled'] as bool? ?? false,
      preferredLanguage: data['preferredLanguage'] as String? ?? 'en',
      darkModeEnabled: data['darkModeEnabled'] as bool? ?? false,
    );
  }

  /// Convert domain User to Firestore document data
  Map<String, dynamic> _userToFirestore(User user) {
    return {
      'id': user.id,
      'displayName': user.displayName,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'createdAt': Timestamp.fromDate(user.createdAt),
      'lastSeen': Timestamp.fromDate(user.lastSeen),
      'stats': {
        'gamesPlayed': user.stats.gamesPlayed,
        'gamesWon': user.stats.gamesWon,
        'liberalWins': user.stats.liberalWins,
        'fascistWins': user.stats.fascistWins,
        'hitlerWins': user.stats.hitlerWins,
        'timesAsPresident': user.stats.timesAsPresident,
        'timesAsChancellor': user.stats.timesAsChancellor,
        'timesExecuted': user.stats.timesExecuted,
      },
      'preferences': {
        'soundEnabled': user.preferences.soundEnabled,
        'vibrationEnabled': user.preferences.vibrationEnabled,
        'autoReadyEnabled': user.preferences.autoReadyEnabled,
        'preferredLanguage': user.preferences.preferredLanguage,
        'darkModeEnabled': user.preferences.darkModeEnabled,
      },
    };
  }

  @override
  bool get isAuthenticated => _authService.isAuthenticated;

  @override
  Stream<User?> get authStateChanges =>
      _authService.authStateChanges.asyncMap(_firebaseUserToDomainUser);

  @override
  Future<User?> getCurrentUser() async {
    final firebaseUser = _authService.currentFirebaseUser;
    return await _firebaseUserToDomainUser(firebaseUser);
  }

  @override
  Future<User?> getUserById(String userId) async {
    final userDoc = await _firestoreService.getDocument(
      collection: _firestoreService.usersCollection,
      docId: userId,
    );

    if (!userDoc.exists) {
      return null;
    }

    final userData = userDoc.data() as Map<String, dynamic>;

    return User(
      id: userId,
      displayName: userData['displayName'] as String,
      email: userData['email'] as String,
      avatarUrl: userData['avatarUrl'] as String?,
      createdAt: (userData['createdAt'] as Timestamp).toDate(),
      lastSeen: (userData['lastSeen'] as Timestamp).toDate(),
      stats: _convertUserStats(
        userData['stats'] as Map<String, dynamic>? ?? {},
      ),
      preferences: _convertUserPreferences(
        userData['preferences'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  Future<void> createOrUpdateUser(User user) async {
    await _firestoreService.setDocument(
      collection: _firestoreService.usersCollection,
      docId: user.id,
      data: _userToFirestore(user),
    );
  }

  @override
  Future<void> updateUser(User user) async {
    await _firestoreService.updateDocument(
      collection: _firestoreService.usersCollection,
      docId: user.id,
      data: {
        ..._userToFirestore(user),
        'lastSeen': Timestamp.fromDate(DateTime.now()),
      },
    );
  }

  @override
  Future<void> updateProfile(String displayName) async {
    // Update Firebase Auth display name
    await _authService.updateDisplayName(displayName);

    // Update user document
    final user = await getCurrentUser();
    if (user != null) {
      final updatedUser = user.copyWith(
        displayName: displayName,
        lastSeen: DateTime.now(),
      );
      await updateUser(updatedUser);
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    // If this is the current user, delete Firebase Auth account
    if (_authService.currentFirebaseUser?.uid == userId) {
      await _authService.deleteAccount();
    }

    // Delete user document from Firestore
    await _firestoreService.deleteDocument(
      collection: _firestoreService.usersCollection,
      docId: userId,
    );
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    final credential = await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = await _firebaseUserToDomainUser(credential.user);
    if (user == null) {
      throw Exception('Failed to sign in');
    }

    // Update last seen
    final updatedUser = user.copyWith(lastSeen: DateTime.now());
    await updateUser(updatedUser);

    return updatedUser;
  }

  @override
  Future<User> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    final credential = await _authService.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception('Failed to create user');
    }

    // Set display name in Firebase Auth
    await _authService.updateDisplayName(displayName);

    // Send email verification
    await _authService.sendEmailVerification();

    // Create user in Firestore
    final now = DateTime.now();
    final user = User(
      id: firebaseUser.uid,
      displayName: displayName,
      email: email,
      avatarUrl: null,
      createdAt: now,
      lastSeen: now,
      stats: const UserStatistics(),
      preferences: const UserPreferencesEntity(),
    );

    await createOrUpdateUser(user);

    return user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final credential = await _authService.signInWithGoogle();

    final user = await _firebaseUserToDomainUser(credential.user);
    if (user == null) {
      throw Exception('Failed to sign in with Google');
    }

    // Update last seen
    final updatedUser = user.copyWith(lastSeen: DateTime.now());
    await updateUser(updatedUser);

    return updatedUser;
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }
}
