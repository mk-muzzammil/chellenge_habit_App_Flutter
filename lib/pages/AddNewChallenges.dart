import 'dart:io';

import 'package:chellenge_habit_app/Services/databaseHandler.dart';
import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';

class NewChallengePage extends StatefulWidget {
  const NewChallengePage({super.key});

  @override
  _NewChallengePageState createState() => _NewChallengePageState();
}

class _NewChallengePageState extends State<NewChallengePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController taskController = TextEditingController();

  final DatabaseService _dbHandler = DatabaseService();
  List<Map<String, String>> tasksForDays = List.generate(
    18,
    (index) => {"day": "Day ${index + 1}", "task": ""},
  );

  int? selectedDay;
  File? selectedImage; // Stores the selected image file
  String? imageUrl; // Stores the uploaded image URL

  // Add a task for the current day
  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasksForDays[selectedDay! - 1]['task'] = taskController.text;
        taskController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task cannot be empty")),
      );
    }
  }

  // Pick an image using ImagePicker
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  // Save the challenge, including image upload
  Future<void> saveChallenge() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        tasksForDays.any((day) => day['task']!.isNotEmpty)) {
      try {
        // Upload the image if selected
        if (selectedImage != null) {
          imageUrl = await _dbHandler.uploadChallengeImage(selectedImage!.path);
        }

        // Save the challenge with the image URL
        await _dbHandler.saveChallenge(
          title: titleController.text,
          description: descriptionController.text,
          tasksForDays: tasksForDays,
          imageUrl: imageUrl, // Include the image URL
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Challenge Created Successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and add tasks")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("New Challenge"),
        actions: [
          TextButton(
            onPressed: saveChallenge,
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.purple, fontFamily: 'Inter'),
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
      drawer: CustomSidebar(userName: ""),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: DottedBorder(
                    borderType: BorderType.Circle,
                    dashPattern: const [6, 3],
                    color: Colors.grey,
                    strokeWidth: 2,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : null,
                      child: selectedImage == null
                          ? const Icon(Icons.add, size: 32, color: Colors.white)
                          : null,
                    ),
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
                        labelText: "Enter Task for Selected Day",
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
                "Select Day and View Tasks:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasksForDays.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = index + 1;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: selectedDay == index + 1
                            ? Colors.purple
                            : Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Day ${index + 1}: ${tasksForDays[index]['task']}",
                        style: TextStyle(
                          color: selectedDay == index + 1
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
