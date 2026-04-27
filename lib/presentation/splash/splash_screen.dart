import 'package:flutter/material.dart';
import 'package:game_hub/common/styles.dart';

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
            }
          });
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
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
    );
  }
}
