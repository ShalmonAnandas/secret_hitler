// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
  id: json['id'] as String,
  hostId: json['hostId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  isPublic: json['isPublic'] as bool,
  accessCode: json['accessCode'] as String?,
  maxPlayers: (json['maxPlayers'] as num).toInt(),
  minPlayers: (json['minPlayers'] as num).toInt(),
  lobbyState: $enumDecode(_$LobbyStateEnumMap, json['lobbyState']),
  gamePhase: $enumDecode(_$GamePhaseEnumMap, json['gamePhase']),
  players:
      (json['players'] as List<dynamic>)
          .map((e) => PublicPlayerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
  liberalPoliciesEnacted:
      (json['liberalPoliciesEnacted'] as num?)?.toInt() ?? 0,
  fascistPoliciesEnacted:
      (json['fascistPoliciesEnacted'] as num?)?.toInt() ?? 0,
  failedElections: (json['failedElections'] as num?)?.toInt() ?? 0,
  currentPresidentId: json['currentPresidentId'] as String?,
  currentChancellorId: json['currentChancellorId'] as String?,
  presidentialCandidateId: json['presidentialCandidateId'] as String?,
  chancellorCandidateId: json['chancellorCandidateId'] as String?,
  pendingPresidentialPower: $enumDecodeNullable(
    _$PresidentialPowerEnumMap,
    json['pendingPresidentialPower'],
  ),
  gameResult: $enumDecodeNullable(_$GameResultEnumMap, json['gameResult']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  gameSettings: GameSettings.fromJson(
    json['gameSettings'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
  'id': instance.id,
  'hostId': instance.hostId,
  'name': instance.name,
  'description': instance.description,
  'isPublic': instance.isPublic,
  'accessCode': instance.accessCode,
  'maxPlayers': instance.maxPlayers,
  'minPlayers': instance.minPlayers,
  'lobbyState': _$LobbyStateEnumMap[instance.lobbyState]!,
  'gamePhase': _$GamePhaseEnumMap[instance.gamePhase]!,
  'players': instance.players,
  'liberalPoliciesEnacted': instance.liberalPoliciesEnacted,
  'fascistPoliciesEnacted': instance.fascistPoliciesEnacted,
  'failedElections': instance.failedElections,
  'currentPresidentId': instance.currentPresidentId,
  'currentChancellorId': instance.currentChancellorId,
  'presidentialCandidateId': instance.presidentialCandidateId,
  'chancellorCandidateId': instance.chancellorCandidateId,
  'pendingPresidentialPower':
      _$PresidentialPowerEnumMap[instance.pendingPresidentialPower],
  'gameResult': _$GameResultEnumMap[instance.gameResult],
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'gameSettings': instance.gameSettings,
};

const _$LobbyStateEnumMap = {
  LobbyState.waiting: 'waiting',
  LobbyState.ready: 'ready',
  LobbyState.starting: 'starting',
  LobbyState.inProgress: 'inProgress',
  LobbyState.finished: 'finished',
};

const _$GamePhaseEnumMap = {
  GamePhase.setup: 'setup',
  GamePhase.nomination: 'nomination',
  GamePhase.election: 'election',
  GamePhase.legislative: 'legislative',
  GamePhase.presidentialPower: 'presidentialPower',
  GamePhase.gameOver: 'gameOver',
};

const _$PresidentialPowerEnumMap = {
  PresidentialPower.policyPeek: 'policyPeek',
  PresidentialPower.investigateLoyalty: 'investigateLoyalty',
  PresidentialPower.specialElection: 'specialElection',
  PresidentialPower.execution: 'execution',
};

const _$GameResultEnumMap = {
  GameResult.liberalPolicyVictory: 'liberalPolicyVictory',
  GameResult.fascistPolicyVictory: 'fascistPolicyVictory',
  GameResult.hitlerElectedVictory: 'hitlerElectedVictory',
  GameResult.hitlerAssassinatedVictory: 'hitlerAssassinatedVictory',
};

PublicPlayerInfo _$PublicPlayerInfoFromJson(Map<String, dynamic> json) =>
    PublicPlayerInfo(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      status: $enumDecode(_$PlayerStatusEnumMap, json['status']),
      isReady: json['isReady'] as bool? ?? false,
      isHost: json['isHost'] as bool? ?? false,
      currentPosition: $enumDecodeNullable(
        _$GovernmentPositionEnumMap,
        json['currentPosition'],
      ),
      previousPosition: $enumDecodeNullable(
        _$GovernmentPositionEnumMap,
        json['previousPosition'],
      ),
      hasBeenInvestigated: json['hasBeenInvestigated'] as bool? ?? false,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$PublicPlayerInfoToJson(
  PublicPlayerInfo instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'status': _$PlayerStatusEnumMap[instance.status]!,
  'isReady': instance.isReady,
  'isHost': instance.isHost,
  'currentPosition': _$GovernmentPositionEnumMap[instance.currentPosition],
  'previousPosition': _$GovernmentPositionEnumMap[instance.previousPosition],
  'hasBeenInvestigated': instance.hasBeenInvestigated,
  'joinedAt': instance.joinedAt.toIso8601String(),
};

const _$PlayerStatusEnumMap = {
  PlayerStatus.alive: 'alive',
  PlayerStatus.executed: 'executed',
  PlayerStatus.disconnected: 'disconnected',
};

const _$GovernmentPositionEnumMap = {
  GovernmentPosition.president: 'president',
  GovernmentPosition.chancellor: 'chancellor',
};

GameSettings _$GameSettingsFromJson(Map<String, dynamic> json) => GameSettings(
  votingTimeout:
      json['votingTimeout'] == null
          ? const Duration(minutes: 2)
          : Duration(microseconds: (json['votingTimeout'] as num).toInt()),
  actionTimeout:
      json['actionTimeout'] == null
          ? const Duration(minutes: 3)
          : Duration(microseconds: (json['actionTimeout'] as num).toInt()),
  allowChat: json['allowChat'] as bool? ?? true,
  showRoleToFascists: json['showRoleToFascists'] as bool? ?? true,
  enableSounds: json['enableSounds'] as bool? ?? true,
  autoReadyEnabled: json['autoReadyEnabled'] as bool? ?? false,
);

Map<String, dynamic> _$GameSettingsToJson(GameSettings instance) =>
    <String, dynamic>{
      'votingTimeout': instance.votingTimeout.inMicroseconds,
      'actionTimeout': instance.actionTimeout.inMicroseconds,
      'allowChat': instance.allowChat,
      'showRoleToFascists': instance.showRoleToFascists,
      'enableSounds': instance.enableSounds,
      'autoReadyEnabled': instance.autoReadyEnabled,
    };
