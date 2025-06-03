import 'package:equatable/equatable.dart';
import '../../core/constants/enums.dart';

/// Domain entity representing a game
class Game extends Equatable {
  final String id;
  final String name;
  final String hostId;
  final List<String> playerIds;
  final GamePhase phase;
  final GameStatus status;
  final int maxPlayers;
  final int minPlayers;
  final bool isPrivate;
  final String? accessCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Game state properties
  final int currentPresidentIndex;
  final int? currentChancellorIndex;
  final int? previousPresidentIndex;
  final int? previousChancellorIndex;
  final int liberalPoliciesEnacted;
  final int fascistPoliciesEnacted;
  final int electionTracker;
  final bool vetoUnlocked;
  final List<String> executedPlayerIds;
  final Team? winningTeam;
  final String? winCondition;

  // Current action state
  final String? currentActionPlayerId;
  final GameAction? currentAction;
  final Map<String, dynamic>? actionData;

  const Game({
    required this.id,
    required this.name,
    required this.hostId,
    required this.playerIds,
    required this.phase,
    required this.status,
    required this.maxPlayers,
    required this.minPlayers,
    required this.isPrivate,
    this.accessCode,
    required this.createdAt,
    required this.updatedAt,
    this.currentPresidentIndex = 0,
    this.currentChancellorIndex,
    this.previousPresidentIndex,
    this.previousChancellorIndex,
    this.liberalPoliciesEnacted = 0,
    this.fascistPoliciesEnacted = 0,
    this.electionTracker = 0,
    this.vetoUnlocked = false,
    this.executedPlayerIds = const [],
    this.winningTeam,
    this.winCondition,
    this.currentActionPlayerId,
    this.currentAction,
    this.actionData,
  });

  Game copyWith({
    String? id,
    String? name,
    String? hostId,
    List<String>? playerIds,
    GamePhase? phase,
    GameStatus? status,
    int? maxPlayers,
    int? minPlayers,
    bool? isPrivate,
    String? accessCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? currentPresidentIndex,
    int? currentChancellorIndex,
    int? previousPresidentIndex,
    int? previousChancellorIndex,
    int? liberalPoliciesEnacted,
    int? fascistPoliciesEnacted,
    int? electionTracker,
    bool? vetoUnlocked,
    List<String>? executedPlayerIds,
    Team? winningTeam,
    String? winCondition,
    String? currentActionPlayerId,
    GameAction? currentAction,
    Map<String, dynamic>? actionData,
  }) {
    return Game(
      id: id ?? this.id,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      playerIds: playerIds ?? this.playerIds,
      phase: phase ?? this.phase,
      status: status ?? this.status,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      minPlayers: minPlayers ?? this.minPlayers,
      isPrivate: isPrivate ?? this.isPrivate,
      accessCode: accessCode ?? this.accessCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentPresidentIndex:
          currentPresidentIndex ?? this.currentPresidentIndex,
      currentChancellorIndex:
          currentChancellorIndex ?? this.currentChancellorIndex,
      previousPresidentIndex:
          previousPresidentIndex ?? this.previousPresidentIndex,
      previousChancellorIndex:
          previousChancellorIndex ?? this.previousChancellorIndex,
      liberalPoliciesEnacted:
          liberalPoliciesEnacted ?? this.liberalPoliciesEnacted,
      fascistPoliciesEnacted:
          fascistPoliciesEnacted ?? this.fascistPoliciesEnacted,
      electionTracker: electionTracker ?? this.electionTracker,
      vetoUnlocked: vetoUnlocked ?? this.vetoUnlocked,
      executedPlayerIds: executedPlayerIds ?? this.executedPlayerIds,
      winningTeam: winningTeam ?? this.winningTeam,
      winCondition: winCondition ?? this.winCondition,
      currentActionPlayerId:
          currentActionPlayerId ?? this.currentActionPlayerId,
      currentAction: currentAction ?? this.currentAction,
      actionData: actionData ?? this.actionData,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    hostId,
    playerIds,
    phase,
    status,
    maxPlayers,
    minPlayers,
    isPrivate,
    accessCode,
    createdAt,
    updatedAt,
    currentPresidentIndex,
    currentChancellorIndex,
    previousPresidentIndex,
    previousChancellorIndex,
    liberalPoliciesEnacted,
    fascistPoliciesEnacted,
    electionTracker,
    vetoUnlocked,
    executedPlayerIds,
    winningTeam,
    winCondition,
    currentActionPlayerId,
    currentAction,
    actionData,
  ];

  /// Check if the game is full
  bool get isFull => playerIds.length >= maxPlayers;

  /// Check if the game has minimum players to start
  bool get canStart => playerIds.length >= minPlayers;

  /// Check if the game is in progress
  bool get isInProgress => status == GameStatus.inProgress;

  /// Check if the game is finished
  bool get isFinished => status == GameStatus.finished;

  /// Get the current president player ID
  String? get currentPresidentId {
    if (playerIds.isEmpty || currentPresidentIndex >= playerIds.length) {
      return null;
    }
    return playerIds[currentPresidentIndex];
  }

  /// Get the current chancellor player ID
  String? get currentChancellorId {
    if (playerIds.isEmpty ||
        currentChancellorIndex == null ||
        currentChancellorIndex! >= playerIds.length) {
      return null;
    }
    return playerIds[currentChancellorIndex!];
  }

  /// Check if veto power is available
  bool get canVeto => vetoUnlocked && fascistPoliciesEnacted >= 5;

  /// Check if the game is over due to policy track completion
  bool get isGameOverByPolicies =>
      liberalPoliciesEnacted >= 5 || fascistPoliciesEnacted >= 6;

  /// Get the number of living (non-executed) players
  int get livingPlayerCount => playerIds.length - executedPlayerIds.length;
}
