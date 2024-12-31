import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:chellenge_habit_app/Services/databaseHandler.dart';

class NotificationTimePage extends StatefulWidget {
  const NotificationTimePage({Key? key}) : super(key: key);

  @override
  _NotificationTimePageState createState() => _NotificationTimePageState();
}

class _NotificationTimePageState extends State<NotificationTimePage> {
  int _selectedHour = 7;
  int _selectedMinute = 30;
  bool _isAm = true;

  // Instantiate your DatabaseService
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Retrieve the challenge data from route arguments
    final Map<String, dynamic> challengeData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    // If not provided, fallback to 'Default Challenge'
    final String challengeTitle = challengeData['title'] ?? 'Default Challenge';

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Let the theme handle background:
      backgroundColor: AppColors.darkPrimary,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: CustomSidebar(userName: "Thao Lee"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Text(
                  "What time do you\nSet notification?",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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

            // Time Selector (in a darker container, if you like)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.06),

                    // Hour : Minute + AM/PM
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Hour Picker (1-12)
                        _buildRecyclableTimeSlider(
                          min: 1,
                          max: 12,
                          selectedValue: _selectedHour,
                          onChanged: (value) {
                            setState(() {
                              _selectedHour = value;
                            });
                          },
                          theme: theme,
                        ),
                        Text(
                          ":",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Minute Picker (0-59)
                        _buildRecyclableTimeSlider(
                          min: 0,
                          max: 59,
                          selectedValue: _selectedMinute,
                          onChanged: (value) {
                            setState(() {
                              _selectedMinute = value;
                            });
                          },
                          theme: theme,
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
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _isAm
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodyLarge?.color,
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
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: !_isAm
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodyLarge?.color,
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
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            // Debug Print
                            print(
                              "Selected Time: ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} "
                              "${_isAm ? 'AM' : 'PM'} for Challenge: $challengeTitle",
                            );

                            // 1. Save time to Firebase
                            await _databaseService
                                .saveChallengeNotificationTime(
                              challengeTitle,
                              _selectedHour,
                              _selectedMinute,
                              _isAm,
                            );

                            // 2. Schedule local notification
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
                            // Optionally navigate or pop...
                            // Navigator.pop(context);
                          },
                          child: Text(
                            'Continue',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary,
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

  Widget _buildRecyclableTimeSlider({
    required int min,
    required int max,
    required int selectedValue,
    required ValueChanged<int> onChanged,
    required ThemeData theme,
  }) {
    return SizedBox(
      width: 80,
      height: 200,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        perspective: 0.005,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          final int value = min + (index % (max - min + 1));
          onChanged(value);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final int value = min + (index % (max - min + 1));
            return Center(
              child: Text(
                value.toString().padLeft(2, '0'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  // If selected, highlight with primary; else default text color
                  color: (value == selectedValue)
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodyLarge?.color,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
