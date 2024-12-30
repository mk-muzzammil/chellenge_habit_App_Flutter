import 'package:flutter/material.dart';
import 'package:chellenge_habit_app/Services/databaseHandler.dart';
import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String displayName = "";
  String email = "";
  String gender = "";
  String photoURL = "";
  final _databaseService = DatabaseService();
  final ImagePicker _picker = ImagePicker();

  bool isEditingGender = false;
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final userData = await _databaseService.fetchUserData();
    if (userData != null) {
      setState(() {
        displayName = userData['displayName'] ?? "Guest";
        email = userData['email'] ?? "No email provided";
        gender = userData['gender'] ?? "Not specified";
        photoURL = userData['photoURL'] ?? "";
        genderController.text = gender;
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
        isEditingGender = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating gender: $e')),
      );
    }
  }

  Future<void> pickAndUploadPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _databaseService.uploadProfilePhoto(
          filePath: image.path,
          context: context,
        );
        fetchUserData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // Close editing mode when tapping outside
        if (isEditingGender) {
          updateGender(genderController.text);
        }
      },
      child: Scaffold(
        // Let the theme handle scaffold background:
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: theme.iconTheme.color),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Text("Profile", style: theme.appBarTheme.titleTextStyle),
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
              const SizedBox(height: 20),
              // Profile picture with edit icon
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
                      child: photoURL.isNotEmpty
                          ? Image.network(
                              photoURL,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/Avatar.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: pickAndUploadPhoto,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary, // brand color
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
              const SizedBox(height: 20),

              // View Challenges Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chellenges');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 50,
                  ),
                ),
                child: Text(
                  "View Challenges",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Email Section
              buildInfoField("Email", email, context),
              const SizedBox(height: 20),

              // Gender Section with edit functionality
              buildEditableGenderField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoField(String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableGenderField() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: isEditingGender
                    ? TextField(
                        controller: genderController,
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          gender,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
              ),
              IconButton(
                icon: Icon(
                  isEditingGender ? Icons.check : Icons.edit,
                  color: theme.iconTheme.color,
                ),
                onPressed: () {
                  setState(() {
                    isEditingGender = !isEditingGender;
                    if (!isEditingGender) {
                      updateGender(genderController.text);
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
