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
  final bool isRefreshing;

  const GameLoaded(this.gameData, {this.isRefreshing = false});

  GameLoaded copyWith({GameData? gameData, bool? isRefreshing}) {
    return GameLoaded(
      gameData ?? this.gameData,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object> get props => [gameData, isRefreshing];
}

/// Error state when there's an issue fetching games
class GameError extends GameState {
  final String message;

  const GameError(this.message);

  @override
  List<Object> get props => [message];
}
