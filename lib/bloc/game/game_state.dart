part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

/// Initial state when the app starts
class GameInitial extends GameState {
  const GameInitial();
}

/// Loading state while fetching games
class GameLoading extends GameState {
  const GameLoading();
}

/// Success state when games are loaded
class GameLoaded extends GameState {
  final GameData gameData;

  const GameLoaded(this.gameData);

  @override
  List<Object> get props => [gameData];
}

/// Error state when there's an issue fetching games
class GameError extends GameState {
  final String message;

  const GameError(this.message);

  @override
  List<Object> get props => [message];
}
