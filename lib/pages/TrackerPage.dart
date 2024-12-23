import 'package:flutter/material.dart';

class HabitTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1E),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.nightlight_round, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Image and Text
              Center(
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/reading book habit.png'),
                      height: 150,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Reading Book',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Habits are fundamental part of our life. Make\n the most of your life!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Calendar
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Days Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: index < 4
                                ? Color(0xFF6A5ACD) // Progress Color
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.white54,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),

                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LegendItem(
                            color: Color(0xFF6A5ACD), text: 'All complete'),
                        LegendItem(
                            color: Colors.transparent, text: 'Not complete'),
                        LegendItem(color: Colors.purple, text: 'In progress'),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A5ACD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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

  LegendItem({
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
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
