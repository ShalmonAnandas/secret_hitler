import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/game_constants.dart';
import '../../providers/game_provider.dart';
import '../../providers/username_provider.dart';
import '../../router/app_router.dart';
import '../../widgets/common/app_widgets.dart' as common;

class CreateGamePage extends ConsumerStatefulWidget {
  const CreateGamePage({super.key});

  @override
  ConsumerState<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends ConsumerState<CreateGamePage> {
  int _maxPlayers = GameConstants.defaultMaxPlayers;
  bool _isPrivate = false;
  @override
  Widget build(BuildContext context) {
    final usernameState = ref.watch(usernameProvider);

    return Scaffold(
      appBar: const common.CustomAppBar(title: 'Create Game'),
      body: usernameState.when(
        data:
            (username) =>
                username != null && username.isNotEmpty
                    ? _buildCreateGameForm(context, username)
                    : _buildUsernameRequired(context),
        loading: () => const common.LoadingWidget(message: 'Loading...'),
        error:
            (error, _) => common.ErrorWidget(
              message: error.toString(),
              onRetry: () => ref.refresh(usernameProvider),
            ),
      ),
    );
  }

  Widget _buildCreateGameForm(BuildContext context, String userName) {
    final usernameNotifier = ref.read(usernameProvider.notifier);
    final userId = usernameNotifier.userId;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildGameSettings(context),
          const SizedBox(height: 32),
          _buildCreateButton(context, userId, userName),
        ],
      ),
    );
  }

  Widget _buildGameSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Game Settings', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        common.AppCard(
          child: Column(
            children: [
              _buildMaxPlayersSlider(context),
              const Divider(),
              _buildPrivateGameToggle(context),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildGameInfo(context),
      ],
    );
  }

  Widget _buildMaxPlayersSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Maximum Players',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '$_maxPlayers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _maxPlayers.toDouble(),
          min: GameConstants.minPlayers.toDouble(),
          max: GameConstants.maxPlayers.toDouble(),
          divisions: GameConstants.maxPlayers - GameConstants.minPlayers,
          onChanged: (value) {
            setState(() {
              _maxPlayers = value.round();
            });
          },
        ),
        Text(
          'Range: ${GameConstants.minPlayers} - ${GameConstants.maxPlayers} players',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildPrivateGameToggle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Private Game',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Only players with the game code can join',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Switch(
          value: _isPrivate,
          onChanged: (value) {
            setState(() {
              _isPrivate = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    return common.AppCard(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'Game Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Secret Hitler is a dramatic game of political intrigue and deduction. '
            'Players are secretly divided into two teams: the liberals, who have '
            'a majority, and the fascists, who are hidden to everyone but each other.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Game duration: 30-45 minutes',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(
    BuildContext context,
    String userId,
    String userName,
  ) {
    final createGameState = ref.watch(createGameProvider);
    return common.LoadingButton(
      onPressed: () => _createGame(userId, userName),
      isLoading: createGameState.isLoading,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Create Game'),
    );
  }

  Widget _buildUsernameRequired(BuildContext context) {
    return common.EmptyStateWidget(
      title: 'Username Required',
      message: 'You need to set your username to create a game',
      icon: Icons.person_off,
      onAction: () => context.goToUsernameEntry(),
      actionLabel: 'Set Username',
    );
  }

  Future<void> _createGame(String userId, String userName) async {
    try {
      final game = await ref
          .read(createGameProvider.notifier)
          .createGame(
            hostId: userId,
            hostName: userName,
            maxPlayers: _maxPlayers,
          );

      if (game != null && mounted) {
        // Navigate to lobby
        context.goToLobby(game.id);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Game created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create game: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
