import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';

// Import the database service
import 'package:chellenge_habit_app/Services/databaseHandler.dart';
import 'package:intl/intl.dart'; // if needed for date formatting

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Retrieve challenge data from route arguments
    final Map<String, dynamic> challengeData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    // 2. Extract the fields you need
    final String title = challengeData['title'] ?? 'Unknown Challenge';
    final String description =
        challengeData['description'] ?? 'No description available';
    final String imageUrl =
        challengeData['imageUrl'] ?? 'assets/images/placeholder.png';

    final bool isStarted = challengeData['isStarted'] == true;
    final List<dynamic> tasksForDays = challengeData['tasksForDays'] ?? [];

    // We'll read the challenge startTime if it exists
    DateTime? startTime;
    if (challengeData['startTime'] != null) {
      startTime = DateTime.tryParse(challengeData['startTime']);
    }

    final _databaseService = DatabaseService();

    // A helper function to re-push the same TrackerPage with updated data
    Future<void> _refreshTrackerPage() async {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/tracker", arguments: {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'isStarted': true,
        'tasksForDays': tasksForDays.isNotEmpty
            ? tasksForDays
            : List.generate(18, (index) {
                return {
                  'day': index + 1,
                  'completed': false,
                };
              }),
        'startTime': startTime?.toIso8601String(),
      });
    }

    // Determine "day index" => how many days since challenge started?
    int currentDayIndex = 0;
    if (startTime != null) {
      final now = DateTime.now();
      currentDayIndex = now.difference(startTime).inDays;
      if (currentDayIndex < 0) {
        // If startTime is in the future, clamp to 0
        currentDayIndex = 0;
      } else if (currentDayIndex > 17) {
        // If we've gone beyond 18 days, clamp to last day
        currentDayIndex = 17;
      }
    }

    // Decide colors for each day
    Color _getDayColor(int index) {
      // 1) If tasksForDays[index].completed == true => Completed color
      bool isCompleted = false;
      if (index < tasksForDays.length) {
        isCompleted = tasksForDays[index]['completed'] ?? false;
      }

      if (isCompleted) {
        // completed
        return const Color(0xFF6A5ACD); // your completed color
      }

      // not completed => we check if it's the "current day" => In progress
      if (index == currentDayIndex) {
        // the day we are on => if not completed => in-progress color
        return Colors.purple; // in-progress
      }

      // if index < currentDayIndex => missed => not completed => transparent
      // if index > currentDayIndex => future => also transparent
      return Colors.transparent;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.darkPrimary),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/notifications',
                arguments: {
                  'title': title,
                  'description': description,
                },
              );
            },
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      drawer: CustomSidebar(userName: "Thao Lee"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Display dynamic image & challenge title
              Center(
                child: Column(
                  children: [
                    if (imageUrl.startsWith('http'))
                      Image.network(imageUrl, height: 150)
                    else
                      Image.asset(imageUrl, height: 150),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // If not started => show Start button
              // If started => show the 18-day grid & Continue button
              if (!isStarted) ...[
                Text(
                  'This challenge has not been started yet.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A5ACD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      // Call DB to start challenge
                      await _databaseService.startChallenge(title);

                      // Refresh or re-push the page to show the new state
                      await _refreshTrackerPage();
                    },
                    child: const Text(
                      'Start Challenge',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // If isStarted == true, show 18-day circle grid
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        // Show 18 days (or tasksForDays.length if you'd like to rely on DB)
                        itemCount:
                            tasksForDays.isNotEmpty ? tasksForDays.length : 18,
                        itemBuilder: (context, index) {
                          final dayColor = _getDayColor(index);

                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: dayColor,
                              border: Border.all(color: Colors.white54),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          LegendItem(
                            color: Color(0xFF6A5ACD),
                            text: 'All complete',
                          ),
                          LegendItem(
                            color: Colors.transparent,
                            text: 'Not complete',
                          ),
                          LegendItem(color: Colors.purple, text: 'In progress'),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A5ACD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Pass the challenge data, including startTime, to TodayTaskPage
                      Navigator.pushNamed(context, '/todayTask', arguments: {
                        'title': title,
                        'startTime': startTime?.toIso8601String(),
                      });
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: color == Colors.transparent
                ? Border.all(color: Colors.white54)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
