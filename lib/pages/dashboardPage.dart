import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';

class HabitSelectionScreen extends StatelessWidget {
  final String userName;

  const HabitSelectionScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: CustomSidebar(userName: userName), // Use CustomSidebar for drawer
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/icons/Avatar.png',
                  width: 32, // Increased size for visibility
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addChellenge');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: AppColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, userName),
              const SizedBox(height: 16),
              Text(
                'Choose first habit you want\nto build',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _HabitCard(
                      title: 'Exercise',
                      status: 'Not Started',
                      imagePath: 'assets/images/excercise.png',
                      color: AppColors.primary,
                      onTap: () {
                        // Handle card tap for Exercise
                        Navigator.pushNamed(context, "/tracker");
                      },
                    ),
                    _HabitCard(
                      title: 'Reading Book',
                      status: '5/20',
                      imagePath: 'assets/images/readingBook.png',
                      color: AppColors.skyBlue,
                      onTap: () {
                        // Handle card tap for Reading Book
                        Navigator.pushNamed(context, "/tracker");
                      },
                    ),
                    _HabitCard(
                      title: 'Write Diary',
                      status: 'Not Started',
                      imagePath: 'assets/images/slider_4.png',
                      color: AppColors.lightPink,
                      onTap: () {
                        // Handle card tap for Write Diary
                        Navigator.pushNamed(context, "/tracker");
                      },
                    ),
                    _HabitCard(
                      title: 'Walking',
                      status: '5/20',
                      imagePath: 'assets/images/walking.png',
                      color: AppColors.primaryLight,
                      onTap: () {
                        // Handle card tap for Walking
                        Navigator.pushNamed(context, "/tracker");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              children: [
                const TextSpan(text: 'Hello,\n'),
                TextSpan(
                  text: name,
                  style: const TextStyle(height: 1.2),
                ),
                const TextSpan(text: ' 👋'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HabitCard extends StatelessWidget {
  final String title;
  final String status;
  final String imagePath;
  final Color color;
  final VoidCallback onTap; // Added onTap to make the card clickable

  const _HabitCard({
    required this.title,
    required this.status,
    required this.imagePath,
    required this.color,
    required this.onTap, // Required parameter for tap callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Executes the onTap callback when the card is tapped
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      color: status.contains('/')
                          ? color
                          : AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
