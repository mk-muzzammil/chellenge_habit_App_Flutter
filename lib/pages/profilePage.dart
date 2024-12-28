import 'package:flutter/material.dart';
import 'package:chellenge_habit_app/Database/databaseHandler.dart';
import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String displayName = "";
  String email = "";
  String gender = "";
  String photoURL = "";
  final DatabaseService _databaseService = DatabaseService();

  bool isEditingGender = false; // To track editing state
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final userData = await _databaseService.fetchUserData();
    if (userData != null) {
      print("User Data in ProfileScreen: $userData");
      setState(() {
        displayName = userData['displayName'] ?? "Guest";
        email = userData['email'] ?? "No email provided";
        gender = userData['gender'] ?? "Not specified";
        photoURL = userData['photoURL'] ?? "";
        genderController.text = gender; // Initialize gender controller
      });
    } else {
      setState(() {
        displayName = "Guest";
        email = "No email provided";
        gender = "Not specified";
        photoURL = "";
      });
    }
  }

  void updateGender(String updatedGender) async {
    try {
      await _databaseService.updateUserData({'gender': updatedGender});
      setState(() {
        gender = updatedGender;
        isEditingGender = false; // Exit editing mode
      });
      print("Gender updated to: $updatedGender");
    } catch (e) {
      print("Error updating gender: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close editing mode when tapping outside
        if (isEditingGender) {
          updateGender(genderController.text);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Text("Profile", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image.asset("assets/images/coin.png"),
            ),
          ],
        ),
        drawer: CustomSidebar(userName: displayName),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              // Profile picture
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    ClipOval(
                      child: photoURL.isNotEmpty
                          ? Image.network(
                              photoURL,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/Avatar.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Name and Edit Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              SizedBox(height: 20),
              // View Challenges Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chellenges');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                child: Text(
                  "View Challenges",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 30),
              // Email Section
              buildInfoField("Email", email),
              SizedBox(height: 20),
              // Gender Section with edit functionality
              buildEditableGenderField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableGenderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: isEditingGender
                    ? TextField(
                        controller: genderController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      )
                    : Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          gender,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
              ),
              IconButton(
                icon: Icon(
                  isEditingGender ? Icons.check : Icons.edit,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isEditingGender = !isEditingGender;
                    if (!isEditingGender) {
                      updateGender(genderController
                          .text); // Update when exiting edit mode
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
