import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart'; // Import custom theme
import 'pages/SplashScreen.dart';
import 'pages/HomePage.dart';
import 'pages/NotificationPage.dart';
import 'pages/StarterPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Challenge Habit App',
      theme: appTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/start': (context) => HabitTrackerStarterScreen(),
        '/home': (context) => HomePage(title: "Home Page"),
        '/notifications': (context) => NotificationTimePage(),
      },
    );
  }
}
