import 'package:chellenge_habit_app/Services/databaseHandler.dart';
import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class NewChallengePage extends StatefulWidget {
  const NewChallengePage({super.key});

  @override
  _NewChallengePageState createState() => _NewChallengePageState();
}

class _NewChallengePageState extends State<NewChallengePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController taskController = TextEditingController();

  List<int> days = List.generate(17, (index) => index + 2); // Days from 2 to 18
  int? selectedDay;
  List<String> tasks = []; // Tracks the selected day
  String? imageUrl; // Store the topic image URL
  final DatabaseService _dbHandler =
      DatabaseService(); // Create an instance of DatabaseService

  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(taskController.text);
        taskController.clear();
      });
    }
  }

  // Method to save challenge using DatabaseService
  Future<void> saveChallenge() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedDay != null) {
      try {
        // Call saveChallenge from DatabaseService
        await _dbHandler.saveChallenge(
          title: titleController.text,
          description: descriptionController.text,
          tasks: tasks,
          selectedDay: selectedDay!,
          imageUrl: imageUrl, // Pass the imageUrl if any
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Challenge Created")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjust layout when keyboard opens
      appBar: AppBar(
        title: const Text("New Challenge"),
        actions: [
          TextButton(
            onPressed: saveChallenge, // Call saveChallenge when Save is pressed
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.purple,
                fontFamily: 'Inter',
              ),
            ),
          ),
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: DottedBorder(
                  borderType: BorderType.Circle,
                  dashPattern: const [6, 3],
                  color: Colors.grey,
                  strokeWidth: 2,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[800],
                    child: const Icon(Icons.add, size: 32, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Challenge Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        labelText: "Enter your task",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.save, color: Colors.purple),
                    onPressed: addTask,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Days:",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  int day = days[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: selectedDay == day
                            ? Colors.purple
                            : Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                        border: selectedDay == day
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                      child: Text(
                        "Day $day",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: selectedDay == day
                              ? Colors.white
                              : Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveChallenge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text("Create"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
