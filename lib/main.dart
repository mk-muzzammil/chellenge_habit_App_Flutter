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

// 1. Import awesome_notifications
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    null, // Use default icon for notifications (ensure to add one in drawable folder for Android)
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

  // 3. Request notification permission at startup (optional)
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    // This will prompt a native dialog (especially on iOS).
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

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
        "/todayTask": (context) => const TodayTaskPage(),
        "/tracker": (context) => const HabitTrackerScreen(),
      },
    );
  }
}
