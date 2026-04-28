import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_hub/presentation/routes/router.dart';
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
  runApp(const MyApp());
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
