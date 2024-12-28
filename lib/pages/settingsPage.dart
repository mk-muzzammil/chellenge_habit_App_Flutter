import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = true; // Tracks Dark Mode state
  bool isNotificationSoundEnabled = true; // Tracks Notification Sound state
  bool isNotificationDisplayEnabled = true; // Tracks Notification Display state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text('Setting'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Image.asset("assets/images/Avatar.png"),
            ),
          ),
        ],
      ),
      drawer: CustomSidebar(userName: "Thao Lee"),
      body: Container(
        color: const Color(0xFF121212),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "Chage Mode"),
            SwitchListTile(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
              title: const Text(
                "Dark Mode",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "Adapts to your mobile screen settings",
                style: TextStyle(color: Colors.grey),
              ),
              secondary:
                  const Icon(Icons.nightlight_round, color: Colors.white),
              activeColor: Colors.purple,
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: "Chage Language"),
            DropdownButtonFormField<String>(
              value: "English (US)",
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "English (US)",
                  child: Text("English (US)"),
                ),
                DropdownMenuItem(
                  value: "Español",
                  child: Text("Español"),
                ),
              ],
              onChanged: (value) {},
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: "System Sound"),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notification Sound",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Switch(
                    value: isNotificationSoundEnabled,
                    onChanged: (value) {
                      setState(() {
                        isNotificationSoundEnabled = value;
                      });
                    },
                    activeColor: Colors.purple,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: "Notification Display"),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notification Display",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Switch(
                    value: isNotificationDisplayEnabled,
                    onChanged: (value) {
                      setState(() {
                        isNotificationDisplayEnabled = value;
                      });
                    },
                    activeColor: Colors.purple,
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

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
