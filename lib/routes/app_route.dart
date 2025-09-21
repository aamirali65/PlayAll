import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/player/player_screen.dart';
import '../data/models/media_file.dart';


class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/player',
        builder: (context, state) {
          final media = state.extra as MediaFile;
          return PlayerScreen(media: media);
        },
      ),
    ],
  );
}