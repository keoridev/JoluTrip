import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jolu_trip/features/auth/presentation/pages/auth_page.dart';
import 'package:jolu_trip/features/favorites/presentation/pages/favorites_page.dart';
import 'package:jolu_trip/features/feed/presentation/pages/feed_page.dart';
import 'package:jolu_trip/features/home/presentation/pages/home_page.dart';
import 'package:jolu_trip/features/profile/presentation/pages/profile_page.dart';
import 'package:jolu_trip/features/search/presentation/pages/search_page.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/video-feed',
        builder: (context, state) {
          final locationId = state.extra as String?;
          return FeedPage(initialLocationId: locationId);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(state.error?.toString() ?? 'Navigation error'),
        ),
      );
    },
  );
}
