/// Player roles in the game
enum GameRole {
  liberal('Liberal'),
  fascist('Fascist'),
  hitler('Hitler');

  const GameRole(this.displayName);

  final String displayName;

  /// Whether this role is part of the fascist team
  bool get isFascist => this == GameRole.fascist || this == GameRole.hitler;

  /// Whether this role is part of the liberal team
  bool get isLiberal => this == GameRole.liberal;
}

/// Player roles in the game
enum Role {
  liberal('Liberal'),
  fascist('Fascist'),
  hitler('Hitler');

  const Role(this.displayName);

  final String displayName;

  /// Check if this role is on the fascist team
  bool get isFascist => this == fascist || this == hitler;

  /// Check if this role is liberal
  bool get isLiberal => this == liberal;
}

/// Policy types that can be enacted
enum PolicyType {
  liberal('Liberal'),
  fascist('Fascist');

  const PolicyType(this.displayName);

  final String displayName;
}

/// Current phase of the game
enum GamePhase {
  setup('Setup'),
  nomination('Nomination'),
  election('Election'),
  legislative('Legislative'),
  presidentialPower('Presidential Power'),
  gameOver('Game Over');

  const GamePhase(this.displayName);

  final String displayName;
}

/// Types of presidential powers
enum PresidentialPower {
  policyPeek('Policy Peek'),
  investigateLoyalty('Investigate Loyalty'),
  specialElection('Special Election'),
  execution('Execution');

  const PresidentialPower(this.displayName);

  final String displayName;

  String get description {
    switch (this) {
      case PresidentialPower.policyPeek:
        return 'The President examines the top three cards of the Policy deck and then returns them to the top of the deck in the same order.';
      case PresidentialPower.investigateLoyalty:
        return 'The President chooses a player to investigate. The President sees that player\'s Party Membership card.';
      case PresidentialPower.specialElection:
        return 'The President chooses any other player to be the next Presidential Candidate.';
      case PresidentialPower.execution:
        return 'The President must choose a player to execute. If that player is Hitler, the game ends and the Liberals win.';
    }
  }
}

/// Current status of a player in the game
enum PlayerStatus {
  alive('Alive'),
  executed('Executed'),
  disconnected('Disconnected');

  const PlayerStatus(this.displayName);

  final String displayName;
}

/// Special positions in the government
enum GovernmentPosition {
  president('President'),
  chancellor('Chancellor');

  const GovernmentPosition(this.displayName);

  final String displayName;
}

/// Voting options during elections
enum Vote {
  ja('Ja!'),
  nein('Nein!');

  const Vote(this.displayName);

  final String displayName;
}

/// Game end conditions and winning teams
enum GameResult {
  liberalPolicyVictory('Liberal Policy Victory'),
  fascistPolicyVictory('Fascist Policy Victory'),
  hitlerElectedVictory('Hitler Elected Victory'),
  hitlerAssassinatedVictory('Hitler Assassinated Victory');

  const GameResult(this.displayName);

  final String displayName;

  /// Which team wins with this result
  GameRole get winningTeam {
    switch (this) {
      case GameResult.liberalPolicyVictory:
      case GameResult.hitlerAssassinatedVictory:
        return GameRole.liberal;
      case GameResult.fascistPolicyVictory:
      case GameResult.hitlerElectedVictory:
        return GameRole.fascist;
    }
  }

  String get description {
    switch (this) {
      case GameResult.liberalPolicyVictory:
        return 'The Liberal team enacted five Liberal policies.';
      case GameResult.fascistPolicyVictory:
        return 'The Fascist team enacted six Fascist policies.';
      case GameResult.hitlerElectedVictory:
        return 'Hitler was elected Chancellor after three Fascist policies were enacted.';
      case GameResult.hitlerAssassinatedVictory:
        return 'Hitler was executed by the President.';
    }
  }
}

/// Game lobby states
enum LobbyState {
  waiting('Waiting for Players'),
  ready('Ready to Start'),
  starting('Starting Game'),
  inProgress('Game in Progress'),
  finished('Game Finished');

  const LobbyState(this.displayName);

  final String displayName;
}

/// Authentication states
enum AuthState {
  initial('Initial'),
  loading('Loading'),
  authenticated('Authenticated'),
  unauthenticated('Unauthenticated'),
  error('Error');

  const AuthState(this.displayName);

  final String displayName;
}

/// Game status in lobby and during gameplay
enum GameStatus {
  waiting('Waiting for Players'),
  ready('Ready to Start'),
  starting('Starting'),
  inProgress('In Progress'),
  finished('Finished'),
  cancelled('Cancelled');

  const GameStatus(this.displayName);

  final String displayName;
}

/// Teams in the game
enum Team {
  liberal('Liberal'),
  fascist('Fascist');

  const Team(this.displayName);

  final String displayName;
}

/// Game actions that players can take
enum GameAction {
  nominateChancellor('Nominate Chancellor'),
  vote('Vote'),
  presidentialDiscard('Presidential Discard'),
  chancellorDiscard('Chancellor Discard'),
  chancellorVeto('Chancellor Veto'),
  presidentialVeto('Presidential Veto Response'),
  policyPeek('Policy Peek'),
  investigateLoyalty('Investigate Loyalty'),
  specialElection('Special Election'),
  execution('Execution');

  const GameAction(this.displayName);

  final String displayName;
}
