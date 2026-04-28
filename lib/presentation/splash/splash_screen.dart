import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_hub/common/constants.dart';
import 'package:game_hub/common/styles.dart';
import 'package:game_hub/common/widgets/custom_loader.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isPlaying = false;
  int maxDuration = 10;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(
            vsync: this,
            duration: Duration(seconds: maxDuration),
          )
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isPlaying = false;
              context.go('/home');
            }
          });
          controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double val = (controller.value * maxDuration);
    return Scaffold(
      backgroundColor: AppStyles.darkPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                (val.toInt() * 10).toString(),
                style: TextStyle(color: Colors.white, fontSize: 50.sp),
              ),
              Text(
                ".${val.toStringAsFixed(1).substring(val.toString().indexOf(".") + 1)}",
                style: TextStyle(
                  color: AppStyles.primaryColor,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 50.h),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return Container(
                height: 160.h,
                width: 160.w,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CustomPaint(
                        painter: CustomLoader(
                          controller.value * maxDuration,
                          maxDuration.toDouble(),
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: RadialProgressPainter(
                        value: controller.value * maxDuration,
                        backGroundGradientColors: gradientColors,
                        minValue: 0,
                        maxValue: maxDuration.toDouble(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
