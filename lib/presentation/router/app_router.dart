import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/splash_page.dart';
import '../pages/username_entry_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/game/lobby_page.dart';
import '../pages/game/create_game_page.dart';

/// Application routes
class AppRoutes {
  static const String splash = '/';
  static const String usernameEntry = '/username';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String createGame = '/create-game';
  static const String lobby = '/lobby';
  static const String game = '/game';
}

/// Router configuration
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.usernameEntry,
      name: 'usernameEntry',
      builder: (context, state) => const UsernameEntryPage(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.createGame,
      name: 'createGame',
      builder: (context, state) => const CreateGamePage(),
    ),
    GoRoute(
      path: '${AppRoutes.lobby}/:gameId',
      name: 'lobby',
      builder: (context, state) {
        final gameId = state.pathParameters['gameId']!;
        return LobbyPage(gameId: gameId);
      },
    ),
    GoRoute(
      path: '${AppRoutes.game}/:gameId',
      name: 'game',
      builder: (context, state) {
        final gameId = state.pathParameters['gameId']!;
        // TODO: Create game page
        return Scaffold(
          appBar: AppBar(title: const Text('Game')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Game Page Coming Soon!'),
                Text('Game ID: $gameId'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ],
  redirect: (context, state) {
    // TODO: Add authentication checks here
    // For now, allow all routes
    return null;
  },
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Page Not Found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
);

/// Extension for easier navigation
extension AppNavigation on BuildContext {
  /// Navigate to splash page
  void goToSplash() => go(AppRoutes.splash);

  /// Navigate to home page
  void goToHome() => go(AppRoutes.home);

  /// Navigate to username entry page
  void goToUsernameEntry() => go(AppRoutes.usernameEntry);

  /// Navigate to lobby page
  void goToLobby(String gameId) => go('${AppRoutes.lobby}/$gameId');

  /// Navigate to game page
  void goToGame(String gameId) => go('${AppRoutes.game}/$gameId');

  /// Push to lobby page
  void pushToLobby(String gameId) => push('${AppRoutes.lobby}/$gameId');

  /// Push to game page
  void pushToGame(String gameId) => push('${AppRoutes.game}/$gameId');
}
