import 'package:flutter/material.dart';
import 'AddNewChallenges.dart';
import 'package:chellenge_habit_app/theme/colors.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  int _currentIndex = 0; // Tracks the selected tab index
  bool _isGridView = false; // Tracks the view type

  final List<Widget> _tabs = const [
    CompletedTab(),
    OverdueTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenges"),
        // Let the theme handle the background
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          CircleAvatar(
            // Use theme-based surface color for the background
            backgroundColor: theme.colorScheme.surface,
            child: Icon(Icons.person, color: theme.iconTheme.color),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
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
            child: _currentIndex == 0
                ? InProgressTab(isGridView: _isGridView)
                : _tabs[_currentIndex - 1],
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
          );
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
}

class InProgressTab extends StatelessWidget {
  final bool isGridView;
  const InProgressTab({required this.isGridView, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Do anytime",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isGridView
                ? GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: const [
                      ChallengeCardGrid(
                        title: "Drink water",
                        subtitle: "Detox",
                        progress: 0.75,
                        current: 15,
                        total: 20,
                        imagePath: 'assets/images/01.png',
                      ),
                      ChallengeCardGrid(
                        title: "Read Book",
                        subtitle: "Focus",
                        progress: 0.5,
                        current: 10,
                        total: 20,
                        imagePath: 'assets/images/01.png',
                      ),
                      ChallengeCardGrid(
                        title: "Do exercise",
                        subtitle: "Change batteries",
                        progress: 0.75,
                        current: 15,
                        total: 20,
                        imagePath: 'assets/images/01.png',
                      ),
                      ChallengeCardGrid(
                        title: "Meditation",
                        subtitle: "Healthy mind & body",
                        progress: 0.25,
                        current: 5,
                        total: 20,
                        imagePath: 'assets/images/01.png',
                      ),
                    ],
                  )
                : ListView(
                    children: const [
                      ChallengeCardList(
                        title: "Drink water",
                        subtitle: "Detox",
                        progress: 0.75,
                        current: 15,
                        total: 20,
                        imagePath: 'assets/images/01.png',
                      ),
                      ChallengeCardList(
                        title: "Read Book",
                        subtitle: "Focus",
                        progress: 0.5,
                        current: 10,
                        total: 20,
                        imagePath: 'assets/images/01.png',
                      ),
                      ChallengeCardList(
                        title: "Do exercise",
                        subtitle: "Change batteries",
                        progress: 0.75,
                        current: 15,
                        total: 20,
                        imagePath: 'assets/images/01.png',
                      ),
                      ChallengeCardList(
                        title: "Meditation",
                        subtitle: "Healthy mind & body",
                        progress: 0.25,
                        current: 5,
                        total: 20,
                        imagePath: 'assets/images/01.png',
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
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

  const ChallengeCardList({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.current,
    required this.total,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 16),
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
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
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

  const ChallengeCardGrid({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.current,
    required this.total,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
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
                const SizedBox(height: 8.0),
                // Progress Bar
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.dividerColor,
                  color: progress >= 0.5 ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 8),
                // Current / Total
                Text(
                  "$current/$total",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
