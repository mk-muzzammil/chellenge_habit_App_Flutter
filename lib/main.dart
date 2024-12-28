import 'package:chellenge_habit_app/pages/AddNewChallenges.dart';
import 'package:chellenge_habit_app/pages/AuthenticationPage.dart';
import 'package:chellenge_habit_app/pages/ChallengesPage.dart';
import 'package:chellenge_habit_app/pages/HiddenChallengesPage.dart';
import 'package:chellenge_habit_app/pages/LogInPage.dart';
import 'package:chellenge_habit_app/pages/ProfileSetup.dart';
import 'package:chellenge_habit_app/pages/SignUpPage.dart';
import 'package:chellenge_habit_app/pages/TodayTaskPage.dart';
import 'package:chellenge_habit_app/pages/TrackerPage.dart';
import 'package:chellenge_habit_app/pages/dashboardPage.dart';
import 'package:chellenge_habit_app/pages/inAppPurchase.dart';
import 'package:chellenge_habit_app/pages/profilePage.dart';
import 'package:chellenge_habit_app/pages/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart'; // Import custom theme
import 'pages/SplashScreen.dart';
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
        '/home': (context) => HabitSelectionScreen(),
        '/start': (context) => HabitTrackerStarterScreen(),
        '/auth': (context) => AuthenticationPage(),
        '/signUp': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        "/profileSetup": (context) => ProfileSetupScreen(),
        '/notifications': (context) => NotificationTimePage(),
        '/premiumPackages': (context) => PremiumUpgradeScreen(),
        '/settings': (context) => SettingsScreen(),
        '/profile': (context) => ProfileScreen(),
        "/addChellenge": (context) => NewChallengePage(),
        "/hiddenChellenges": (context) => HiddenChallenges(),
        "/chellenges": (context) => ChallengesPage(),
        "/todayTask": (context) => TodayTaskPage(),
        "/tracker": (context) => HabitTrackerScreen(),
      },
    );
  }
}
