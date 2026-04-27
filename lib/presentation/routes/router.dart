import 'package:game_hub/presentation/home/home_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen())
  ]
);