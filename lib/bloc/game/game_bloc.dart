// ignore_for_file: avoid_print

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bybet_mini/common/constants.dart';
import 'package:bybet_mini/data/models/game_model.dart';
import 'package:bybet_mini/data/repository/game_repo.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository gameRepository;

  GameBloc({required this.gameRepository}) : super(const GameInitial()) {
    on<FetchGamesEvent>(_onFetchGames);
    on<RefreshGames>(_refreshGames);
  }

  /// Handler for FetchGamesEvent
  Future<void> _onFetchGames(
    FetchGamesEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(const GameLoading());

    try {
      final response = await gameRepository.getGames(
        featuredLimit: event.featuredLimit,
        newLimit: event.newLimit,
      );

      print('API Response Type: ${response.runtimeType}'); // Debug log
      print('API Response: $response'); // Debug log

      // Extract data field from the response
      if (!response.containsKey('data')) {
        throw Exception('Invalid API response: missing "data" field');
      }

      final data = response['data'] as Map<String, dynamic>;
      print('Data field: $data'); // Debug log

      final gameData = GameData.fromJson(data);
      print('Game Data: $gameData');
      emit(GameLoaded(gameData));
    } catch (e) {
      print('Error in _onFetchGames: $e'); // Debug log
      emit(GameError(e.toString()));
    }
  }

  Future<void> _refreshGames(RefreshGames event, Emitter<GameState> emit) async {
    emit(const GameLoading());
    try {
      print('Refreshing state: $state');
      if (state is GameLoaded) {
        print('What state: $state');
        final currentState = state as GameLoaded;

        emit(currentState.copyWith(isRefreshing: true));

        final response = await gameRepository.getGames(
          featuredLimit: defaultFeaturedLimit,
          newLimit: defaultNewLimit,
        );

        if(!response.containsKey('data')){
          throw Exception('Invalid API response');
        }

        final data = response['data'] as Map<String,dynamic>;
        final gameData = GameData.fromJson(data);

        emit(GameLoaded(gameData, isRefreshing: false));
      }
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }
}
