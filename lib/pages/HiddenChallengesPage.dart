import 'package:chellenge_habit_app/Services/databaseHandler.dart';
import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:flutter/material.dart';

class HiddenChallenges extends StatefulWidget {
  const HiddenChallenges({super.key});

  @override
  _HiddenChallengesState createState() => _HiddenChallengesState();
}

class _HiddenChallengesState extends State<HiddenChallenges> {
  final _databaseService = DatabaseService();
  List<Map<String, dynamic>> _hiddenChallenges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    listenForHiddenChallenges();
  }

  void listenForHiddenChallenges() {
    _databaseService
        .fetchChallengesRealTime(showHidden: true)
        .listen((challenges) {
      setState(() {
        _hiddenChallenges = challenges;
        isLoading = false;
      });
    });
  }

  Future<void> _handleVisibilityChange(String title, bool isHidden) async {
    try {
      await _databaseService.updateChallengeVisibility(title, isHidden);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isHidden ? 'Challenge hidden' : 'Challenge visible'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating challenge visibility: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        // Let the theme handle background color
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          "Hidden Challenges",
          style: theme.appBarTheme.titleTextStyle,
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: theme.appBarTheme.iconTheme?.color),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: CustomSidebar(userName: "User"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hiddenChallenges.isEmpty
              ? Center(
                  child: Text(
                    "No hidden challenges",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _hiddenChallenges.length,
                    itemBuilder: (context, index) {
                      final challenge = _hiddenChallenges[index];
                      return ChallengeCard(
                        title: challenge['title'],
                        subtitle: challenge['description'] ?? '',
                        iconPath: challenge['imageUrl'] ??
                            'assets/images/placeholder.png',
                        isHidden: true,
                        onVisibilityChanged: (isHidden) =>
                            _handleVisibilityChange(
                          challenge['title'],
                          isHidden,
                        ),
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
  final String iconPath;
  final bool isHidden;
  final Function(bool) onVisibilityChanged;

  const ChallengeCard({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.isHidden,
    required this.onVisibilityChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
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
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: iconPath.startsWith('http')
                          ? Image.network(iconPath, fit: BoxFit.cover)
                          : Image.asset(iconPath, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Visibility Icon
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_off : Icons.visibility,
                color: theme.iconTheme.color,
              ),
              onPressed: () => onVisibilityChanged(!isHidden),
            ),
          ),
        ],
      ),
    );
  }
}
