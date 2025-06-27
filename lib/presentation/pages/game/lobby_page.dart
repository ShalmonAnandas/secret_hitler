import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/constants/enums.dart';
import '../../../domain/entities/game.dart';
import '../../../domain/entities/player.dart';

import '../../providers/game_provider.dart';
import '../../providers/username_provider.dart';
import '../../providers/player_provider.dart';
import '../../router/app_router.dart';

class LobbyPage extends ConsumerStatefulWidget {
  final String gameId;

  const LobbyPage({super.key, required this.gameId});

  @override
  ConsumerState<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends ConsumerState<LobbyPage> {
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStreamProvider(widget.gameId));
    final playersState = ref.watch(playersStreamProvider(widget.gameId));
    final usernameNotifier = ref.watch(usernameProvider.notifier);
    final currentUserId = usernameNotifier.userId;

    return Scaffold(
      appBar: AppBar(
        title: gameState.when(
          data: (game) => Text(game?.name ?? 'Game Lobby'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        actions: [
          gameState.when(
            data: (game) {
              if (game != null && game.hostId == currentUserId) {
                return IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _showGameSettings(context, game),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed:
                () => gameState.whenData((game) {
                  if (game?.accessCode != null) {
                    _shareGameCode(context, game!.accessCode!);
                  }
                }),
          ),
        ],
      ),
      body: gameState.when(
        data: (game) {
          if (game == null) {
            return _buildGameNotFound(context);
          }

          return playersState.when(
            data:
                (players) => Column(
                  children: [
                    _buildGameInfo(context, game),
                    const Divider(),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildPlayersList(
                              context,
                              game,
                              players,
                              currentUserId,
                            ),
                          ),
                          const VerticalDivider(),
                          Expanded(flex: 2, child: _buildChatSection(context)),
                        ],
                      ),
                    ),
                    _buildBottomActions(context, game, players, currentUserId),
                  ],
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _buildErrorState(context, error.toString()),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildErrorState(context, error.toString()),
      ),
    );
  }

  Widget _buildGameNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Game not found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('The game you\'re looking for doesn\'t exist.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context, dynamic game) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Game Code: ${game.accessCode ?? 'N/A'}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Players: ${game.playerIds.length}/${game.maxPlayers}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${game.status.toString().split('.').last}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (game.accessCode != null)
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _shareGameCode(context, game.accessCode!),
                  tooltip: 'Copy game code',
                ),
            ],
          ),
          if (game.isPrivate && game.accessCode != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Private game - Share code with friends: ${game.accessCode}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _shareGameCode(BuildContext context, String gameCode) {
    Clipboard.setData(ClipboardData(text: gameCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Game code "$gameCode" copied to clipboard!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPlayersList(
    BuildContext context,
    Game game,
    List<Player> players,
    String currentUserId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Players (${players.length}/${game.maxPlayers})',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              final isCurrentUser = currentUserId == player.userId;
              final isHost = player.isHost;
              final canKick =
                  currentUserId == game.hostId &&
                  !isCurrentUser &&
                  game.status.name == 'waiting';

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isCurrentUser
                            ? Theme.of(context).primaryColor
                            : Colors.grey[400],
                    child: Text(
                      player.username[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        player.username,
                        style: TextStyle(
                          fontWeight:
                              isCurrentUser
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        const Text(
                          '(You)',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                      if (isHost) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: const Text('Host'),
                          backgroundColor: Colors.amber[100],
                          labelStyle: TextStyle(
                            color: Colors.amber[800],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        player.isReady ? Icons.check_circle : Icons.schedule,
                        color: player.isReady ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                      if (canKick) ...[
                        const SizedBox(width: 8),
                        PopupMenuButton<String>(
                          onSelected:
                              (value) => _handlePlayerAction(
                                value,
                                player.userId,
                                player.username,
                              ),
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'kick',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person_remove,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Kick Player'),
                                    ],
                                  ),
                                ),
                                if (!isHost)
                                  const PopupMenuItem(
                                    value: 'transfer_host',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.admin_panel_settings,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Make Host'),
                                      ],
                                    ),
                                  ),
                              ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatSection(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Chat',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildChatMessage(
                        'System',
                        'Welcome to the lobby!',
                        true,
                      ),
                      _buildChatMessage('Player1', 'Ready to play!', false),
                      _buildChatMessage(
                        'System',
                        'Waiting for more players...',
                        true,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onSubmitted: (_) => _sendChatMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _sendChatMessage,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildChatMessage(String sender, String message, bool isSystem) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$sender: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  isSystem ? Colors.grey[600] : Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: isSystem ? Colors.grey[600] : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    Game game,
    List<Player> players,
    String currentUserId,
  ) {
    final usernameState = ref.read(usernameProvider).valueOrNull;
    final currentUsername = usernameState ?? 'Player';

    final isHost = game.hostId == currentUserId;
    final currentPlayer = players.firstWhere(
      (p) => p.userId == currentUserId,
      orElse:
          () => Player(
            id: currentUserId,
            userId: currentUserId,
            username: currentUsername,
            role: Role.liberal,
            team: Team.liberal,
            position: 0,
            joinedAt: DateTime.now(),
          ),
    );
    final canStart =
        isHost &&
        players.length >= GameConstants.minPlayers &&
        players.every((p) => p.isReady) &&
        game.status.name == 'waiting';

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isHost) ...[
            ElevatedButton.icon(
              onPressed: canStart ? () => _startGame(context, game.id) : null,
              icon: const Icon(Icons.play_arrow),
              label: Text(canStart ? 'Start Game' : 'Waiting for players...'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      () => _toggleReady(context, game.id, currentUserId),
                  icon: Icon(
                    currentPlayer.isReady ? Icons.check_circle : Icons.schedule,
                  ),
                  label: Text(currentPlayer.isReady ? 'Ready' : 'Not Ready'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        currentPlayer.isReady ? Colors.green : Colors.orange,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _leaveLobby(context, game.id, currentUserId),
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('Leave'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGameSettings(BuildContext context, dynamic game) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Game Settings'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Game settings will be available here'),
                // TODO: Add game settings like difficulty, rules, etc.
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _handlePlayerAction(String action, String playerId, String playerName) {
    switch (action) {
      case 'kick':
        _showKickPlayerDialog(playerId, playerName);
        break;
      case 'transfer_host':
        _showTransferHostDialog(playerId, playerName);
        break;
    }
  }

  void _showKickPlayerDialog(String playerId, String playerName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Kick Player'),
            content: Text('Are you sure you want to kick $playerName?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await ref
                        .read(playerActionsProvider.notifier)
                        .removePlayer(widget.gameId, playerId);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$playerName has been kicked')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to kick player: $e')),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Kick'),
              ),
            ],
          ),
    );
  }

  void _showTransferHostDialog(String playerId, String playerName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Transfer Host'),
            content: Text(
              'Are you sure you want to make $playerName the new host?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await ref
                        .read(playerActionsProvider.notifier)
                        .transferHost(widget.gameId, playerId);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$playerName is now the host')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to transfer host: $e')),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                child: const Text('Transfer'),
              ),
            ],
          ),
    );
  }

  void _sendChatMessage() {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;

    _chatController.clear();
    // TODO: Implement chat functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat functionality coming soon')),
    );
  }

  void _startGame(BuildContext context, String gameId) async {
    try {
      // TODO: Implement start game logic with proper game state management
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Starting game...')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to start game: $e')));
      }
    }
  }

  void _toggleReady(BuildContext context, String gameId, String userId) async {
    try {
      await ref
          .read(playerActionsProvider.notifier)
          .toggleReady(gameId, userId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to toggle ready status: $e')),
        );
      }
    }
  }

  void _leaveLobby(BuildContext context, String gameId, String userId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Leave Lobby'),
            content: const Text('Are you sure you want to leave this lobby?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await ref
                        .read(playerActionsProvider.notifier)
                        .removePlayer(gameId, userId);
                    if (mounted) {
                      context.go(AppRoutes.home);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to leave lobby: $e')),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Leave'),
              ),
            ],
          ),
    );
  }
}
