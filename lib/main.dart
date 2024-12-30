import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Themes
import 'theme/app_theme.dart' show lightTheme, darkTheme;

// Pages
import 'pages/SplashScreen.dart';
import 'pages/StarterPage.dart';
import 'pages/NotificationPage.dart';
import 'pages/AuthenticationPage.dart';
import 'pages/SignUpPage.dart';
import 'pages/LogInPage.dart';
import 'pages/ProfileSetup.dart';
import 'pages/inAppPurchase.dart';
import 'pages/profilePage.dart';
import 'pages/AddNewChallenges.dart';
import 'pages/HiddenChallengesPage.dart';
import 'pages/ChallengesPage.dart';
import 'pages/TodayTaskPage.dart';
import 'pages/TrackerPage.dart';
import 'pages/dashboardPage.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:chellenge_habit_app/pages/settingsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    null, // Use default icon for notifications (ensure you have one in your drawable folder)
    [
      NotificationChannel(
        channelKey: 'challenge_reminder',
        channelName: 'Challenge Reminders',
        channelDescription: 'Channel for daily challenge reminders',
        defaultColor: Colors.deepPurple,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
  );

  // Request notification permission (optional)
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Tracks whether the app should be in dark mode or light mode
  bool isDarkMode =
      true; // Default: Dark. Set to false if you want Light by default

  /// Method that toggles the theme; called from SettingsScreen
  void toggleTheme(bool enableDark) {
    setState(() {
      isDarkMode = enableDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Challenge Habit App',

      // Provide both light and dark themes
      theme: lightTheme,
      darkTheme: darkTheme,

      // Dynamically pick which theme to use
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => const HabitSelectionScreen(),
        '/start': (context) => HabitTrackerStarterScreen(),
        '/auth': (context) => AuthenticationPage(),
        '/signUp': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/profileSetup': (context) => ProfileSetupScreen(),
        '/notifications': (context) => NotificationTimePage(),
        '/premiumPackages': (context) => PremiumUpgradeScreen(),
        '/settings': (context) => SettingsScreen(
              isDarkMode: isDarkMode,
              onDarkModeToggled: toggleTheme,
            ),
        '/profile': (context) => ProfileScreen(),
        "/addChellenge": (context) => NewChallengePage(),
        "/hiddenChellenges": (context) => HiddenChallenges(),
        "/chellenges": (context) => ChallengesPage(),
        // The main Habit dashboard
        "/todayTask": (context) => TodayTaskPage(),
        "/tracker": (context) => HabitTrackerScreen(),
      },
    );
  }
}
