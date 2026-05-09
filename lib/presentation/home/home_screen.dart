// ignore_for_file: deprecated_member_use, dead_null_aware_expression, dead_code, avoid_print

import 'package:bybet_mini/data/models/game_model.dart';
import 'package:bybet_mini/presentation/search/game_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bybet_mini/bloc/game/game_bloc.dart';
import 'package:bybet_mini/common/styles.dart';
import 'package:bybet_mini/common/widgets/all_game_widget.dart';
import 'package:bybet_mini/common/widgets/game_builder.dart';
import 'package:bybet_mini/common/widgets/shimmer_loader.dart';
//import 'package:bybet_mini/data/models/game_model.dart';
import 'package:bybet_mini/data/repository/game_repo.dart';
import 'package:bybet_mini/presentation/game/web_game_screen.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Static fallback data in case API fails
  static const List<String> staticIcons = ['tekhen', 'nf', 'ph', 'bf'];
  static const List<String> staticBgs = [
    'kok_bg',
    'bg_basket',
    'hammer_bg',
    'bingo_bg',
  ];
  static const List<String> staticUrls = [
    'http://10.80.4.28:5164/',
    'http://10.80.4.28:5165/',
    'http://10.80.4.28:5166/',
    'http://10.80.4.28:5167/',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GameBloc(gameRepository: GameRepository())
            ..add(const FetchGamesEvent()),
      child: Scaffold(
        backgroundColor: AppStyles.darkBackground,
        appBar: AppBar(
          backgroundColor: AppStyles.darkHeaderNav,
          centerTitle: false,
          title: Row(
            children: [
              Image.asset('assets/images/bybet-logo-dark.png', height: 24.h),
              Text(
                '  mini',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppStyles.darkPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                //print('What state: $state');
                return IconButton(
                  onPressed: () {
                    if (state is GameLoaded) {
                      showSearch(
                        context: context,
                        delegate: GameSearch(state.gameData),
                      );
                    }
                  },
                  icon: Icon(
                    LucideIcons.search,
                    color: AppStyles.darkPrimaryColor,
                  ),
                );
              },
            ),
          ],
          actionsPadding: .only(right: 12.w),
          shadowColor: Colors.black12,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: RefreshIndicator(
              onRefresh: () async {
                //print('Pulled to refresh');
                // Trigger a refresh by re-fetching games
                context.read<GameBloc>().add(RefreshGames());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  //print('What state: $state');
                  // Show a refresh indicator overlay if refreshing
                  final bool isRefreshing =
                      state is GameLoaded && (state.isRefreshing ?? false);
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24.h),
                            // Ads Banner
                            Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/ads.png'),
                                  fit: BoxFit.fitWidth,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                                border: Border(
                                  top: BorderSide(
                                    color: AppStyles.darkPrimaryColor,
                                    width: 3.5,
                                  ),
                                ),
                              ),
                              height: 120.h,
                              width: double.infinity,
                            ),
                            SizedBox(height: 24.h),
                            // Featured Section
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.chess_queen,
                                  color: AppStyles.darkPrimaryColor,
                                ),
                                Text(
                                  ' Featured',
                                  style: TextStyle(
                                    color: AppStyles.darkPrimaryColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            _buildFeaturedGamesSection(state),
                            SizedBox(height: 24.h),
                            // Newest Games Section
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.dice_5,
                                  color: AppStyles.darkPrimaryColor,
                                  fill: 1.0,
                                ),
                                Text(
                                  ' Newest Games',
                                  style: TextStyle(
                                    color: AppStyles.darkPrimaryColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            _buildNewestGamesSection(state),
                            SizedBox(height: 24.h),
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.gamepad_2,
                                  color: AppStyles.darkPrimaryColor,
                                  fill: 1.0,
                                ),
                                Text(
                                  ' All Games',
                                  style: TextStyle(
                                    color: AppStyles.darkPrimaryColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            _buildAllGames(state),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                      if (isRefreshing)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.2),
                            child: Center(
                              child: LottieBuilder.asset(
                                'assets/animations/refresh.json',
                                height: 80,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build featured games section with dynamic or static data
  Widget _buildFeaturedGamesSection(GameState state) {
    if (state is GameLoading) {
      return const FeaturedGamesShimmer();
    } else if (state is GameLoaded && state.isRefreshing == true) {
      return Center(
        child: LottieBuilder.asset(
          'assets/animations/refresh.json',
          height: 80,
        ),
      );
    } else if (state is GameLoaded && state.gameData.featuredGames.isNotEmpty) {
      final games = state.gameData.featuredGames
          .where((game) => game.isMobile == 'True')
          .toList();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(games.length, (index) {
            //print('List games: ${games[index].toJson()}');
            final game = games[index];
            final iconIndex = index % staticIcons.length;
            return buildGameContainer(
              state.gameData.featuredGames.isNotEmpty
                  ? game.imageUrl.toString()
                  : 'assets/icons/${staticIcons[iconIndex]}_icon.png',
              AppStyles.darkPrimaryColor,
              game.backgroundImg.isNotEmpty
                  ? game.backgroundImg
                  : 'assets/images/${staticBgs[iconIndex]}.png',
              () => _navigateToGame(
                context,
                games.isNotEmpty
                    ? game.imageUrl
                    : 'assets/icons/${staticIcons[iconIndex]}_icon.png',
                games.isNotEmpty
                    ? game.backgroundImg
                    : 'assets/images/${staticBgs[iconIndex]}.png',
                game.gameUrl,
                game.isLandScape,
                'featuredGame',
                state.gameData.featuredGames,
              ),
            );
          }),
        ),
      );
    } else {
      // Error state or initial state - show static games
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            staticIcons.length,
            (index) => buildGameContainer(
              'assets/icons/${staticIcons[index]}_icon.png',
              AppStyles.secondaryColor,
              'assets/images/${staticBgs[index]}.png',
              () => _navigateToGame(
                context,
                'assets/icons/${staticIcons[index]}_icon.png',
                'assets/images/${staticBgs[index]}.png',
                staticUrls[index],
                staticUrls[index].contains("5164") ? "true" : "false",
                'featuredGames',
                [],
              ),
            ),
          ),
        ),
      );
    }
  }

  /// Build newest games section with dynamic or static data
  Widget _buildNewestGamesSection(GameState state) {
    if (state is GameLoading) {
      return const NewestGamesShimmer();
    } else if (state is GameLoaded && state.isRefreshing == true) {
      return Center(
        child: LottieBuilder.asset(
          'assets/animations/refresh.json',
          height: 80,
        ),
      );
    } else if (state is GameLoaded && state.gameData.newGames.isNotEmpty) {
      final games = state.gameData.newGames
          .where((game) => game.isMobile == 'True')
          .toList();
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          //childAspectRatio: 0.50,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          final iconIndex = index % staticIcons.length;
          return GestureDetector(
            onTap: () => _navigateToGame(
              context,
              state.gameData.newGames.isNotEmpty
                  ? game.imageUrl
                  : 'assets/icons/${staticIcons[iconIndex]}_icon.png',
              game.backgroundImg.isNotEmpty
                  ? game.backgroundImg
                  : 'assets/images/${staticBgs[iconIndex]}.png',
              game.gameUrl,
              game.isLandScape,
              'newestgame',
              state.gameData.newGames,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: game.backgroundImg.isNotEmpty
                      ? NetworkImage(game.backgroundImg)
                      : AssetImage('assets/images/${staticBgs[iconIndex]}.png'),
                  fit: BoxFit.cover,
                  opacity: 10,
                  onError: (exception, stackTrace) {},
                ),
                color: AppStyles.darkPrimaryColor,
              ),
              child: Center(
                child: game.imageUrl.isNotEmpty
                    ? Image.network(game.imageUrl, height: 80.h)
                    : Image.asset(
                        'assets/icons/${staticIcons[iconIndex]}_icon.png',
                        height: 60.h,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.gamepad,
                          size: 60.sp,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          );
        },
      );
    } else {
      // Error state or initial state - show static games
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.75,
        ),
        itemCount: staticIcons.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _navigateToGame(
              context,
              'assets/icons/${staticIcons[index]}_icon.png',
              'assets/images/${staticBgs[index]}.png',
              staticUrls[index],
              staticUrls[index].contains("5164") ? "true" : "false",
              'newestgames',
              [],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: AssetImage('assets/images/${staticBgs[index]}.png'),
                  fit: BoxFit.cover,
                  opacity: 10,
                ),
                color: AppStyles.secondaryColor,
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/${staticIcons[index]}_icon.png',
                  height: 60.h,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildAllGames(GameState state) {
    if (state is GameLoading) {
      return const NewestGamesShimmer();
    } else if (state is GameLoaded && state.isRefreshing == true) {
      return Center(
        child: LottieBuilder.asset(
          'assets/animations/refresh.json',
          height: 80,
        ),
      );
    } else if (state is GameLoaded && state.gameData.games.isNotEmpty) {
      final games = state.gameData.games
          .where((game) => game.isMobile == 'True')
          .toList();
      return Column(
        children: List.generate(games.length, (index) {
          final game = games[index];
          final iconIndex = index % staticIcons.length;
          return AllGameWidget(
            backgroundImg: game.backgroundImg.isNotEmpty
                ? game.backgroundImg
                : 'assets/images/${staticBgs[iconIndex]}.png',
            gameTitle: game.name,
            gameUrl: game.gameUrl,
            icon: game.imageUrl.isNotEmpty
                ? game.imageUrl
                : 'assets/icons/${staticIcons[iconIndex]}_icon.png',
            ontap: () => _navigateToGame(
              context,
              state.gameData.games.isNotEmpty
                  ? state.gameData.games[index].imageUrl
                  : 'assets/icons/${staticIcons[iconIndex]}_icon.png',
              state.gameData.games[index].backgroundImg.isNotEmpty
                  ? state.gameData.games[index].backgroundImg
                  : 'assets/images/${staticBgs[iconIndex]}.png',
              game.gameUrl,
              state.gameData.games[index].isLandScape,
              'allgames',
              state.gameData.games,
            ),
            desc: game.description,
          );
        }),
      );
    } else {
      return Column(
        children: List.generate(staticIcons.length, (index) {
          return AllGameWidget(
            backgroundImg: 'assets/images/${staticBgs[index]}.png',
            gameTitle: 'Game ${index + 1}',
            gameUrl: staticUrls[index],
            icon: 'assets/icons/${staticIcons[index]}_icon.png',
            ontap: () => _navigateToGame(
              context,
              'assets/icons/${staticIcons[index]}_icon.png',
              'assets/images/${staticBgs[index]}.png',
              staticUrls[index],
              staticUrls[index].contains("5164") ? "true" : "false",
              'allgames',
              [],
            ),
            desc: '',
          );
        }),
      );
    }
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
