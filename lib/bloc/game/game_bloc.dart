import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_hub/common/constants.dart';
import 'package:game_hub/data/models/game_model.dart';
import 'package:game_hub/data/repository/game_repo.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository gameRepository;

  GameBloc({required this.gameRepository}) : super(const GameInitial()) {
    on<FetchGamesEvent>(_onFetchGames);
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

      print('API Response: $response'); // Debug log
      final gameData = GameData.fromJson(response);
      emit(GameLoaded(gameData));
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }
}
