import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:chellenge_habit_app/Services/databaseHandler.dart';

class TodayTaskPage extends StatefulWidget {
  const TodayTaskPage({super.key});

  @override
  State<TodayTaskPage> createState() => _TodayTaskPageState();
}

class _TodayTaskPageState extends State<TodayTaskPage> {
  final DatabaseService _databaseService = DatabaseService();

  String? _challengeTitle;
  DateTime? _startTime;
  int _currentDayIndex = 0; // 0-based => "Day 1" is index 0

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve data passed from TrackerPage (or wherever you navigate from).
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _challengeTitle = args['title'];
      final String? startTimeStr = args['startTime'];
      if (startTimeStr != null) {
        _startTime = DateTime.tryParse(startTimeStr);
      }
    }

    // Compute which day index the user is on based on startTime
    if (_startTime != null) {
      final now = DateTime.now();
      final diffDays = now.difference(_startTime!).inDays;
      // clamp to 0..17
      if (diffDays < 0) {
        _currentDayIndex = 0;
      } else if (diffDays > 17) {
        _currentDayIndex = 17;
      } else {
        _currentDayIndex = diffDays;
      }
    }
  }

  Future<void> _completeTodayTask() async {
    // If there's no challenge title, do nothing
    if (_challengeTitle == null) return;

    // Mark the current day (0-based index) as completed in Firebase
    await _databaseService.completeDayTask(_challengeTitle!, _currentDayIndex);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Day ${_currentDayIndex + 1} completed!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // We will show the day number in the UI
    final dayNumber = _currentDayIndex + 1;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: CustomSidebar(userName: "Thao Lee"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back arrow
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                  ),
                  // Day X
                  Text(
                    'Day $dayNumber',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Right icons (edit, etc.)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: theme.iconTheme.color),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.emoji_food_beverage,
                            color: theme.iconTheme.color),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Today's Task Header
              Center(
                child: Text(
                  "It's your today's task...",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Task Box
              Center(
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Center(
                    child: Text(
                      'Habits are fundamental part of our life.\nMake the most of your life!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Buttons row (Share / Skip)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Share logic (if any)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Share',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Skip logic (if any)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Skip Scratch',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Footer / "Challenge completed" button
              InkWell(
                onTap: _completeTodayTask,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A5ACD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.emoji_food_beverage, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Challenge completed',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
