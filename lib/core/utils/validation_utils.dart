import 'package:intl/intl.dart';

/// Utility functions for validation
class ValidationUtils {
  /// Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Display name validation regex (letters, numbers, spaces, some special chars)
  static final RegExp _displayNameRegex = RegExp(r'^[a-zA-Z0-9\s\-_.]+$');

  /// Game name validation regex
  static final RegExp _gameNameRegex = RegExp(r'^[a-zA-Z0-9\s\-_.!?]+$');

  /// Access code validation regex (alphanumeric uppercase)
  static final RegExp _accessCodeRegex = RegExp(r'^[A-Z0-9]+$');

  /// Validates email format
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validates password strength
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Validates display name
  static String? validateDisplayName(String? displayName) {
    if (displayName == null || displayName.trim().isEmpty) {
      return 'Display name is required';
    }

    final trimmed = displayName.trim();

    if (trimmed.length < 2) {
      return 'Display name must be at least 2 characters';
    }

    if (trimmed.length > 20) {
      return 'Display name must be 20 characters or less';
    }

    if (!_displayNameRegex.hasMatch(trimmed)) {
      return 'Display name contains invalid characters';
    }

    return null;
  }

  /// Validates email address
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }

    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validates password confirmation
  static String? validatePasswordConfirmation(
    String? password,
    String? confirmation,
  ) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmation) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates game name
  static String? validateGameName(String? gameName) {
    if (gameName == null || gameName.trim().isEmpty) {
      return 'Game name is required';
    }

    final trimmed = gameName.trim();

    if (trimmed.length < 3) {
      return 'Game name must be at least 3 characters';
    }

    if (trimmed.length > 50) {
      return 'Game name must be 50 characters or less';
    }

    if (!_gameNameRegex.hasMatch(trimmed)) {
      return 'Game name contains invalid characters';
    }

    return null;
  }

  /// Validates game description
  static String? validateGameDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return null; // Description is optional
    }

    final trimmed = description.trim();

    if (trimmed.length > 200) {
      return 'Description must be 200 characters or less';
    }

    return null;
  }

  /// Validates access code
  static String? validateAccessCode(String? accessCode) {
    if (accessCode == null || accessCode.trim().isEmpty) {
      return 'Access code is required';
    }

    final trimmed = accessCode.trim().toUpperCase();

    if (trimmed.length != 6) {
      return 'Access code must be 6 characters';
    }

    if (!_accessCodeRegex.hasMatch(trimmed)) {
      return 'Access code must contain only letters and numbers';
    }

    return null;
  }

  /// Validates player count
  static String? validatePlayerCount(
    int? playerCount,
    int minPlayers,
    int maxPlayers,
  ) {
    if (playerCount == null) {
      return 'Player count is required';
    }

    if (playerCount < minPlayers) {
      return 'Minimum $minPlayers players required';
    }

    if (playerCount > maxPlayers) {
      return 'Maximum $maxPlayers players allowed';
    }

    return null;
  }

  /// Sanitizes user input by trimming whitespace and removing dangerous characters
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'[<>"&]'), '');
  }

  /// Checks if a string contains only alphanumeric characters
  static bool isAlphanumeric(String text) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text);
  }

  /// Formats a DateTime to a user-friendly string
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, y').format(dateTime);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Formats a duration to a user-friendly string
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
