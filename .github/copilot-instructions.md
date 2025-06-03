# GitHub Copilot Instructions for Secret Hitler Flutter App

## Project Overview

This is a Flutter-based mobile application for the board game "Secret Hitler" - a social deduction game where players are divided into Liberals and Fascists, with one player secretly being Hitler. The app provides real-time multiplayer gameplay using Firebase Firestore for synchronization.

## Architecture & Technical Stack

### Architecture Pattern
- **MVVM (Model-View-ViewModel)** pattern with clear separation of concerns
- **Repository Pattern** for data layer abstraction
- **Clean Architecture** principles with domain, data, and presentation layers

### Technology Stack
- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **Backend**: Firebase (Firestore, Auth, Cloud Functions)
- **Navigation**: GoRouter
- **UI Framework**: Material Design 3

### Project Structure
```
lib/
├── core/                    # Core utilities, constants, themes
├── data/                    # Data layer (models, repositories, services)
├── domain/                  # Domain layer (entities, use cases)
├── presentation/            # UI layer (pages, widgets, providers)
└── main.dart               # App entry point
```

## Game Mechanics Context

### Core Concepts
- **Players**: 5-10 players divided into Liberals (majority) and Fascists (minority + Hitler)
- **Objective**: 
  - Liberals: Enact 5 Liberal policies OR assassinate Hitler
  - Fascists: Enact 6 Fascist policies OR elect Hitler as Chancellor after 3 Fascist policies
- **Roles**: Liberal, Fascist, Hitler (distributed based on player count)
- **Game Flow**: Election Phase → Legislative Phase → Presidential Powers (if applicable)

### Key Game Elements
- **Policy Tracks**: Liberal (5 slots) and Fascist (6 slots)
- **Election Tracker**: Tracks failed elections (resets after successful election)
- **Presidential Powers**: Activated after enacting certain Fascist policies
- **Veto Power**: Available after 5 Fascist policies are enacted

### Presidential Powers (by player count)
- **Policy Peek**: President sees top 3 policies
- **Investigate Loyalty**: President sees another player's party membership
- **Special Election**: President chooses next Presidential candidate
- **Execution**: President eliminates a player

## Data Model & Security

### Firebase Collections Structure
```
users/                      # Public user profiles
games/                      # Public game state
  ├── players/             # Private player data (roles, policies)
  ├── policyDeck/          # Private deck state
  ├── discardPile/         # Public discard pile
  └── chat/                # Optional chat messages
```

### Security Considerations
- **Hidden Information**: Roles, policy hands, deck order must be secure
- **Server-side Logic**: Critical operations via Cloud Functions
- **Access Control**: Strict Firestore security rules
- **Anti-cheat**: Validate all actions server-side

## Development Guidelines

### Code Style & Conventions
- Follow Flutter/Dart style guide
- Use meaningful variable and function names
- Implement proper error handling
- Add comprehensive documentation
- Write unit tests for business logic

### State Management with Riverpod
- Use `StateProvider` for simple state
- Use `StateNotifierProvider` for complex state with logic
- Use `StreamProvider` for Firebase real-time data
- Implement proper disposal and error handling

### Firebase Integration
- Use Firestore `snapshots()` for real-time updates
- Implement offline persistence
- Use transactions for atomic operations
- Handle connection states properly

### UI/UX Principles
- **Clarity**: Clear visual feedback for all actions
- **Responsiveness**: Support various screen sizes
- **Accessibility**: Proper semantic labels and contrast
- **Privacy**: Secure handling of hidden information (roles, policies)

## Phase-wise Development Context

### Current Phase: Foundation Setup (Weeks 1-2)
Focus on establishing core architecture, dependencies, and basic project structure.

### Key Implementation Areas
1. **Authentication System** - Multi-provider auth with upgrade paths
2. **Lobby System** - Creation, discovery, joining, and management
3. **Core Game Logic** - Election and legislative phases
4. **Real-time Synchronization** - Firebase Firestore integration
5. **Security Implementation** - Rules and Cloud Functions
6. **UI/UX Polish** - Responsive design and animations

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

## Security Rules Context

Remember that Firestore security rules should:
- Prevent access to hidden game information
- Validate game state transitions
- Ensure only authorized players can modify game data
- Log suspicious activities

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
