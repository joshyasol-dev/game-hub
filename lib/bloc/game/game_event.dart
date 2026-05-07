part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch games from the API
class FetchGamesEvent extends GameEvent {
  final int featuredLimit;
  final int newLimit;

  const FetchGamesEvent({
    this.featuredLimit = defaultFeaturedLimit,
    this.newLimit = defaultNewLimit,
  });

  @override
  List<Object> get props => [featuredLimit, newLimit];
}

class RefreshGames extends GameEvent {}
