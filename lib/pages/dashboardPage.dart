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
    final theme = Theme.of(context);

    return Scaffold(
      // Let the theme handle the scaffold background:
      // backgroundColor: theme.scaffoldBackgroundColor,
      drawer: CustomSidebar(userName: userName ?? 'Guest'),
      appBar: AppBar(
        // backgroundColor from the theme:
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: theme.appBarTheme.iconTheme?.color),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
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
        onPressed: () => Navigator.pushNamed(context, '/addChellenge'),
        backgroundColor: theme.colorScheme.primary,
        child: Icon(
          Icons.add,
          color: theme.colorScheme.onPrimary,
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
                      style: theme.textTheme.bodyMedium?.copyWith(
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
                          final bool isStarted = challenge['isStarted'] == true;
                          final List<dynamic> tasks =
                              challenge['tasksForDays'] ?? [];
                          // Build status string
                          String statusText = 'Not Started';
                          if (isStarted) {
                            // Calculate completed tasks
                            final total = tasks.length;
                            final completedCount = tasks
                                .where((element) =>
                                    (element['completed'] ?? false) == true)
                                .length;
                            statusText = '$completedCount/$total';
                          }

                          return _HabitCard(
                            title: challenge['title'],
                            status: statusText,
                            imagePath: challenge['imageUrl'] ??
                                'assets/images/placeholder.png',
                            // brand color can come from your theme.colorScheme.primary,
                            color: theme.colorScheme.primary,
                            isHidden: challenge['isHidden'] ?? false,
                            onVisibilityChanged: (newHiddenStatus) =>
                                _handleVisibilityChange(
                                    challenge['title'], newHiddenStatus),
                            onTap: () {
                              // Go to the tracker
                              Navigator.pushNamed(
                                context,
                                '/tracker',
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
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              children: [
                const TextSpan(text: 'Hello,\n'),
                TextSpan(text: name, style: const TextStyle(height: 1.2)),
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
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
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: status.contains('/')
                              ? color
                              : theme.textTheme.bodyMedium?.color,
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
                  color: theme.iconTheme.color,
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
