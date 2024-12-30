import 'package:chellenge_habit_app/Services/CloudinaryService.dart';
import 'package:chellenge_habit_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// 1. Import awesome_notifications
import 'package:awesome_notifications/awesome_notifications.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final DatabaseReference _challengesRef =
      FirebaseDatabase.instance.ref('challenges');

  // ------------------- AUTH METHODS (unchanged) -------------------
  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged in successfully!')),
        );
        Navigator.pushNamed(context, '/home');
        return true; // Indicate success
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message}')),
      );
      return false; // Indicate failure
    }
    return false;
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User created successfully!')),
        );
        Navigator.pushNamed(context, '/profileSetup');
        return true; // Indicate success
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: ${e.message}')),
      );
      return false; // Indicate failure
    }
    return false;
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut().then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Log Out Successfully')),
            ),
            Navigator.pushNamed(context, '/login')
          });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: ${e.message}')),
      );
    }
  }

  Future<UserCredential?> logInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Store user information in Firebase Realtime Database
        await _database.child('users').child(user.uid).set({
          'displayName': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: ${e.message}')),
      );
    }
    return null;
  }

  Future<UserCredential?> logInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Store user information in Firebase Realtime Database
          await _database.child('users').child(user.uid).set({
            'displayName': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
          });
        }

        return userCredential;
      } else if (result.status == LoginStatus.cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook sign-in canceled')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook sign-in failed: ${result.message}')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Facebook sign-in failed: ${e.message}')),
      );
    }
    return null;
  }

  // ------------------- PROFILE METHODS (unchanged) -------------------
  Future<bool> saveProfileData({
    required String Name,
    required String Gender,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return false;
    }

    final String uid = user.uid;
    final String name = Name;
    final String gender = Gender;

    // Save the data in Firebase Realtime Database
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
    await databaseRef.child('users/$uid').set({
      'displayName': name,
      'email': user.email,
      'gender': gender,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile data saved successfully')),
      );
      Navigator.of(context).pushReplacementNamed('/home');
      return true;
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile data: $error')),
      );
      return false;
    });
    return false;
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final User? user = _auth.currentUser;

    if (user == null) return null;

    try {
      final DatabaseReference userRef = _database.child('users/${user.uid}');
      final DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        print("Fetched User Data: $data");
        return data;
      } else {
        print("No data found for the user.");
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userRef = _database.child('users/${user.uid}');
      await userRef.update(data);
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  // ------------------- CHALLENGE & IMAGE METHODS (unchanged) -------------------
  Future<void> saveChallenge({
    required String title,
    required String description,
    required List<Map<String, String>> tasksForDays,
    required String? imageUrl,
  }) async {
    try {
      await _database.child("challenges").child(title).set({
        "title": title,
        "description": description,
        "tasksForDays": tasksForDays,
        "imageUrl": imageUrl,
      });
    } catch (e) {
      throw Exception("Failed to save challenge: $e");
    }
  }

  Future<String?> uploadChallengeImage(String filePath) async {
    try {
      final CloudinaryService cloudinaryService = CloudinaryService();
      final String? imageUrl = await cloudinaryService.uploadImage(
        filePath,
        AppConstants.cloudinaryUploadPreset,
        fileName: 'challenge_image_${DateTime.now().millisecondsSinceEpoch}',
      );
      return imageUrl;
    } catch (e) {
      throw Exception("Failed to upload challenge image: $e");
    }
  }

  Future<void> uploadProfilePhoto({
    required String filePath,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return;
    }

    try {
      final CloudinaryService cloudinaryService = CloudinaryService();
      final String? imageUrl = await cloudinaryService.uploadImage(
        filePath,
        AppConstants.cloudinaryUploadPreset,
        fileName: 'profile_${user.uid}',
      );

      if (imageUrl != null) {
        await _database
            .child('users/${user.uid}')
            .update({'photoURL': imageUrl});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload profile photo')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchChallenges() async {
    try {
      final DataSnapshot snapshot = await _database.child("challenges").get();
      if (snapshot.exists) {
        final List<Map<String, dynamic>> challenges = [];
        final data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          challenges.add({
            "title": value["title"],
            "description": value["description"],
            "tasksForDays": value["tasksForDays"],
            "imageUrl": value["imageUrl"],
          });
        });

        return challenges;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception("Failed to fetch challenges: $e");
    }
  }

  Future<void> saveChallengeNotificationTime(
    String challengeTitle,
    int hour12,
    int minute,
    bool isAm,
  ) async {
    try {
      final DatabaseReference challengeRef =
          _challengesRef.child(challengeTitle).child('notificationData');

      await challengeRef.update({
        'notificationHour': hour12,
        'notificationMinute': minute,
        'notificationIsAm': isAm,
      });
    } catch (e) {
      print("Error saving challenge notification time: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // Schedule Notification (Hardcoded Body)
  // ---------------------------------------------------------------------------
  /// Schedules a daily notification. The notification title = [challengeTitle].
  /// The body is a hardcoded call-to-action quote.
  Future<void> scheduleChallengeNotification(
    String challengeTitle,
    int hour12,
    int minute,
    bool isAm,
  ) async {
    // Convert 12-hour format to 24-hour format
    int hour24 = isAm ? (hour12 % 12) : (hour12 % 12) + 12;

    // Unique ID for the notification
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'challenge_reminder',
        // Title is the challenge title
        title: challengeTitle,
        // Hardcoded call-to-action
        body: 'Keep going and become unstoppable!',
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar(
        hour: hour24,
        minute: minute,
        second: 0,
        millisecond: 0,
        repeats: true, // daily
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
    );
  }

  // ------------------- VISIBILITY & STREAM METHODS (unchanged) -------------------
  Future<void> updateChallengeVisibility(String title, bool isHidden) async {
    try {
      await _challengesRef.child(title).update({
        'isHidden': isHidden,
      });
    } catch (e) {
      throw Exception("Failed to update challenge visibility: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchChallengesRealTime(
      {bool showHidden = false}) {
    return _challengesRef.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<Map<String, dynamic>> challenges = [];
        data.forEach((key, value) {
          bool isHidden = value['isHidden'] ?? false;
          if ((!showHidden && !isHidden) || (showHidden && isHidden)) {
            challenges.add({
              'title': value['title'],
              'description': value['description'],
              'imageUrl': value['imageUrl'],
              'isHidden': isHidden,
            });
          }
        });
        return challenges;
      }
      return [];
    });
  }
}
