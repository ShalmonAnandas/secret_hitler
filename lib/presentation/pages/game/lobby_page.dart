import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/game_constants.dart';

class LobbyPage extends ConsumerStatefulWidget {
  final String gameId;

  const LobbyPage({super.key, required this.gameId});

  @override
  ConsumerState<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends ConsumerState<LobbyPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Watch game state and player list

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Lobby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showGameSettings(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildGameInfo(context),
          const Divider(),
          Expanded(child: _buildPlayersList(context)),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
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
                      'Game Code: ${widget.gameId.substring(0, 6).toUpperCase()}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Waiting for players...',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  // TODO: Copy game code to clipboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Game code copied!')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildGameStatusCard(context),
        ],
      ),
    );
  }

  Widget _buildGameStatusCard(BuildContext context) {
    // TODO: Get actual game state
    const playerCount = 3; // Mock data
    const minPlayers = GameConstants.minPlayers;
    const maxPlayers = GameConstants.maxPlayers;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Players', style: Theme.of(context).textTheme.titleSmall),
                Text(
                  '$playerCount/$maxPlayers',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color:
                        playerCount >= minPlayers
                            ? Colors.green
                            : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: playerCount / maxPlayers,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                playerCount >= minPlayers ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              playerCount < minPlayers
                  ? 'Need ${minPlayers - playerCount} more players to start'
                  : 'Ready to start!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: playerCount >= minPlayers ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersList(BuildContext context) {
    // TODO: Get actual players from game state
    final mockPlayers = [
      {'name': 'Player 1', 'isHost': true, 'isReady': true},
      {'name': 'Player 2', 'isHost': false, 'isReady': false},
      {'name': 'Player 3', 'isHost': false, 'isReady': true},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: mockPlayers.length,
      itemBuilder: (context, index) {
        final player = mockPlayers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                player['name'].toString()[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Row(
              children: [
                Text(player['name'].toString()),
                if (player['isHost'] as bool) ...[
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
                  player['isReady'] as bool
                      ? Icons.check_circle
                      : Icons.schedule,
                  color:
                      player['isReady'] as bool ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                if (player['isHost'] as bool)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      _handlePlayerAction(value, player['name'].toString());
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'kick',
                            child: Row(
                              children: [
                                Icon(Icons.person_remove, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Kick Player'),
                              ],
                            ),
                          ),
                        ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    // TODO: Check if current user is host and if game can start
    const isHost = true; // Mock data
    final playerCount = 3; // Mock data
    final canStart = playerCount >= GameConstants.minPlayers;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isHost) ...[
            ElevatedButton(
              onPressed: canStart ? _startGame : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Start Game'),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _toggleReady();
                  },
                  child: const Text('Toggle Ready'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _leaveLobby();
                  },
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Leave'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGameSettings(BuildContext context) {
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

  void _handlePlayerAction(String action, String playerName) {
    switch (action) {
      case 'kick':
        _showKickPlayerDialog(playerName);
        break;
    }
  }

  void _showKickPlayerDialog(String playerName) {
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
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Implement kick player
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$playerName has been kicked')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Kick'),
              ),
            ],
          ),
    );
  }

  void _startGame() {
    // TODO: Implement start game logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Starting game...')));
  }

  void _toggleReady() {
    // TODO: Implement toggle ready logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Toggled ready status')));
  }

  void _leaveLobby() {
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
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to home
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Leave'),
              ),
            ],
          ),
    );
  }
}
