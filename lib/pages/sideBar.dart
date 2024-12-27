import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  final String userName;

  const CustomSidebar({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black87,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              accountName: Text(userName, style: TextStyle(color: Colors.white)),
              accountEmail: null,
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text("Home", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.white),
              title: Text("Premium", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/premiumPackages');
              },
            ),
            ListTile(
              leading: Icon(Icons.flag, color: Colors.white),
              title: Text("Challenge", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/chellenges');
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.white),
              title: Text("Notifications", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            ListTile(
              leading: Icon(Icons.visibility_off, color: Colors.white),
              title: Text("Hide Challenges", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/hiddenChellenges');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text("Settings", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text("Profile", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Log out", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
