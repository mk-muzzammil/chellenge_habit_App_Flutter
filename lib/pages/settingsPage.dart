import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeToggled;

  const SettingsScreen({
    Key? key,
    required this.isDarkMode,
    required this.onDarkModeToggled,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationSoundEnabled = true;
  bool isNotificationDisplayEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: theme.appBarTheme.iconTheme?.color),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text('Settings', style: theme.appBarTheme.titleTextStyle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Image.asset("assets/images/Avatar.png"),
            ),
          ),
        ],
      ),
      drawer: CustomSidebar(userName: "Thao Lee"),
      body: Container(
        // Let the theme handle background color:
        color: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: "Change Mode"),
            SwitchListTile(
              value: widget.isDarkMode,
              onChanged: widget.onDarkModeToggled,
              title: Text(
                "Dark Mode",
                style: theme.textTheme.bodyLarge,
              ),
              subtitle: Text(
                "Adapts to your mobile screen settings",
                style: theme.textTheme.bodyMedium,
              ),
              secondary:
                  Icon(Icons.nightlight_round, color: theme.iconTheme.color),
              activeColor: theme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            SectionTitle(title: "Change Language"),
            DropdownButtonFormField<String>(
              value: "English (US)",
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                border: const OutlineInputBorder(),
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
              onChanged: (value) {
                // Handle language change
              },
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            SectionTitle(title: "System Sound"),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notification Sound",
                    style: theme.textTheme.bodyLarge,
                  ),
                  Switch(
                    value: isNotificationSoundEnabled,
                    onChanged: (value) {
                      setState(() {
                        isNotificationSoundEnabled = value;
                      });
                    },
                    activeColor: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionTitle(title: "Notification Display"),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notification Display",
                    style: theme.textTheme.bodyLarge,
                  ),
                  Switch(
                    value: isNotificationDisplayEnabled,
                    onChanged: (value) {
                      setState(() {
                        isNotificationDisplayEnabled = value;
                      });
                    },
                    activeColor: theme.colorScheme.primary,
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
