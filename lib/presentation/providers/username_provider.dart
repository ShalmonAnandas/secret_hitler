import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/username_service.dart';

/// Provider for the UsernameService
final usernameServiceProvider = Provider<UsernameService>((ref) {
  return UsernameService();
});

/// Provider for username state
final usernameProvider =
    StateNotifierProvider<UsernameNotifier, AsyncValue<String?>>((ref) {
      return UsernameNotifier(ref.read(usernameServiceProvider));
    });

/// Notifier for managing username state
class UsernameNotifier extends StateNotifier<AsyncValue<String?>> {
  final UsernameService _usernameService;

  UsernameNotifier(this._usernameService) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _usernameService.initialize();
      state = AsyncValue.data(_usernameService.username);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Set username
  Future<void> setUsername(String username) async {
    try {
      state = const AsyncValue.loading();
      await _usernameService.setUsername(username);
      state = AsyncValue.data(username);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Clear username
  Future<void> clearUsername() async {
    try {
      await _usernameService.clearUsername();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Get user ID
  String get userId => _usernameService.userId;

  /// Check if username is set
  bool get hasUsername => _usernameService.hasUsername;
}
