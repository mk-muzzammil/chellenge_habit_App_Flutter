import 'package:chellenge_habit_app/Services/databaseHandler.dart';
import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';

class HabitSelectionScreen extends StatefulWidget {
  const HabitSelectionScreen({super.key});

  @override
  State<HabitSelectionScreen> createState() => _HabitSelectionScreenState();
}

class _HabitSelectionScreenState extends State<HabitSelectionScreen> {
  String? userName;
  String? photoUrl;
  bool isLoading = true;
  List<Map<String, dynamic>> _challenges = [];

  final _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    listenForChallenges();
  }

  Future<void> fetchUserData() async {
    final userData = await _databaseService.fetchUserData();
    if (userData != null) {
      setState(() {
        userName = userData['displayName'];
        photoUrl = userData['photoURL'];
      });
    }
  }

  void listenForChallenges() {
    _databaseService
        .fetchChallengesRealTime(showHidden: false)
        .listen((challenges) {
      setState(() {
        _challenges = challenges;
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
      drawer: CustomSidebar(userName: userName ?? 'Guest'),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: photoUrl != null
                    ? Image.network(
                        photoUrl!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/icons/Avatar.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addChellenge');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: AppColors.textPrimary,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, userName ?? 'Guest'),
                    const SizedBox(height: 16),
                    Text(
                      'Choose the first habit you want\nto build',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _challenges.length,
                        itemBuilder: (context, index) {
                          final challenge = _challenges[index];
                          return _HabitCard(
                            title: challenge['title'],
                            status: 'Not Started',
                            imagePath: challenge['imageUrl'] ??
                                'assets/images/placeholder.png',
                            color: AppColors.primary,
                            isHidden: challenge['isHidden'] ?? false,
                            onVisibilityChanged: (isHidden) =>
                                _handleVisibilityChange(
                                    challenge['title'], isHidden),
                            onTap: () {
                              // -------- NEW CODE: PASS THE CHALLENGE TO THE TRACKER PAGE
                              Navigator.pushNamed(
                                context,
                                "/tracker",
                                arguments: challenge,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context, String name) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              children: [
                const TextSpan(text: 'Hello,\n'),
                TextSpan(
                  text: name,
                  style: const TextStyle(height: 1.2),
                ),
                const TextSpan(text: ' 👋'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HabitCard extends StatelessWidget {
  final String title;
  final String status;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;
  final Function(bool) onVisibilityChanged;
  final bool isHidden;

  const _HabitCard({
    required this.title,
    required this.status,
    required this.imagePath,
    required this.color,
    required this.onTap,
    required this.onVisibilityChanged,
    this.isHidden = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: imagePath.startsWith('http')
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: status.contains('/')
                              ? color
                              : AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  isHidden ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  onVisibilityChanged(!isHidden);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
