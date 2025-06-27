# GitHub Copilot Instructions for Secret Hitler Flutter App

## Project Overview

Flutter-based mobile application for the Secret Hitler board game - a social deduction game with real-time multiplayer gameplay using Firebase Firestore. Uses simplified username-only authentication (no Firebase Auth).

## Core Commands

### Build & Development
- `flutter pub get` - Install dependencies
- `flutter run` - Run app in debug mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `dart run build_runner build --delete-conflicting-outputs` - Generate code

### Testing & Analysis
- `flutter test` - Run all tests
- `flutter test test/path/to/test.dart` - Run specific test
- `flutter analyze` - Static analysis
- `flutter doctor` - Check Flutter environment

### Maintenance
- `flutter clean` - Clean build cache
- `flutter pub upgrade` - Update dependencies
- `firebase deploy` - Deploy Firestore rules/functions

## Architecture

### Tech Stack
- **Frontend**: Flutter/Dart with Material Design 3
- **State Management**: Riverpod (StateNotifierProvider, StreamProvider)
- **Backend**: Firebase Firestore (no Authentication)
- **Navigation**: GoRouter
- **Local Storage**: SharedPreferences for username
- **Real-time**: Firestore snapshots

### Project Structure
```
lib/
├── core/               # Constants, themes, utils, exceptions
├── data/               # Models, repositories, services
│   ├── models/         # JSON serializable data models
│   ├── repositories/   # Firebase repository implementations
│   └── services/       # Firestore & username services
├── domain/             # Entities, repository interfaces, use cases
├── presentation/       # UI layer
│   ├── pages/          # Screen widgets
│   ├── providers/      # Riverpod state providers
│   ├── router/         # GoRouter configuration
│   └── widgets/        # Reusable UI components
└── main.dart
```

### Authentication Model
- **Username-only**: No Firebase Auth, uses SharedPreferences
- **User ID**: Generated UUID stored locally
- **Flow**: Username Entry → Home → Game Creation/Joining

## Firebase Data Model

### Collections
- `games/` - Game documents with public state
  - `players/` - Subcollection with player data
  - Game codes, status, settings, policy tracks
- **Security**: Open read/write (no authentication required)

### Key Services
- `FirestoreService` - Generic Firestore operations
- `UsernameService` - Local username management with SharedPreferences
- Repository pattern for games and players

## Game Mechanics

### Core Rules
- **Players**: 5-10 divided into Liberals (majority) vs Fascists + Hitler
- **Victory**: Liberals win by 5 policies OR killing Hitler; Fascists win by 6 policies OR electing Hitler Chancellor after 3 Fascist policies
- **Phases**: Election → Legislative → Presidential Powers

### Key Features
- Real-time lobby with player management
- Game creation with player limits (5-10)
- Join games via 6-character codes
- Host controls (kick players, transfer host, start game)

## Development Guidelines

### State Management with Riverpod
- `usernameProvider` - StateNotifierProvider for username state
- `gameStreamProvider` - StreamProvider for real-time game data
- `playersStreamProvider` - StreamProvider for player updates
- Use `ref.read()` for one-time reads, `ref.watch()` for reactive updates

### Code Style
- Follow Flutter/Dart style guide
- Use meaningful names, proper error handling
- Implement loading/error states for all async operations
- Create reusable widgets in `presentation/widgets/`

### Navigation with GoRouter
- Routes: `/` (splash) → `/username` → `/home` → `/lobby/:gameId`
- Use `context.go()` for navigation, `context.push()` for modals
- Handle deep linking for game invitations

### Firebase Integration
- Use `snapshots()` for real-time updates
- Handle offline scenarios gracefully
- Use transactions for atomic operations
- Generate unique IDs with `FirestoreService.generateId()`

## Phase-wise Development Context

### Current Phase: Foundation Setup (Weeks 1-2)
Focus on establishing core architecture, dependencies, and basic project structure.

### Key Implementation Areas
1. **Username System** - Local storage with SharedPreferences
2. **Lobby System** - Real-time game creation and joining
3. **Player Management** - Host controls, ready states, kicking
4. **Game Flow** - Election and legislative phases
5. **Real-time Sync** - Firebase Firestore integration
6. **UI Polish** - Material Design 3, responsive layouts

## Specific Coding Guidelines

### For Game Logic
- Always validate game state before actions
- Use enums for game phases, roles, and policy types
- Implement immutable data structures where possible
- Handle all edge cases (disconnections, invalid states)

### For UI Components
- Create reusable widgets for common game elements
- Implement proper loading and error states
- Use consistent spacing and typography
- Support both light and dark themes

### For Firebase Operations
- Always handle errors gracefully
- Use proper typing for Firestore documents
- Implement retry logic for failed operations
- Cache data appropriately for offline use

### For Security
- Never trust client-side data for critical operations
- Validate all inputs server-side
- Use proper authentication checks
- Implement audit logging for sensitive actions

## Testing Strategy

### Unit Tests
- Game logic validation
- Model serialization/deserialization
- Utility functions
- State management providers

### Integration Tests
- Firebase operations
- Authentication flows
- Real-time data synchronization
- End-to-end game scenarios

### Widget Tests
- UI component behavior
- User interaction flows
- Responsive design
- Accessibility features

## Performance Considerations

- Minimize Firestore reads through efficient queries
- Use pagination for large datasets
- Implement proper caching strategies
- Optimize widget rebuilds with Riverpod
- Handle memory management for real-time listeners

## Accessibility & Internationalization

- Support screen readers and TalkBack
- Provide proper semantic labels
- Ensure sufficient color contrast
- Support multiple languages (future enhancement)
- Handle RTL text direction

## Common Patterns & Best Practices

### Error Handling
```dart
try {
  await gameRepository.performAction();
} on FirebaseException catch (e) {
  // Handle Firebase-specific errors
} on GameException catch (e) {
  // Handle game-specific errors
} catch (e) {
  // Handle unexpected errors
}
```

### State Management
```dart
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(ref.read(gameRepositoryProvider));
});
```

### Real-time Data
```dart
final gameStreamProvider = StreamProvider.family<Game, String>((ref, gameId) {
  return ref.read(gameRepositoryProvider).watchGame(gameId);
});
```

## Deployment & CI/CD

- Use Firebase App Distribution for beta testing
- Implement automated testing in CI pipeline
- Use environment-specific Firebase projects
- Monitor app performance and crashes post-deployment

---

When providing code suggestions, always consider:
1. Game rule compliance and edge cases
2. Security implications of the implementation
3. Real-time synchronization requirements
4. User experience and accessibility
5. Performance impact on mobile devices
6. Proper error handling and recovery
7. Testing implications and coverage

This project prioritizes security, user experience, and maintainability while delivering a faithful digital adaptation of the Secret Hitler board game.
