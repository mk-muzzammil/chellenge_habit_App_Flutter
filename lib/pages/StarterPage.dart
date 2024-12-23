import 'package:flutter/material.dart';

class HabitTrackerStarterScreen extends StatelessWidget {
  const HabitTrackerStarterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Illustration
              Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/illustration.png', // Add your image path here
                      height: 300,
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Title Text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Habit tracker 🙌",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "The best time to start is now!",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "You’re taking the first step in changing your life.\nLet us guide you through it.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              // const Spacer(),
              const SizedBox(height: 30),
              // Bottom Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to the next page
                  Navigator.pushNamed(context, '/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Let’s do it",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
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
