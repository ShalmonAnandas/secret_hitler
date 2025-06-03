import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../core/constants/enums.dart';

part 'game_model.g.dart';

/// Represents the public game state
@JsonSerializable()
class GameModel extends Equatable {
  final String id;
  final String hostId;
  final String name;
  final String? description;
  final bool isPublic;
  final String? accessCode;
  final int maxPlayers;
  final int minPlayers;
  final LobbyState lobbyState;
  final GamePhase gamePhase;
  final List<PublicPlayerInfo> players;
  final int liberalPoliciesEnacted;
  final int fascistPoliciesEnacted;
  final int failedElections;
  final String? currentPresidentId;
  final String? currentChancellorId;
  final String? presidentialCandidateId;
  final String? chancellorCandidateId;
  final PresidentialPower? pendingPresidentialPower;
  final GameResult? gameResult;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GameSettings gameSettings;

  const GameModel({
    required this.id,
    required this.hostId,
    required this.name,
    this.description,
    required this.isPublic,
    this.accessCode,
    required this.maxPlayers,
    required this.minPlayers,
    required this.lobbyState,
    required this.gamePhase,
    required this.players,
    this.liberalPoliciesEnacted = 0,
    this.fascistPoliciesEnacted = 0,
    this.failedElections = 0,
    this.currentPresidentId,
    this.currentChancellorId,
    this.presidentialCandidateId,
    this.chancellorCandidateId,
    this.pendingPresidentialPower,
    this.gameResult,
    required this.createdAt,
    required this.updatedAt,
    required this.gameSettings,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameModelToJson(this);

  bool get isGameOver => gameResult != null;
  bool get canStartGame =>
      players.length >= minPlayers && lobbyState == LobbyState.ready;
  bool get hasVetoPower => fascistPoliciesEnacted >= 5;

  GameModel copyWith({
    String? id,
    String? hostId,
    String? name,
    String? description,
    bool? isPublic,
    String? accessCode,
    int? maxPlayers,
    int? minPlayers,
    LobbyState? lobbyState,
    GamePhase? gamePhase,
    List<PublicPlayerInfo>? players,
    int? liberalPoliciesEnacted,
    int? fascistPoliciesEnacted,
    int? failedElections,
    String? currentPresidentId,
    String? currentChancellorId,
    String? presidentialCandidateId,
    String? chancellorCandidateId,
    PresidentialPower? pendingPresidentialPower,
    GameResult? gameResult,
    DateTime? createdAt,
    DateTime? updatedAt,
    GameSettings? gameSettings,
  }) {
    return GameModel(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      name: name ?? this.name,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      accessCode: accessCode ?? this.accessCode,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      minPlayers: minPlayers ?? this.minPlayers,
      lobbyState: lobbyState ?? this.lobbyState,
      gamePhase: gamePhase ?? this.gamePhase,
      players: players ?? this.players,
      liberalPoliciesEnacted:
          liberalPoliciesEnacted ?? this.liberalPoliciesEnacted,
      fascistPoliciesEnacted:
          fascistPoliciesEnacted ?? this.fascistPoliciesEnacted,
      failedElections: failedElections ?? this.failedElections,
      currentPresidentId: currentPresidentId ?? this.currentPresidentId,
      currentChancellorId: currentChancellorId ?? this.currentChancellorId,
      presidentialCandidateId:
          presidentialCandidateId ?? this.presidentialCandidateId,
      chancellorCandidateId:
          chancellorCandidateId ?? this.chancellorCandidateId,
      pendingPresidentialPower:
          pendingPresidentialPower ?? this.pendingPresidentialPower,
      gameResult: gameResult ?? this.gameResult,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      gameSettings: gameSettings ?? this.gameSettings,
    );
  }

  @override
  List<Object?> get props => [
    id,
    hostId,
    name,
    description,
    isPublic,
    accessCode,
    maxPlayers,
    minPlayers,
    lobbyState,
    gamePhase,
    players,
    liberalPoliciesEnacted,
    fascistPoliciesEnacted,
    failedElections,
    currentPresidentId,
    currentChancellorId,
    presidentialCandidateId,
    chancellorCandidateId,
    pendingPresidentialPower,
    gameResult,
    createdAt,
    updatedAt,
    gameSettings,
  ];
}

/// Public information about a player visible to all players
@JsonSerializable()
class PublicPlayerInfo extends Equatable {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final PlayerStatus status;
  final bool isReady;
  final bool isHost;
  final GovernmentPosition? currentPosition;
  final GovernmentPosition? previousPosition;
  final bool hasBeenInvestigated;
  final DateTime joinedAt;

  const PublicPlayerInfo({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.status,
    this.isReady = false,
    this.isHost = false,
    this.currentPosition,
    this.previousPosition,
    this.hasBeenInvestigated = false,
    required this.joinedAt,
  });

  factory PublicPlayerInfo.fromJson(Map<String, dynamic> json) =>
      _$PublicPlayerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PublicPlayerInfoToJson(this);

  PublicPlayerInfo copyWith({
    String? userId,
    String? displayName,
    String? avatarUrl,
    PlayerStatus? status,
    bool? isReady,
    bool? isHost,
    GovernmentPosition? currentPosition,
    GovernmentPosition? previousPosition,
    bool? hasBeenInvestigated,
    DateTime? joinedAt,
  }) {
    return PublicPlayerInfo(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      isReady: isReady ?? this.isReady,
      isHost: isHost ?? this.isHost,
      currentPosition: currentPosition ?? this.currentPosition,
      previousPosition: previousPosition ?? this.previousPosition,
      hasBeenInvestigated: hasBeenInvestigated ?? this.hasBeenInvestigated,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    displayName,
    avatarUrl,
    status,
    isReady,
    isHost,
    currentPosition,
    previousPosition,
    hasBeenInvestigated,
    joinedAt,
  ];
}

/// Game configuration settings
@JsonSerializable()
class GameSettings extends Equatable {
  final Duration votingTimeout;
  final Duration actionTimeout;
  final bool allowChat;
  final bool showRoleToFascists;
  final bool enableSounds;
  final bool autoReadyEnabled;

  const GameSettings({
    this.votingTimeout = const Duration(minutes: 2),
    this.actionTimeout = const Duration(minutes: 3),
    this.allowChat = true,
    this.showRoleToFascists = true,
    this.enableSounds = true,
    this.autoReadyEnabled = false,
  });

  factory GameSettings.fromJson(Map<String, dynamic> json) =>
      _$GameSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$GameSettingsToJson(this);

  GameSettings copyWith({
    Duration? votingTimeout,
    Duration? actionTimeout,
    bool? allowChat,
    bool? showRoleToFascists,
    bool? enableSounds,
    bool? autoReadyEnabled,
  }) {
    return GameSettings(
      votingTimeout: votingTimeout ?? this.votingTimeout,
      actionTimeout: actionTimeout ?? this.actionTimeout,
      allowChat: allowChat ?? this.allowChat,
      showRoleToFascists: showRoleToFascists ?? this.showRoleToFascists,
      enableSounds: enableSounds ?? this.enableSounds,
      autoReadyEnabled: autoReadyEnabled ?? this.autoReadyEnabled,
    );
  }

  @override
  List<Object?> get props => [
    votingTimeout,
    actionTimeout,
    allowChat,
    showRoleToFascists,
    enableSounds,
    autoReadyEnabled,
  ];
}
