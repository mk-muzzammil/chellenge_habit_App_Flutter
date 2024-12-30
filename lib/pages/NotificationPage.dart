import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:chellenge_habit_app/Services/databaseHandler.dart';

class NotificationTimePage extends StatefulWidget {
  const NotificationTimePage({super.key});

  @override
  _NotificationTimePageState createState() => _NotificationTimePageState();
}

class _NotificationTimePageState extends State<NotificationTimePage> {
  int _selectedHour = 7; // Default selected hour (12-hour format)
  int _selectedMinute = 30;
  bool _isAm = true;

  // Instantiate your DatabaseService
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    // Retrieve the challenge data from route arguments
    final Map<String, dynamic> challengeData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    // If not provided, fallback to 'Default Challenge'
    final String challengeTitle = challengeData['title'] ?? 'Default Challenge';

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
      backgroundColor: const Color(0xFF6A5ACD), // Purple background color
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: const Text(
                  "What time do you\nSet notification?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Cloud Image
            Center(
              child: Image.asset(
                'assets/images/Morning.png',
                height: screenHeight * 0.25, // Responsive height
              ),
            ),

            SizedBox(height: screenHeight * 0.06),

            // Time Selector
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF6A5ACD),
                      width: 2,
                    ),
                  ),
                  color: Color(0xFF1C1C1E), // Dark background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Hour Picker (1-12)
                        _buildRecyclableTimeSlider(
                          1,
                          12,
                          _selectedHour,
                          (value) {
                            setState(() {
                              _selectedHour = value;
                            });
                          },
                        ),

                        const Text(
                          ":",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        // Minute Picker (0-59)
                        _buildRecyclableTimeSlider(
                          0,
                          59,
                          _selectedMinute,
                          (value) {
                            setState(() {
                              _selectedMinute = value;
                            });
                          },
                        ),

                        SizedBox(width: screenWidth * 0.1),

                        // AM/PM Toggle
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isAm = true;
                                });
                              },
                              child: Text(
                                "AM",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _isAm
                                      ? const Color(0xFF6A5ACD)
                                      : Colors.white,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isAm = false;
                                });
                              },
                              child: Text(
                                "PM",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: !_isAm
                                      ? const Color(0xFF6A5ACD)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // Continue Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.07,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5ACD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            // For debugging
                            print(
                              "Selected Time: ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} "
                              "${_isAm ? 'AM' : 'PM'} "
                              "for Challenge: $challengeTitle",
                            );

                            // 1. Save the chosen time to Firebase
                            await _databaseService
                                .saveChallengeNotificationTime(
                              challengeTitle,
                              _selectedHour,
                              _selectedMinute,
                              _isAm,
                            );

                            // 2. Schedule notification with Title + Hardcoded CTA
                            await _databaseService
                                .scheduleChallengeNotification(
                              challengeTitle,
                              _selectedHour,
                              _selectedMinute,
                              _isAm,
                            );

                            // 3. Show a snackbar
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Daily notification set for "$challengeTitle" at '
                                  '${_selectedHour.toString().padLeft(2, '0')}:'
                                  '${_selectedMinute.toString().padLeft(2, '0')} '
                                  '${_isAm ? 'AM' : 'PM'}!',
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );

                            // Optionally pop or navigate
                            // Navigator.pop(context);
                          },
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecyclableTimeSlider(
    int min,
    int max,
    int selectedValue,
    ValueChanged<int> onChanged,
  ) {
    return SizedBox(
      width: 80,
      height: 200,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          int value = min + (index % (max - min + 1));
          onChanged(value);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            int value = min + (index % (max - min + 1));
            return Center(
              child: Text(
                value.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: value == selectedValue
                      ? const Color(0xFF6A5ACD)
                      : Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
