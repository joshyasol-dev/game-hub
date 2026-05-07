import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bybet_mini/presentation/routes/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bybet_mini/bloc/game/game_bloc.dart';
import 'package:bybet_mini/data/repository/game_repo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  _configureWebViewPlatform();
  ScreenUtil.ensureScreenSize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(
    BlocProvider(
      create: (context) => GameBloc(gameRepository: GameRepository()),
      child: const MyApp(),
    ),
  );
}

void _configureWebViewPlatform() {
  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
    return;
  }
  if (Platform.isIOS) {
    WebViewPlatform.instance = WebKitWebViewPlatform();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: MaterialApp.router(
        title: 'Game Hub',
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
      ),
    );
  }
}
