import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_hub/common/styles.dart';
import 'package:game_hub/common/widgets/game_builder.dart';
import 'package:game_hub/presentation/game/web_game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
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
                Text(
                  '🔥 Featured',
                  style: TextStyle(
                    color: AppStyles.textLightModeColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      4,
                      (index) => buildGameContainer(
                        'assets/icons/${['tekhen', 'nf', 'ph', 'bf'][index]}_icon.png',
                        AppStyles.secondaryColor,
                        'assets/images/${['kok_bg', 'bg_basket', 'hammer_bg', 'bingo_bg'][index]}.png',
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WebGameScreen(
                                loadingIcon: 'assets/icons/${['tekhen', 'nf', 'ph', 'bf'][index]}_icon.png',
                                backgroundImage:
                                    'assets/images/${const ['kok_bg', 'bg_basket', 'hammer_bg', 'bingo_bg'][index]}.png',
                                    customUrl: ['http://10.80.4.28:5173/','http://10.80.4.28:5172/','http://10.80.4.28:1573/','http://10.80.4.28:1574/'][index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  '🎰 Newest Games',
                  style: TextStyle(
                    color: AppStyles.textLightModeColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
