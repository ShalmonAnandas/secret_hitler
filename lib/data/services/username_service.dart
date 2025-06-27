import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Service for managing username and generating unique user IDs
class UsernameService {
  static const String _usernameKey = 'username';
  static const String _userIdKey = 'user_id';

  late final SharedPreferences _prefs;
  final Uuid _uuid = const Uuid();

  /// Initialize the service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get current username
  String? get username => _prefs.getString(_usernameKey);

  /// Get current user ID
  String get userId {
    String? existingId = _prefs.getString(_userIdKey);
    if (existingId != null) {
      return existingId;
    }

    // Generate new user ID if none exists
    final newId = _uuid.v4();
    _prefs.setString(_userIdKey, newId);
    return newId;
  }

  /// Check if username is set
  bool get hasUsername => username != null && username!.isNotEmpty;

  /// Set username
  Future<void> setUsername(String username) async {
    await _prefs.setString(_usernameKey, username);
  }

  /// Clear username (for testing or logout)
  Future<void> clearUsername() async {
    await _prefs.remove(_usernameKey);
  }

  /// Clear all user data
  Future<void> clearAll() async {
    await _prefs.remove(_usernameKey);
    await _prefs.remove(_userIdKey);
  }
}
