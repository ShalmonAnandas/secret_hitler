import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../core/constants/enums.dart';

part 'player_model.g.dart';

/// Represents sensitive, player-specific data stored in a secure subcollection
@JsonSerializable()
class PlayerModel extends Equatable {
  final String userId;
  final String gameId;
  final GameRole role;
  final List<PolicyType> handPolicies;
  final Vote? currentVote;
  final List<String> knownFascists;
  final bool hasVoted;
  final bool hasActed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlayerModel({
    required this.userId,
    required this.gameId,
    required this.role,
    this.handPolicies = const [],
    this.currentVote,
    this.knownFascists = const [],
    this.hasVoted = false,
    this.hasActed = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerModelToJson(this);

  bool get isFascistTeam => role.isFascist;
  bool get isLiberal => role.isLiberal;
  bool get isHitler => role == GameRole.hitler;

  PlayerModel copyWith({
    String? userId,
    String? gameId,
    GameRole? role,
    List<PolicyType>? handPolicies,
    Vote? currentVote,
    List<String>? knownFascists,
    bool? hasVoted,
    bool? hasActed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlayerModel(
      userId: userId ?? this.userId,
      gameId: gameId ?? this.gameId,
      role: role ?? this.role,
      handPolicies: handPolicies ?? this.handPolicies,
      currentVote: currentVote ?? this.currentVote,
      knownFascists: knownFascists ?? this.knownFascists,
      hasVoted: hasVoted ?? this.hasVoted,
      hasActed: hasActed ?? this.hasActed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    gameId,
    role,
    handPolicies,
    currentVote,
    knownFascists,
    hasVoted,
    hasActed,
    createdAt,
    updatedAt,
  ];
}

/// Represents a policy card
@JsonSerializable()
class PolicyCard extends Equatable {
  final String id;
  final PolicyType type;
  final DateTime createdAt;

  const PolicyCard({
    required this.id,
    required this.type,
    required this.createdAt,
  });

  factory PolicyCard.fromJson(Map<String, dynamic> json) =>
      _$PolicyCardFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyCardToJson(this);

  PolicyCard copyWith({String? id, PolicyType? type, DateTime? createdAt}) {
    return PolicyCard(
      id: id ?? this.id,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, type, createdAt];
}

/// Represents the policy deck state (secure)
@JsonSerializable()
class PolicyDeck extends Equatable {
  final String gameId;
  final List<PolicyCard> drawPile;
  final List<PolicyCard> discardPile;
  final DateTime updatedAt;

  const PolicyDeck({
    required this.gameId,
    required this.drawPile,
    required this.discardPile,
    required this.updatedAt,
  });

  factory PolicyDeck.fromJson(Map<String, dynamic> json) =>
      _$PolicyDeckFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyDeckToJson(this);

  int get remainingCards => drawPile.length;
  bool get needsReshuffle => drawPile.length < 3;

  PolicyDeck copyWith({
    String? gameId,
    List<PolicyCard>? drawPile,
    List<PolicyCard>? discardPile,
    DateTime? updatedAt,
  }) {
    return PolicyDeck(
      gameId: gameId ?? this.gameId,
      drawPile: drawPile ?? this.drawPile,
      discardPile: discardPile ?? this.discardPile,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [gameId, drawPile, discardPile, updatedAt];
}

/// Represents a chat message in the game
@JsonSerializable()
class ChatMessage extends Equatable {
  final String id;
  final String gameId;
  final String senderId;
  final String senderDisplayName;
  final String message;
  final DateTime timestamp;
  final bool isSystemMessage;

  const ChatMessage({
    required this.id,
    required this.gameId,
    required this.senderId,
    required this.senderDisplayName,
    required this.message,
    required this.timestamp,
    this.isSystemMessage = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  ChatMessage copyWith({
    String? id,
    String? gameId,
    String? senderId,
    String? senderDisplayName,
    String? message,
    DateTime? timestamp,
    bool? isSystemMessage,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      senderId: senderId ?? this.senderId,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isSystemMessage: isSystemMessage ?? this.isSystemMessage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    gameId,
    senderId,
    senderDisplayName,
    message,
    timestamp,
    isSystemMessage,
  ];
}
