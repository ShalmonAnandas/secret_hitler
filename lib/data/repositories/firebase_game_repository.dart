import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/enums.dart';
import '../../core/constants/game_constants.dart';
import '../../core/utils/game_utils.dart';
import '../../domain/entities/game.dart';
import '../../domain/repositories/game_repository.dart';
import '../services/firestore_service.dart';

/// Firebase implementation of GameRepository
class FirebaseGameRepository implements GameRepository {
  final FirestoreService _firestoreService;

  const FirebaseGameRepository(this._firestoreService);

  /// Converts a Firestore document to a Game entity
  Game? _convertToGame(DocumentSnapshot doc) {
    if (!doc.exists) {
      return null;
    }

    final data = doc.data() as Map<String, dynamic>;

    return Game(
      id: doc.id,
      name: data['name'] as String,
      hostId: data['hostId'] as String,
      playerIds: List<String>.from(data['playerIds'] ?? []),
      phase: GamePhase.values.firstWhere(
        (e) => e.name == (data['phase'] as String),
        orElse: () => GamePhase.setup,
      ),
      status: GameStatus.values.firstWhere(
        (e) => e.name == (data['status'] as String),
        orElse: () => GameStatus.waiting,
      ),
      maxPlayers: data['maxPlayers'] as int? ?? GameConstants.defaultMaxPlayers,
      minPlayers: data['minPlayers'] as int? ?? GameConstants.minPlayers,
      isPrivate: data['isPrivate'] as bool? ?? false,
      accessCode: data['accessCode'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      currentPresidentIndex: data['currentPresidentIndex'] as int? ?? 0,
      currentChancellorIndex: data['currentChancellorIndex'] as int?,
      previousPresidentIndex: data['previousPresidentIndex'] as int?,
      previousChancellorIndex: data['previousChancellorIndex'] as int?,
      liberalPoliciesEnacted: data['liberalPoliciesEnacted'] as int? ?? 0,
      fascistPoliciesEnacted: data['fascistPoliciesEnacted'] as int? ?? 0,
      electionTracker: data['electionTracker'] as int? ?? 0,
      vetoUnlocked: data['vetoUnlocked'] as bool? ?? false,
      executedPlayerIds: List<String>.from(data['executedPlayerIds'] ?? []),
      winningTeam:
          data['winningTeam'] != null
              ? Team.values.firstWhere(
                (e) => e.name == (data['winningTeam'] as String),
                orElse: () => Team.liberal, // Default to liberal if not found
              )
              : null,
      winCondition: data['winCondition'] as String?,
      currentActionPlayerId: data['currentActionPlayerId'] as String?,
      currentAction:
          data['currentAction'] != null
              ? GameAction.values.firstWhere(
                (e) => e.name == (data['currentAction'] as String),
                orElse: () => GameAction.vote, // Default to vote if not found
              )
              : null,
      actionData: data['actionData'] as Map<String, dynamic>?,
    );
  }

  /// Converts a Game entity to a Firestore document data
  Map<String, dynamic> _gameToFirestore(Game game) {
    return {
      'name': game.name,
      'hostId': game.hostId,
      'playerIds': game.playerIds,
      'phase': game.phase.name,
      'status': game.status.name,
      'maxPlayers': game.maxPlayers,
      'minPlayers': game.minPlayers,
      'isPrivate': game.isPrivate,
      'accessCode': game.accessCode,
      'createdAt': Timestamp.fromDate(game.createdAt),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
      'currentPresidentIndex': game.currentPresidentIndex,
      'currentChancellorIndex': game.currentChancellorIndex,
      'previousPresidentIndex': game.previousPresidentIndex,
      'previousChancellorIndex': game.previousChancellorIndex,
      'liberalPoliciesEnacted': game.liberalPoliciesEnacted,
      'fascistPoliciesEnacted': game.fascistPoliciesEnacted,
      'electionTracker': game.electionTracker,
      'vetoUnlocked': game.vetoUnlocked,
      'executedPlayerIds': game.executedPlayerIds,
      'winningTeam': game.winningTeam?.name,
      'winCondition': game.winCondition,
      'currentActionPlayerId': game.currentActionPlayerId,
      'currentAction': game.currentAction?.name,
      'actionData': game.actionData,
    };
  }

  @override
  Future<Game> createGame({
    required String hostId,
    required String hostName,
    String? gameCode,
    int? maxPlayers,
  }) async {
    final gameId = _firestoreService.gamesCollection.doc().id;
    final accessCode = gameCode ?? GameUtils.generateAccessCode();
    final now = DateTime.now();

    final game = Game(
      id: gameId,
      name: '$hostName\'s Game',
      hostId: hostId,
      playerIds: [hostId], // Host is the first player
      phase: GamePhase.setup,
      status: GameStatus.waiting,
      maxPlayers: maxPlayers ?? GameConstants.defaultMaxPlayers,
      minPlayers: GameConstants.minPlayers,
      isPrivate:
          gameCode != null, // If gameCode is provided, it's a private game
      accessCode: accessCode,
      createdAt: now,
      updatedAt: now,
    );

    // Create the game document
    await _firestoreService.createDocument(
      collection: _firestoreService.gamesCollection,
      docId: gameId,
      data: _gameToFirestore(game),
    );

    // Create initial player entry (the host)
    await _firestoreService.createDocument(
      collection: _firestoreService.playersCollection(gameId),
      docId: hostId,
      data: {
        'id': hostId,
        'name': hostName,
        'isHost': true,
        'isReady': false,
        'joinedAt': Timestamp.fromDate(now),
      },
    );

    return game;
  }

  @override
  Future<Game?> getGameById(String gameId) async {
    final doc = await _firestoreService.getDocument(
      collection: _firestoreService.gamesCollection,
      docId: gameId,
    );

    return _convertToGame(doc);
  }

  @override
  Future<Game?> getGameByCode(String gameCode) async {
    final query = await _firestoreService.queryCollection(
      collection: _firestoreService.gamesCollection,
      queryBuilder:
          (collection) => collection
              .where('accessCode', isEqualTo: gameCode)
              .where('status', isEqualTo: GameStatus.waiting.name)
              .limit(1),
    );

    if (query.docs.isEmpty) {
      return null;
    }

    return _convertToGame(query.docs.first);
  }

  @override
  Future<void> updateGame(Game game) async {
    await _firestoreService.updateDocument(
      collection: _firestoreService.gamesCollection,
      docId: game.id,
      data: {
        ..._gameToFirestore(game),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
    );
  }

  @override
  Future<void> deleteGame(String gameId) async {
    // Delete all players in the game
    final playersQuery = await _firestoreService.queryCollection(
      collection: _firestoreService.playersCollection(gameId),
    );

    final batch = _firestoreService.batch();

    for (final playerDoc in playersQuery.docs) {
      batch.delete(playerDoc.reference);
    }

    // Delete the game document
    batch.delete(_firestoreService.gamesCollection.doc(gameId));

    await batch.commit();
  }

  @override
  Future<void> joinGame(
    String gameId,
    String playerId,
    String playerName,
  ) async {
    final gameDoc = await _firestoreService.getDocument(
      collection: _firestoreService.gamesCollection,
      docId: gameId,
    );

    if (!gameDoc.exists) {
      throw Exception('Game not found');
    }

    final gameData = gameDoc.data() as Map<String, dynamic>;

    // Check if game is joinable
    if (gameData['status'] != GameStatus.waiting.name) {
      throw Exception('Game is not accepting new players');
    }

    final playerIds = List<String>.from(gameData['playerIds'] ?? []);

    // Check if player is already in the game
    if (playerIds.contains(playerId)) {
      // Player is already in the game, just update their data
      await _firestoreService.updateDocument(
        collection: _firestoreService.playersCollection(gameId),
        docId: playerId,
        data: {
          'name': playerName,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        },
      );
      return;
    }

    // Check if game is full
    final maxPlayers =
        gameData['maxPlayers'] as int? ?? GameConstants.defaultMaxPlayers;
    if (playerIds.length >= maxPlayers) {
      throw Exception('Game is full');
    }

    // Add player to the game
    playerIds.add(playerId);

    await _firestoreService.updateDocument(
      collection: _firestoreService.gamesCollection,
      docId: gameId,
      data: {
        'playerIds': playerIds,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
    );

    // Create player document
    await _firestoreService.createDocument(
      collection: _firestoreService.playersCollection(gameId),
      docId: playerId,
      data: {
        'id': playerId,
        'name': playerName,
        'isHost': false,
        'isReady': false,
        'joinedAt': Timestamp.fromDate(DateTime.now()),
      },
    );
  }

  @override
  Future<void> leaveGame(String gameId, String playerId) async {
    final gameDoc = await _firestoreService.getDocument(
      collection: _firestoreService.gamesCollection,
      docId: gameId,
    );

    if (!gameDoc.exists) {
      return; // Game doesn't exist, nothing to do
    }

    final gameData = gameDoc.data() as Map<String, dynamic>;
    final playerIds = List<String>.from(gameData['playerIds'] ?? []);

    // Check if player is in the game
    if (!playerIds.contains(playerId)) {
      return; // Player not in the game, nothing to do
    }

    // Remove player from the game
    playerIds.remove(playerId);

    // Delete player document
    await _firestoreService.deleteDocument(
      collection: _firestoreService.playersCollection(gameId),
      docId: playerId,
    );

    // If this is the host, either transfer host status or delete the game
    if (gameData['hostId'] == playerId) {
      if (playerIds.isEmpty) {
        // No more players, delete the game
        await _firestoreService.deleteDocument(
          collection: _firestoreService.gamesCollection,
          docId: gameId,
        );
        return;
      } else {
        // Transfer host status to the next player
        final newHostId = playerIds.first;
        await _firestoreService.updateDocument(
          collection: _firestoreService.playersCollection(gameId),
          docId: newHostId,
          data: {'isHost': true},
        );

        await _firestoreService.updateDocument(
          collection: _firestoreService.gamesCollection,
          docId: gameId,
          data: {
            'playerIds': playerIds,
            'hostId': newHostId,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          },
        );
      }
    } else {
      // Just update the player list
      await _firestoreService.updateDocument(
        collection: _firestoreService.gamesCollection,
        docId: gameId,
        data: {
          'playerIds': playerIds,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        },
      );
    }
  }

  @override
  Future<void> startGame(String gameId) async {
    final gameDoc = await _firestoreService.getDocument(
      collection: _firestoreService.gamesCollection,
      docId: gameId,
    );

    if (!gameDoc.exists) {
      throw Exception('Game not found');
    }

    final gameData = gameDoc.data() as Map<String, dynamic>;
    final playerIds = List<String>.from(gameData['playerIds'] ?? []);

    // Check if game has minimum number of players
    if (playerIds.length < GameConstants.minPlayers) {
      throw Exception('Not enough players to start the game');
    }

    // Update game status
    await _firestoreService.updateDocument(
      collection: _firestoreService.gamesCollection,
      docId: gameId,
      data: {
        'status': GameStatus.inProgress.name,
        'phase': GamePhase.nomination.name,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
    );

    // TODO: Initialize game state (assign roles, create policy deck, etc.)
    // This would typically be handled by a Cloud Function for security
  }

  @override
  Future<void> endGame(String gameId) async {
    await _firestoreService.updateDocument(
      collection: _firestoreService.gamesCollection,
      docId: gameId,
      data: {
        'status': GameStatus.finished.name,
        'phase': GamePhase.gameOver.name,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      },
    );
  }

  @override
  Future<List<Game>> getActiveGames() async {
    final query = await _firestoreService.queryCollection(
      collection: _firestoreService.gamesCollection,
      queryBuilder:
          (collection) => collection
              .where('status', isEqualTo: GameStatus.waiting.name)
              .where('isPrivate', isEqualTo: false) // Only public games
              .orderBy('createdAt', descending: true),
    );

    return query.docs
        .map((doc) => _convertToGame(doc))
        .whereType<Game>()
        .toList();
  }

  @override
  Future<List<Game>> getGamesByHost(String hostId) async {
    final query = await _firestoreService.queryCollection(
      collection: _firestoreService.gamesCollection,
      queryBuilder:
          (collection) => collection
              .where('hostId', isEqualTo: hostId)
              .orderBy('createdAt', descending: true),
    );

    return query.docs
        .map((doc) => _convertToGame(doc))
        .whereType<Game>()
        .toList();
  }

  @override
  Stream<Game?> watchGame(String gameId) {
    return _firestoreService
        .watchDocument(
          collection: _firestoreService.gamesCollection,
          docId: gameId,
        )
        .map((doc) => _convertToGame(doc));
  }

  @override
  Stream<List<Game>> watchActiveGames() {
    return _firestoreService
        .watchCollection(
          collection: _firestoreService.gamesCollection,
          queryBuilder:
              (collection) => collection
                  .where('status', isEqualTo: GameStatus.waiting.name)
                  .where('isPrivate', isEqualTo: false) // Only public games
                  .orderBy('createdAt', descending: true),
        )
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => _convertToGame(doc))
                  .whereType<Game>()
                  .toList(),
        );
  }

  @override
  Future<bool> gameCodeExists(String gameCode) async {
    final query = await _firestoreService.queryCollection(
      collection: _firestoreService.gamesCollection,
      queryBuilder:
          (collection) =>
              collection.where('accessCode', isEqualTo: gameCode).limit(1),
    );

    return query.docs.isNotEmpty;
  }

  @override
  Future<String> generateGameCode() async {
    // Try to generate a unique game code (max 3 attempts)
    for (int i = 0; i < 3; i++) {
      final gameCode = GameUtils.generateAccessCode();
      final exists = await gameCodeExists(gameCode);

      if (!exists) {
        return gameCode;
      }
    }

    // If we couldn't generate a unique code in 3 attempts,
    // generate a longer code that's almost certainly unique
    return GameUtils.generateAccessCode(length: 8);
  }
}
