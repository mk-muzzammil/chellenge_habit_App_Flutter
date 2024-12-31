import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:flutter/material.dart';
import 'AddNewChallenges.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:chellenge_habit_app/Services/databaseHandler.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  int _currentIndex = 0; // Tracks the selected tab index
  bool _isGridView = false; // Tracks the view type

  final DatabaseService _databaseService = DatabaseService();

  // Categorized challenges
  List<Map<String, dynamic>> _inProgressChallenges = [];
  List<Map<String, dynamic>> _completedChallenges = [];
  List<Map<String, dynamic>> _overdueChallenges = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChallenges();
  }

  Future<void> _fetchChallenges() async {
    setState(() {
      _isLoading = true;
    });

    final challengesByStatus = await _databaseService.fetchChallengesByStatus();

    setState(() {
      _inProgressChallenges = challengesByStatus['inProgress'] ?? [];
      _completedChallenges = challengesByStatus['completed'] ?? [];
      _overdueChallenges = challengesByStatus['overdue'] ?? [];
      _isLoading = false;
    });
  }

  // To listen to real-time updates, you can use StreamBuilder or periodically fetch challenges
  // For simplicity, we'll add a pull-to-refresh mechanism

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenges"),
        // Let the theme handle the background
        backgroundColor: theme.appBarTheme.backgroundColor,

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Custom Tab Bar
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTabButton("In Progress", 0),
                            _buildTabButton("Completed", 1),
                            _buildTabButton("Overdue", 2),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isGridView ? Icons.list : Icons.grid_view,
                          color: theme.iconTheme.color,
                        ),
                        onPressed: () {
                          setState(() {
                            _isGridView = !_isGridView;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchChallenges,
                    child: _currentIndex == 0
                        ? _buildChallengesList(_inProgressChallenges,
                            isGridView: _isGridView)
                        : _currentIndex == 1
                            ? _buildChallengesList(_completedChallenges,
                                isGridView: _isGridView)
                            : _buildChallengesList(_overdueChallenges,
                                isGridView: _isGridView),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        child: Icon(
          Icons.add,
          color: theme.colorScheme.onPrimary,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewChallengePage(),
            ),
          ).then((_) {
            // Refresh challenges after adding a new one
            _fetchChallenges();
          });
        },
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final theme = Theme.of(context);
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildChallengesList(List<Map<String, dynamic>> challenges,
      {required bool isGridView}) {
    if (challenges.isEmpty) {
      String message;
      if (_currentIndex == 0) {
        message = "No challenges in progress.";
      } else if (_currentIndex == 1) {
        message = "No completed challenges yet!";
      } else {
        message = "No overdue challenges. Great job!";
      }

      return Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isGridView
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return ChallengeCardGrid(
                  title: challenge['title'] ?? 'No Title',
                  subtitle: challenge['description'] ?? 'No Description',
                  progress: _calculateProgress(challenge),
                  current: _completedTasksCount(challenge),
                  total: 18,
                  imagePath:
                      challenge['imageUrl'] ?? 'assets/images/placeholder.png',
                  onTap: () {
                    // Navigate to TrackerPage with challenge data
                    Navigator.pushNamed(
                      context,
                      '/tracker',
                      arguments: challenge,
                    ).then((_) {
                      // Refresh challenges after returning
                      _fetchChallenges();
                    });
                  },
                );
              },
            )
          : ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return ChallengeCardList(
                  title: challenge['title'] ?? 'No Title',
                  subtitle: challenge['description'] ?? 'No Description',
                  progress: _calculateProgress(challenge),
                  current: _completedTasksCount(challenge),
                  total: 18,
                  imagePath:
                      challenge['imageUrl'] ?? 'assets/images/placeholder.png',
                  onTap: () {
                    // Navigate to TrackerPage with challenge data
                    Navigator.pushNamed(
                      context,
                      '/tracker',
                      arguments: challenge,
                    ).then((_) {
                      // Refresh challenges after returning
                      _fetchChallenges();
                    });
                  },
                );
              },
            ),
    );
  }

  /// Calculates the progress as a fraction (0.0 to 1.0)
  double _calculateProgress(Map<String, dynamic> challenge) {
    List<dynamic> tasksForDays = challenge['tasksForDays'] ?? [];
    if (tasksForDays.isEmpty) return 0.0;
    int completed =
        tasksForDays.where((task) => task['completed'] == true).length;
    return completed / tasksForDays.length;
  }

  /// Counts the number of completed tasks
  int _completedTasksCount(Map<String, dynamic> challenge) {
    List<dynamic> tasksForDays = challenge['tasksForDays'] ?? [];
    return tasksForDays.where((task) => task['completed'] == true).length;
  }
}

class CompletedTab extends StatelessWidget {
  const CompletedTab({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        "No completed challenges yet!",
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}

class OverdueTab extends StatelessWidget {
  const OverdueTab({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        "No overdue challenges. Great job!",
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ChallengeCardList & ChallengeCardGrid: use theme for background & text colors
// ─────────────────────────────────────────────────────────────────────────────

class ChallengeCardList extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final int current;
  final int total;
  final String imagePath;
  final VoidCallback onTap;

  const ChallengeCardList({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.current,
    required this.total,
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Image on the left
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.network(
                  imagePath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Challenge Details
              Expanded(
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
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: theme.dividerColor,
                            color: progress >= 0.5 ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$current/$total",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChallengeCardGrid extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final int current;
  final int total;
  final String imagePath;
  final VoidCallback onTap;

  const ChallengeCardGrid({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.current,
    required this.total,
    required this.imagePath,
    required this.onTap,
    super.key,
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
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.2),
              blurRadius: 6, // Slightly reduced blur for subtle shadow
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Reduced overall padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Prevents Column from expanding
            children: [
              // Image Section
              Center(
                child: Container(
                  width: 60, // Increased width for better visibility
                  height: 60, // Increased height
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0), // Reduced inner padding
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing

              // Title
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14, // Reduced font size for balance
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1, // Limits to one line
                overflow: TextOverflow.ellipsis, // Adds ellipsis if overflow
              ),
              const SizedBox(height: 4), // Reduced spacing

              // Subtitle
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 10, // Reduced font size
                ),
                maxLines: 1, // Limits to one line
                overflow: TextOverflow.ellipsis, // Adds ellipsis if overflow
              ),
              const SizedBox(height: 4), // Reduced spacing

              // Progress Bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.dividerColor,
                color: progress >= 0.5 ? Colors.green : Colors.red,
                minHeight: 4, // Reduced height for compactness
              ),
              const SizedBox(height: 4), // Reduced spacing

              // Current / Total
              Text(
                "$current/$total",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10, // Reduced font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
