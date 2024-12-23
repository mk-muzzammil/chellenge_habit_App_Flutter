import 'package:flutter/material.dart';

class NotificationTimePage extends StatefulWidget {
  const NotificationTimePage({super.key});

  @override
  _NotificationTimePageState createState() => _NotificationTimePageState();
}

class _NotificationTimePageState extends State<NotificationTimePage> {
  int _selectedHour = 7; // Default selected hour (12-hour format)
  int _selectedMinute = 30; // Default selected minute
  bool _isAm = true; // Default to AM

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF6A5ACD), // Purple background color
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

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

            SizedBox(height: screenHeight * 0.02), // Responsive spacing

            // Cloud Image
            Center(
              child: Image.asset(
                'assets/images/Morning.png',
                height: screenHeight * 0.25, // Responsive height
              ),
            ),

            SizedBox(height: screenHeight * 0.06), // Responsive spacing

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
                  color: Color(0xFF1C1C1E), // Dark background for time picker
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
                        // Hour Picker (12-hour format)
                        _buildRecyclableTimeSlider(1, 12, _selectedHour,
                            (value) {
                          setState(() {
                            _selectedHour = value;
                          });
                        }),

                        // Separator
                        const Text(
                          ":",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        // Minute Picker
                        _buildRecyclableTimeSlider(0, 59, _selectedMinute,
                            (value) {
                          setState(() {
                            _selectedMinute = value;
                          });
                        }),

                        SizedBox(
                            width: screenWidth * 0.1), // Responsive spacing

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
                    // const Spacer(),
                    SizedBox(height: screenHeight * 0.05),

                    // Continue Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05, // Responsive padding
                        vertical: screenHeight * 0.02,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.07, // Responsive height
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5ACD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            print(
                                "Selected Time: ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} ${_isAm ? 'AM' : 'PM'}");
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
      int min, int max, int selectedValue, ValueChanged<int> onChanged) {
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
