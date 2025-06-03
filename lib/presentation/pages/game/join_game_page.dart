import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_hitler/presentation/providers/app_providers.dart';
import '../../providers/game_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_widgets.dart';
import '../../router/app_router.dart';

class JoinGamePage extends ConsumerStatefulWidget {
  const JoinGamePage({super.key});

  @override
  ConsumerState<JoinGamePage> createState() => _JoinGamePageState();
}

class _JoinGamePageState extends ConsumerState<JoinGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _gameCodeController = TextEditingController();
  final _playerNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Prefill player name with user's display name
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).valueOrNull;
      if (user != null) {
        _playerNameController.text = user.displayName;
      }
    });
  }

  @override
  void dispose() {
    _gameCodeController.dispose();
    _playerNameController.dispose();
    super.dispose();
  }

  Future<void> _joinGame() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final gameCode = _gameCodeController.text.trim().toUpperCase();
      final playerName = _playerNameController.text.trim();
      final currentUser = ref.read(authProvider).valueOrNull;

      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Please sign in first')));
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final success = await ref
          .read(joinGameProvider.notifier)
          .joinGame(
            gameCode: gameCode,
            playerId: currentUser.id,
            playerName: playerName,
          );

      if (success && mounted) {
        // Get the game by code to get its ID
        final gameUseCase = ref.read(gameUseCaseProvider);
        final game = await gameUseCase.getGameByCode(gameCode);

        if (game != null && mounted) {
          // Navigate to lobby with the game ID
          context.pushReplacementNamed(
            AppRoutes.lobby,
            pathParameters: {'gameId': game.id},
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to join game: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Join Game'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Join an existing game',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the game code provided by the host',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Game Code Input
                TextFormField(
                  controller: _gameCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Game Code',
                    hintText: 'Enter 6-character code',
                    prefixIcon: Icon(Icons.games),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a game code';
                    }
                    if (value.trim().length != 6) {
                      return 'Game code must be 6 characters';
                    }
                    if (!RegExp(
                      r'^[A-Z0-9]+$',
                    ).hasMatch(value.trim().toUpperCase())) {
                      return 'Game code can only contain letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Player Name Input
                TextFormField(
                  controller: _playerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    hintText: 'Enter your display name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLength: 20,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Join Button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _joinGame,
                  icon:
                      _isLoading
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                          : const Icon(Icons.login),
                  label: Text(_isLoading ? 'Joining...' : 'Join Game'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),

                // Back Button
                OutlinedButton.icon(
                  onPressed:
                      _isLoading ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Home'),
                ),

                const Spacer(),

                // Info Card
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How to Join',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ask the game host for the 6-character game code. '
                                'Make sure your device is connected to the internet.',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
