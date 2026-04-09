import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/firebase_options.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/providers/locale_provider.dart';
import 'package:jolu_trip/providers/theme_provider.dart';
import 'package:jolu_trip/screens/auth/login-screen.dart';
import 'package:jolu_trip/screens/category-screen.dart';
import 'package:jolu_trip/screens/favorites_screen.dart';
import 'package:jolu_trip/screens/feed_screen.dart';
import 'package:jolu_trip/screens/main-screen.dart';
import 'package:jolu_trip/screens/profile-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(ProviderScope(
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    final locale = ref.watch(localeProvider);

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      title: 'Jolu Trip',
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      themeAnimationCurve: Curves.easeInOutSine,
      themeAnimationDuration: const Duration(milliseconds: 400),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/search': (context) => const SearchScreen(),
        '/auth': (context) => const AuthScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/favorites': (context) => FavoritesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/video-feed') {
          final locationId = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => FeedScreen(initialLocationId: locationId),
          );
        }
        return null;
      },
    );
  }
}
