import 'package:bybet_mini/common/styles.dart';
import 'package:bybet_mini/common/widgets/all_game_widget.dart';
import 'package:bybet_mini/data/models/game_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameSearch extends SearchDelegate<GameData?> {
  final GameData data;

  GameSearch(this.data)
    : super(
        searchFieldStyle: TextStyle(
          color: AppStyles.textDarkModeColor,
          fontSize: 14.sp,
        ),
      );

  List<Game> get searchableGames {
    final allGames = [...data.featuredGames, ...data.newGames, ...data.games];
    // Remove duplicates by name
    final uniqueGames = {for (var game in allGames) game.name: game};
    return uniqueGames.values.toList();
  }

  TextStyle? get searchFieldStryle =>
      TextStyle(color: AppStyles.darkPrimaryColor, fontSize: 14.sp);

  String get seachFieldLabel => 'Search';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: AppStyles.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppStyles.darkHeaderNav,
        titleTextStyle: TextStyle(
          fontSize: 10.sp,
          color: AppStyles.darkPrimaryColor,
        ),
        iconTheme: IconThemeData(color: AppStyles.darkPrimaryColor),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppStyles.darkPrimaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: AppStyles.textDarkModeColor,
        ),
        outlineBorder: BorderSide(color: AppStyles.darkPrimaryColor),
        focusColor: AppStyles.darkPrimaryColor,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppStyles.darkPrimaryColor),
        ),
      ),
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
    // Remove duplicates already handled in searchableGames
    final suggestions = searchableGames.where((game) {
      return game.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return gameList(suggestions);
  }

  @override
  Widget buildResults(BuildContext context) {
    // Remove duplicates by name from all games
    final allGames = [...data.featuredGames, ...data.newGames, ...data.games];
    final uniqueGames = {
      for (var game in allGames) game.name: game,
    }.values.toList();
    final results = uniqueGames.where((game) {
      return game.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return gameList(results);
  }

  Widget gameList(List<Game> games) {
    if (games.isEmpty) {
      return Center(child: Text('No games found.'));
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        final game = games[index];
        return AllGameWidget(
          backgroundImg: game.backgroundImg,
          gameTitle: game.name,
          gameUrl: game.gameUrl,
          icon: game.imageUrl,
          ontap: () {},
        );
      },
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemCount: games.length,
    );
  }
}
