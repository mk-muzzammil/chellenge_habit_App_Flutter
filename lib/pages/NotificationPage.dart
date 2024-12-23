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
    return Scaffold(
      backgroundColor: const Color(0xFF6A5ACD), // Purple background color
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

            // Title
            const Center(
              child: Text(
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

            // Cloud Image
            Center(
              child: Image.asset(
                'assets/images/Morning.png',
                height: 200,
              ),
            ),

            const SizedBox(height: 20),

            // Time Selector
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1E), // Dark background for time picker
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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

                        const SizedBox(width: 10),

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
                    const Spacer(),

                    // Continue Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: SizedBox(
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
