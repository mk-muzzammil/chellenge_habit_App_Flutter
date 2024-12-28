import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Import Facebook Auth

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseDatabase _db = FirebaseDatabase.instance;

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

  Future<bool> saveProfileData({
    required String Name,
    required String Gender,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser; // Get the current user

    if (user == null) {
      // Handle case where user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return false;
    }

    final String uid = user.uid; // Get the user's UID
    final String name = Name;
    final String gender = Gender!;

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
      Navigator.of(context)
          .pushReplacementNamed('/home'); // Navigate to the home screen
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
        print("Fetched User Data: $data"); // Print data to terminal
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

  // Method to save the challenge
  Future<void> saveChallenge({
    required String title,
    required String description,
    required List<String> tasks,
    required int selectedDay,
    String? imageUrl,
  }) async {
    try {
      // Push new challenge data to the Firebase Realtime Database
      await _db.ref('challenges').push().set({
        'title': title,
        'description': description,
        'tasks': tasks,
        'selectedDay': selectedDay,
        'imageUrl': imageUrl, // Save the image URL if provided
      });
    } catch (e) {
      print('Failed to save challenge: $e');
      throw Exception('Failed to save challenge: $e');
    }
  }
}
