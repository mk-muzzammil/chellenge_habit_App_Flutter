import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'AddNewChallenges.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenges"),
        backgroundColor: Colors.black,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.person),
          ),
          const SizedBox(width: 16),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: CustomSidebar(userName: "Thao Lee"),
      body: Column(
        children: [
          // Custom Tab Bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[900],
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
                  icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                  color: Colors.white,
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
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
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
          color: isSelected ? Colors.purple : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Do anytime",
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
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
    return Center(
      child: Text(
        "No completed challenges yet!",
        style: TextStyle(color: Colors.grey[400], fontSize: 18),
      ),
    );
  }
}

class OverdueTab extends StatelessWidget {
  const OverdueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No overdue challenges. Great job!",
        style: TextStyle(color: Colors.grey[400], fontSize: 18),
      ),
    );
  }
}

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
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Image on the left
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
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
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[800],
                          color: progress >= 0.5 ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$current/$total",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
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
                // Icon
                Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
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
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 8.0), // For horizontal space
                SizedBox(height: 8.0), // For vertical space
                // Progress Bar
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[800],
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                // Current and Total
                Text(
                  "$current/$total",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Eye Icon
        ],
      ),
    );
  }
}
