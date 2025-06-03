// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => PlayerModel(
  userId: json['userId'] as String,
  gameId: json['gameId'] as String,
  role: $enumDecode(_$GameRoleEnumMap, json['role']),
  handPolicies:
      (json['handPolicies'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$PolicyTypeEnumMap, e))
          .toList() ??
      const [],
  currentVote: $enumDecodeNullable(_$VoteEnumMap, json['currentVote']),
  knownFascists:
      (json['knownFascists'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  hasVoted: json['hasVoted'] as bool? ?? false,
  hasActed: json['hasActed'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'gameId': instance.gameId,
      'role': _$GameRoleEnumMap[instance.role]!,
      'handPolicies':
          instance.handPolicies.map((e) => _$PolicyTypeEnumMap[e]!).toList(),
      'currentVote': _$VoteEnumMap[instance.currentVote],
      'knownFascists': instance.knownFascists,
      'hasVoted': instance.hasVoted,
      'hasActed': instance.hasActed,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$GameRoleEnumMap = {
  GameRole.liberal: 'liberal',
  GameRole.fascist: 'fascist',
  GameRole.hitler: 'hitler',
};

const _$PolicyTypeEnumMap = {
  PolicyType.liberal: 'liberal',
  PolicyType.fascist: 'fascist',
};

const _$VoteEnumMap = {Vote.ja: 'ja', Vote.nein: 'nein'};

PolicyCard _$PolicyCardFromJson(Map<String, dynamic> json) => PolicyCard(
  id: json['id'] as String,
  type: $enumDecode(_$PolicyTypeEnumMap, json['type']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PolicyCardToJson(PolicyCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PolicyTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

PolicyDeck _$PolicyDeckFromJson(Map<String, dynamic> json) => PolicyDeck(
  gameId: json['gameId'] as String,
  drawPile:
      (json['drawPile'] as List<dynamic>)
          .map((e) => PolicyCard.fromJson(e as Map<String, dynamic>))
          .toList(),
  discardPile:
      (json['discardPile'] as List<dynamic>)
          .map((e) => PolicyCard.fromJson(e as Map<String, dynamic>))
          .toList(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PolicyDeckToJson(PolicyDeck instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'drawPile': instance.drawPile,
      'discardPile': instance.discardPile,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
  id: json['id'] as String,
  gameId: json['gameId'] as String,
  senderId: json['senderId'] as String,
  senderDisplayName: json['senderDisplayName'] as String,
  message: json['message'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  isSystemMessage: json['isSystemMessage'] as bool? ?? false,
);

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameId': instance.gameId,
      'senderId': instance.senderId,
      'senderDisplayName': instance.senderDisplayName,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'isSystemMessage': instance.isSystemMessage,
    };
