import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/firebase_options.dart';
import 'package:jolu_trip/screens/auth/login-screen.dart';

import 'package:jolu_trip/screens/category-screen.dart';
import 'package:jolu_trip/screens/feed_screen.dart';
import 'package:jolu_trip/screens/main-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jolu Trip',
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      themeAnimationCurve: Curves.easeInOut,
      themeAnimationDuration: const Duration(milliseconds: 500),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/search': (context) => const SearchScreen(),
        '/login': (context) => AuthScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/video-feed') {
          final locationId = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => FeedScreen(
              initialLocationId: locationId,
            ),
          );
        }
        return null;
      },
    );
  }
}
