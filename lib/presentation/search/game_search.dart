import 'package:bybet_mini/common/styles.dart';
import 'package:bybet_mini/common/widgets/all_game_widget.dart';
import 'package:bybet_mini/data/models/game_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameSearch extends SearchDelegate<GameData?> {
  final GameData data;

  GameSearch(this.data);

  List<Game> get searchableGames => [
    ...data.featuredGames,
    ...data.newGames,
    ...data.games,
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: AppStyles.darkBackground,
      appBarTheme: const AppBarTheme(backgroundColor: AppStyles.darkHeaderNav),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(LucideIcons.x),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(LucideIcons.move_left),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = searchableGames.where((game) {
      return game.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return gameList(suggestions);
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchableGames.where((game) {
      return game.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return gameList(results);
  }

  Widget gameList(List<Game> games) {
    if (games.isEmpty) {
      return Center(child: Text('No games found.'));
    }
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          games.length,
          (index) => Column(
            children: [
              AllGameWidget(
                backgroundImg: games[index].backgroundImg,
                gameTitle: games[index].name,
                gameUrl: games[index].gameUrl,
                icon: games[index].imageUrl,
                ontap: () {},
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
