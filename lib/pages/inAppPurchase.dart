import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart';
import 'package:flutter/material.dart';

class PremiumUpgradeScreen extends StatefulWidget {
  @override
  _PremiumUpgradeScreenState createState() => _PremiumUpgradeScreenState();
}

class _PremiumUpgradeScreenState extends State<PremiumUpgradeScreen> {
  String selectedPlan = "1 MONTH"; // Default selected plan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          TextButton(
            onPressed: () {}, // Restore action
            child: Text("Restore", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
       drawer: CustomSidebar(userName: "Thao Lee"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star, color: Colors.white, size: 40),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Upgrade to Premium Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Access all servers worldwide, fast and powerful",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildFeatureRow(
                  Icons.block, "No Ads", "Enjoy surfing without annoying ads"),
              buildFeatureRow(Icons.speed, "Fast", "Increase connection speed"),
              buildFeatureRow(
                  Icons.public, "All Servers", "Access all server worldwide"),
              SizedBox(height: 20),
              // Plan selection
              Column(
                children: [
                  buildPlanDetails("1 MONTH", "\$9.99", "Link up to 2 Device",
                      selectedPlan == "1 MONTH"),
                  buildPlanDetails("1 YEAR", "\$99.99", "Link up to 4 Device",
                      selectedPlan == "1 YEAR"),
                ],
              ),
              SizedBox(height: 20),
              // Upgrade to Premium Button
              ElevatedButton(
                onPressed: () {
                  print("Selected Plan: $selectedPlan");
                  // Add your upgrade action logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Center(
                  child: Text(
                    "Upgrade to Premium Now",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Continue with 3 days free trial.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeatureRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
              Text(subtitle,
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPlanDetails(
      String title, String price, String description, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = title; // Update selected plan on tap
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Plan Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 5),
                Text(description,
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
            // Price and Radio Icon
            Row(
              children: [
                Text(price,
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(width: 10),
                Radio<String>(
                  value: title,
                  groupValue: selectedPlan,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      selectedPlan = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
