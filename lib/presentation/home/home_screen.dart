import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_hub/bloc/game/game_bloc.dart';
import 'package:game_hub/common/styles.dart';
import 'package:game_hub/common/widgets/game_builder.dart';
import 'package:game_hub/common/widgets/shimmer_loader.dart';
import 'package:game_hub/data/models/game_model.dart';
import 'package:game_hub/data/repository/game_repo.dart';
import 'package:game_hub/presentation/game/web_game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Static fallback data in case API fails
  static const List<String> staticIcons = ['tekhen', 'nf', 'ph', 'bf'];
  static const List<String> staticBgs = ['kok_bg', 'bg_basket', 'hammer_bg', 'bingo_bg'];
  static const List<String> staticUrls = [
    'http://10.80.4.28:5164/',
    'http://10.80.4.28:5165/',
    'http://10.80.4.28:5166/',
    'http://10.80.4.28:5167/',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(gameRepository: GameRepository())
        ..add(const FetchGamesEvent()),
      child: Scaffold(
        backgroundColor: AppStyles.primaryColor,
        appBar: AppBar(
          backgroundColor: AppStyles.darkPrimaryColor,
          title: Text(
            'My Games',
            style: TextStyle(fontSize: 24.sp, color: AppStyles.textDarkModeColor),
          ),
          shadowColor: Colors.black12,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  return Column(
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
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        height: 120.h,
                        width: double.infinity,
                      ),
                      SizedBox(height: 24.h),
                      // Featured Section
                      Text(
                        '🔥 Featured',
                        style: TextStyle(
                          color: AppStyles.textLightModeColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _buildFeaturedGamesSection(state),
                      SizedBox(height: 24.h),
                      // Newest Games Section
                      Text(
                        '🎰 Newest Games',
                        style: TextStyle(
                          color: AppStyles.textLightModeColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildNewestGamesSection(state),
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
    } else if (state is GameLoaded && state.gameData.featuredGames.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            state.gameData.featuredGames.length,
            (index) {
              final game = state.gameData.featuredGames[index];
              final iconIndex = index % staticIcons.length;
              return buildGameContainer(
                'assets/icons/${staticIcons[iconIndex]}_icon.png',
                AppStyles.secondaryColor,
                'assets/images/${staticBgs[iconIndex]}.png',
                () => _navigateToGame(
                  context,
                  'assets/icons/${staticIcons[iconIndex]}_icon.png',
                  'assets/images/${staticBgs[iconIndex]}.png',
                  game.gameUrl,
                ),
              );
            },
          ),
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
    } else if (state is GameLoaded && state.gameData.newGames.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.75,
        ),
        itemCount: state.gameData.newGames.length,
        itemBuilder: (context, index) {
          final game = state.gameData.newGames[index];
          final iconIndex = index % staticIcons.length;
          return GestureDetector(
            onTap: () => _navigateToGame(
              context,
              'assets/icons/${staticIcons[iconIndex]}_icon.png',
              'assets/images/${staticBgs[iconIndex]}.png',
              game.gameUrl,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: NetworkImage(game.imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
                color: AppStyles.secondaryColor,
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/${staticIcons[iconIndex]}_icon.png',
                  height: 60.h,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.gamepad, size: 60.sp, color: Colors.white),
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
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: AssetImage('assets/images/${staticBgs[index]}.png'),
                  fit: BoxFit.cover,
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

  /// Navigate to the game screen
  void _navigateToGame(
    BuildContext context,
    String loadingIcon,
    String backgroundImage,
    String customUrl,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebGameScreen(
          loadingIcon: loadingIcon,
          backgroundImage: backgroundImage,
          customUrl: customUrl,
        ),
      ),
    );
  }
}
