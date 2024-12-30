import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';

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

    final List<dynamic> tasksForDays = challengeData['tasksForDays'] ?? [];

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
        actions: [
          // ---- IMPORTANT: PASS BOTH TITLE & DESCRIPTION HERE ----
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.nightlight_round, color: Colors.white),
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
                      // either show tasksForDays.length or 30 if not known
                      itemCount:
                          tasksForDays.isNotEmpty ? tasksForDays.length : 30,
                      itemBuilder: (context, index) {
                        bool isCompleted = index < 4; // dummy logic
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? const Color(0xFF6A5ACD)
                                : Colors.transparent,
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
                    Navigator.pushNamed(context, '/todayTask');
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
