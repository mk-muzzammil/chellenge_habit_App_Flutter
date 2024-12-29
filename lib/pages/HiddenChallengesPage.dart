import 'package:chellenge_habit_app/Services/databaseHandler.dart';
import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          "Hidden Challenges",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
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
              ? const Center(
                  child: Text(
                    "No hidden challenges",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
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
                                challenge['title'], isHidden),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
                Center(
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: iconPath.startsWith('http') ||
                              iconPath.startsWith('https')
                          ? Image.network(
                              iconPath,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              iconPath,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textPrimary,
              ),
              onPressed: () => onVisibilityChanged(!isHidden),
            ),
          ),
        ],
      ),
    );
  }
}
