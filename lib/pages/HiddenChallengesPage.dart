import 'package:flutter/material.dart';

class HiddenChallenges extends StatefulWidget {
  const HiddenChallenges({super.key});

  @override
  _HiddenChallengesState createState() => _HiddenChallengesState();
}

class _HiddenChallengesState extends State<HiddenChallenges> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> challenges = [
      {
        "title": "Read Book",
        "subtitle": "Focus",
        "progress": 0.5,
        "current": 10,
        "total": 20,
        "icon": "assets/images/01.png",
      },
      {
        "title": "Drink Water",
        "subtitle": "Detox",
        "progress": 0.25,
        "current": 5,
        "total": 20,
        "icon": "assets/images/01.png",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hidden Challenges"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            return ChallengeCard(
              title: challenge["title"],
              subtitle: challenge["subtitle"],
              progress: challenge["progress"],
              current: challenge["current"],
              total: challenge["total"],
              iconPath: challenge["icon"],
            );
          },
        ),
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final int current;
  final int total;
  final String iconPath;

  const ChallengeCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.current,
    required this.total,
    required this.iconPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        iconPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 8.0), // For horizontal space
                SizedBox(height: 8.0), // For vertical space
                // Progress Bar
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[800],
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                // Current and Total
                Text(
                  "$current/$total",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Eye Icon
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(
                Icons.visibility,
                color: Colors.white,
              ),
              onPressed: () {
                // Logic for visibility toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$title visibility toggled"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
