import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:weatherapp/splashScreen/splash_screen.dart';

import '../home/home_screen.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
      path: '/',
      name: "SplashScreen",
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: [
        GoRoute(
          path: 'HomeScreen',
          name: 'HomeScreen',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
      ])
]);
