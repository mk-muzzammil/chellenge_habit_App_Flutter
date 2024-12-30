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
    // We will show the day number in the UI
    final dayNumber = _currentDayIndex + 1;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  // Day X
                  Text(
                    'Day $dayNumber',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Right icons (edit, etc.)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_food_beverage,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Today's Task Header
              const Center(
                child: Text(
                  "It's your today's task...",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white54),
                  ),
                  child: const Center(
                    child: Text(
                      'Habits are fundamental part of our life.\nMake the most of your life!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF6A5ACD),
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
                        backgroundColor: const Color(0xFF2C2C2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Share',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.white,
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
                        backgroundColor: const Color(0xFF2C2C2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Skip Scratch',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.white,
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
