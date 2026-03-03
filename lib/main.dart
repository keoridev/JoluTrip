import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/firebase_options.dart';
import 'package:jolu_trip/screens/feed_screen.dart';

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

  await migrateLocations();
}

Future<void> migrateLocations() async {
  final oldCollection = FirebaseFirestore.instance.collection('locatons');

  final newCollection = FirebaseFirestore.instance.collection('locations');

  final snapshot = await oldCollection.get();

  for (var doc in snapshot.docs) {
    await newCollection.doc(doc.id).set(doc.data());
  }

  print('Migration completed');
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.dark;
  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

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
      home: FeedScreen(
        onThemeToggle: _toggleTheme,
      ),
      routes: {
        // '/detail-screen': (context) => DetailsScreen(locationId: location.id)
      },
    );
  }
}
