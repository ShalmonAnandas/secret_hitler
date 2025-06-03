/// Base exception class for the Secret Hitler app
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException: $message';
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'AuthException: $message';
}

/// Game logic-related exceptions
class GameException extends AppException {
  const GameException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'GameException: $message';
}

/// Network and connectivity exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'NetworkException: $message';
}

/// Firebase/Firestore related exceptions
class FirestoreException extends AppException {
  const FirestoreException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'FirestoreException: $message';
}

/// Validation exceptions for user input
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'ValidationException: $message';
}

/// Specific game rule violation exceptions
class GameRuleViolationException extends GameException {
  const GameRuleViolationException(
    super.message, {
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'GameRuleViolationException: $message';
}

/// Player action exceptions
class PlayerActionException extends GameException {
  const PlayerActionException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'PlayerActionException: $message';
}

/// Lobby-related exceptions
class LobbyException extends AppException {
  const LobbyException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'LobbyException: $message';
}

/// Common exception messages
class ExceptionMessages {
  // Authentication
  static const String userNotAuthenticated = 'User is not authenticated';
  static const String invalidCredentials = 'Invalid email or password';
  static const String userNotFound = 'User account not found';
  static const String emailAlreadyInUse = 'Email address is already in use';
  static const String weakPassword = 'Password is too weak';
  static const String userDisabled = 'User account has been disabled';

  // Game Logic
  static const String gameNotFound = 'Game not found';
  static const String gameAlreadyStarted = 'Game has already started';
  static const String gameAlreadyFinished = 'Game has already finished';
  static const String notPlayerTurn = 'It is not your turn';
  static const String invalidGameAction = 'Invalid game action';
  static const String insufficientPlayers =
      'Not enough players to start the game';
  static const String tooManyPlayers = 'Too many players in the game';
  static const String playerNotInGame = 'Player is not in this game';
  static const String playerAlreadyInGame = 'Player is already in this game';
  static const String notGameHost =
      'Only the game host can perform this action';
  static const String invalidPlayerAction =
      'Invalid player action for current game state';
  static const String alreadyVoted = 'Player has already voted';
  static const String votingNotActive = 'Voting is not currently active';
  static const String invalidNomination =
      'Invalid nomination for current game state';
  static const String cannotNominateSelf = 'Cannot nominate yourself';
  static const String playerNotEligible =
      'Player is not eligible for this position';
  static const String invalidPolicySelection = 'Invalid policy selection';
  static const String presidentialPowerNotAvailable =
      'Presidential power is not available';
  static const String invalidPresidentialPowerTarget =
      'Invalid target for presidential power';

  // Lobby
  static const String lobbyFull = 'Lobby is full';
  static const String lobbyNotFound = 'Lobby not found';
  static const String invalidAccessCode = 'Invalid access code';
  static const String lobbyAlreadyStarted = 'Lobby game has already started';
  static const String notInLobby = 'Player is not in this lobby';

  // Network
  static const String networkUnavailable = 'Network connection unavailable';
  static const String requestTimeout = 'Request timed out';
  static const String serverError = 'Server error occurred';

  // Validation
  static const String invalidInput = 'Invalid input provided';
  static const String requiredFieldMissing = 'Required field is missing';
  static const String invalidEmailFormat = 'Invalid email format';
  static const String invalidDisplayName = 'Invalid display name';
  static const String displayNameTooShort = 'Display name is too short';
  static const String displayNameTooLong = 'Display name is too long';
  static const String gameNameTooShort = 'Game name is too short';
  static const String gameNameTooLong = 'Game name is too long';
}
