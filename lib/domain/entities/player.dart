import 'package:equatable/equatable.dart';
import '../../core/constants/enums.dart';

/// Domain entity representing a player in the game
class Player extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final Role role;
  final Team team;
  final bool isAlive;
  final bool isReady;
  final bool isHost;
  final bool isPresident;
  final bool isChancellor;
  final bool hasVoted;
  final Vote? vote;
  final List<PolicyType> policiesInHand;
  final int position;
  final DateTime joinedAt;
  final DateTime? lastActiveAt;

  const Player({
    required this.id,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.role,
    required this.team,
    this.isAlive = true,
    this.isReady = false,
    this.isHost = false,
    this.isPresident = false,
    this.isChancellor = false,
    this.hasVoted = false,
    this.vote,
    this.policiesInHand = const [],
    required this.position,
    required this.joinedAt,
    this.lastActiveAt,
  });

  /// Creates a copy of this player with the given fields replaced
  Player copyWith({
    String? id,
    String? userId,
    String? username,
    String? avatarUrl,
    Role? role,
    Team? team,
    bool? isAlive,
    bool? isReady,
    bool? isHost,
    bool? isPresident,
    bool? isChancellor,
    bool? hasVoted,
    Vote? vote,
    List<PolicyType>? policiesInHand,
    int? position,
    DateTime? joinedAt,
    DateTime? lastActiveAt,
  }) {
    return Player(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      team: team ?? this.team,
      isAlive: isAlive ?? this.isAlive,
      isReady: isReady ?? this.isReady,
      isHost: isHost ?? this.isHost,
      isPresident: isPresident ?? this.isPresident,
      isChancellor: isChancellor ?? this.isChancellor,
      hasVoted: hasVoted ?? this.hasVoted,
      vote: vote ?? this.vote,
      policiesInHand: policiesInHand ?? this.policiesInHand,
      position: position ?? this.position,
      joinedAt: joinedAt ?? this.joinedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  /// Checks if this player is a fascist (including Hitler)
  bool get isFascist => team == Team.fascist;

  /// Checks if this player is a liberal
  bool get isLiberal => team == Team.liberal;

  /// Checks if this player is Hitler
  bool get isHitler => role == Role.hitler;

  /// Checks if this player can be nominated as chancellor
  bool get canBeChancellor {
    return isAlive && !isPresident && !isChancellor;
  }

  /// Checks if this player can vote
  bool get canVote => isAlive && !hasVoted;

  @override
  List<Object?> get props => [
    id,
    userId,
    username,
    avatarUrl,
    role,
    team,
    isAlive,
    isReady,
    isHost,
    isPresident,
    isChancellor,
    hasVoted,
    vote,
    policiesInHand,
    position,
    joinedAt,
    lastActiveAt,
  ];
}
