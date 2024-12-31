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
  String? _dayTask;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializePageData();
  }

  Future<void> _initializePageData() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _challengeTitle = args['title'];
      final String? startTimeStr = args['startTime'];
      if (startTimeStr != null) {
        _startTime = DateTime.tryParse(startTimeStr);
      }
    }

    if (_startTime != null) {
      final now = DateTime.now();
      final diffDays = now.difference(_startTime!).inDays;
      _currentDayIndex = (diffDays < 0)
          ? 0
          : (diffDays > 17)
              ? 17
              : diffDays;
    }

    if (_challengeTitle != null) {
      _dayTask = await _databaseService.fetchDayTask(
          _challengeTitle!, _currentDayIndex);
      setState(() {}); // Refresh the UI after fetching the task
    }
  }

  Future<void> _completeTodayTask() async {
    if (_challengeTitle == null) return;

    await _databaseService.completeDayTask(_challengeTitle!, _currentDayIndex);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                  ),
                  Text(
                    'Day $dayNumber',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      _dayTask ?? 'Loading today\'s task...',
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
                        'Mark As Completed',
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
