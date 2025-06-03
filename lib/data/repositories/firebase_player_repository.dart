import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/enums.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/player_repository.dart';
import '../services/firestore_service.dart';

/// Firebase implementation of PlayerRepository
class FirebasePlayerRepository implements PlayerRepository {
  final FirestoreService _firestoreService;

  const FirebasePlayerRepository(this._firestoreService);

  /// Converts a Firestore document to a Player entity
  Player? _convertToPlayer(DocumentSnapshot doc) {
    if (!doc.exists) {
      return null;
    }

    final data = doc.data() as Map<String, dynamic>;

    return Player(
      id: doc.id,
      userId: data['userId'] as String,
      username: data['username'] as String,
      avatarUrl: data['avatarUrl'] as String?,
      role:
          data['role'] != null
              ? Role.values.firstWhere(
                (e) => e.name == (data['role'] as String),
                orElse: () => Role.liberal, // Default to liberal if not found
              )
              : Role.liberal,
      team:
          data['team'] != null
              ? Team.values.firstWhere(
                (e) => e.name == (data['team'] as String),
                orElse: () => Team.liberal, // Default to liberal if not found
              )
              : Team.liberal,
      isAlive: data['isAlive'] as bool? ?? true,
      isReady: data['isReady'] as bool? ?? false,
      isHost: data['isHost'] as bool? ?? false,
      isPresident: data['isPresident'] as bool? ?? false,
      isChancellor: data['isChancellor'] as bool? ?? false,
      hasVoted: data['hasVoted'] as bool? ?? false,
      vote:
          data['vote'] != null
              ? Vote.values.firstWhere(
                (e) => e.name == (data['vote'] as String),
                orElse: () => Vote.ja, // Default to ja if not found
              )
              : null,
      policiesInHand:
          data['policiesInHand'] != null
              ? (data['policiesInHand'] as List)
                  .map(
                    (e) => PolicyType.values.firstWhere(
                      (type) => type.name == e,
                      orElse: () => PolicyType.liberal,
                    ),
                  )
                  .toList()
              : const [],
      position: data['position'] as int? ?? 0,
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      lastActiveAt:
          data['lastActiveAt'] != null
              ? (data['lastActiveAt'] as Timestamp).toDate()
              : null,
    );
  }

  /// Converts a Player entity to a Firestore document data
  Map<String, dynamic> _playerToFirestore(Player player) {
    return {
      'userId': player.userId,
      'username': player.username,
      'avatarUrl': player.avatarUrl,
      'role': player.role.name,
      'team': player.team.name,
      'isAlive': player.isAlive,
      'isReady': player.isReady,
      'isHost': player.isHost,
      'isPresident': player.isPresident,
      'isChancellor': player.isChancellor,
      'hasVoted': player.hasVoted,
      'vote': player.vote?.name,
      'policiesInHand': player.policiesInHand.map((p) => p.name).toList(),
      'position': player.position,
      'joinedAt': Timestamp.fromDate(player.joinedAt),
      'lastActiveAt':
          player.lastActiveAt != null
              ? Timestamp.fromDate(player.lastActiveAt!)
              : null,
    };
  }

  @override
  Future<void> addPlayer(String gameId, Player player) async {
    await _firestoreService.createDocument(
      collection: _firestoreService.playersCollection(gameId),
      docId: player.id,
      data: _playerToFirestore(player),
    );
  }

  @override
  Future<void> removePlayer(String gameId, String playerId) async {
    await _firestoreService.deleteDocument(
      collection: _firestoreService.playersCollection(gameId),
      docId: playerId,
    );
  }

  @override
  Future<void> updatePlayer(String gameId, Player player) async {
    await _firestoreService.updateDocument(
      collection: _firestoreService.playersCollection(gameId),
      docId: player.id,
      data: {
        ..._playerToFirestore(player),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
    );
  }

  @override
  Future<Player?> getPlayer(String gameId, String playerId) async {
    final doc = await _firestoreService.getDocument(
      collection: _firestoreService.playersCollection(gameId),
      docId: playerId,
    );

    return _convertToPlayer(doc);
  }

  @override
  Future<List<Player>> getPlayers(String gameId) async {
    final query = await _firestoreService.queryCollection(
      collection: _firestoreService.playersCollection(gameId),
    );

    return query.docs
        .map((doc) => _convertToPlayer(doc))
        .whereType<Player>()
        .toList();
  }

  @override
  Stream<List<Player>> watchPlayers(String gameId) {
    return _firestoreService
        .watchCollection(
          collection: _firestoreService.playersCollection(gameId),
        )
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => _convertToPlayer(doc))
                  .whereType<Player>()
                  .toList(),
        );
  }

  @override
  Stream<Player?> watchPlayer(String gameId, String playerId) {
    return _firestoreService
        .watchDocument(
          collection: _firestoreService.playersCollection(gameId),
          docId: playerId,
        )
        .map((doc) => _convertToPlayer(doc));
  }

  @override
  Future<void> assignRoles(
    String gameId,
    Map<String, String> playerRoles,
  ) async {
    final batch = _firestoreService.batch();
    final playersCollection = _firestoreService.playersCollection(gameId);

    for (final entry in playerRoles.entries) {
      final playerId = entry.key;
      final roleName = entry.value;

      final role = Role.values.firstWhere(
        (r) => r.name == roleName,
        orElse: () => Role.liberal, // Default to liberal if not found
      );

      // Team is determined by role
      final team = role.isFascist ? Team.fascist : Team.liberal;

      final playerRef = playersCollection.doc(playerId);

      batch.update(playerRef, {
        'role': roleName,
        'team': team.name,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    }

    await batch.commit();
  }

  @override
  Future<void> updatePlayerStatus(
    String gameId,
    String playerId,
    String status,
  ) async {
    await _firestoreService.updateDocument(
      collection: _firestoreService.playersCollection(gameId),
      docId: playerId,
      data: {
        'isAlive': status == 'alive',
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
    );
  }

  @override
  Future<List<Player>> getPlayersByRole(String gameId, String roleName) async {
    final allPlayers = await getPlayers(gameId);

    final role = Role.values.firstWhere(
      (r) => r.name == roleName,
      orElse: () => Role.liberal,
    );

    return allPlayers.where((player) => player.role == role).toList();
  }

  @override
  Future<bool> isPlayerInGame(String gameId, String playerId) async {
    final doc = await _firestoreService.getDocument(
      collection: _firestoreService.playersCollection(gameId),
      docId: playerId,
    );

    return doc.exists;
  }
}
