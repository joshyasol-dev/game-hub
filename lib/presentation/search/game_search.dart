import 'package:bybet_mini/common/styles.dart';
import 'package:bybet_mini/common/widgets/all_game_widget.dart';
import 'package:bybet_mini/data/models/game_model.dart';
import 'package:bybet_mini/presentation/game/web_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameSearch extends SearchDelegate<GameData?> {
  final GameData data;

  static const List<String> staticIcons = ['tekhen', 'nf', 'ph', 'bf'];
  static const List<String> staticBgs = [
    'kok_bg',
    'bg_basket',
    'hammer_bg',
    'bingo_bg',
  ];
  static const List<String> staticUrls = [];

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

    final gamed = games.where((game) => game.isMobile == 'True').toList();
    return ListView.separated(
      itemBuilder: (context, index) {
        final gameList = gamed[index];
        return AllGameWidget(
          backgroundImg: gameList.backgroundImg,
          gameTitle: gameList.name,
          gameUrl: gameList.gameUrl,
          icon: gameList.imageUrl,
          ontap: () => _navigateToGame(
            context,
            games.isNotEmpty
                ? gameList.imageUrl
                : 'assets/icons/${staticIcons[index]}_icon.png',
            gameList.backgroundImg.isNotEmpty
                ? gameList.backgroundImg
                : 'assets/images/${staticBgs[index]}.png',
            gameList.gameUrl,
            gameList.isLandScape,
            'allgames',
            games,
          ), desc: gameList.description,
        );
      },
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemCount: gamed.length,
    );
  }

  /// Navigate to the game screen
  void _navigateToGame(
    BuildContext context,
    String loadingIcon,
    String backgroundImage,
    String customUrl,
    String islandscape,
    String gameCategory,
    List<Game> gameData,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebGameScreen(
          loadingIcon: loadingIcon,
          backgroundImage: backgroundImage,
          customUrl: customUrl,
          islandscape: islandscape,
          gameCategory: gameCategory,
          game: gameData,
        ),
      ),
    );
  }
}
