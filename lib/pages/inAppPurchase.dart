import 'package:chellenge_habit_app/pages/sideBar.dart';
import 'package:chellenge_habit_app/theme/colors.dart'; // If still needed for brand colors
import 'package:flutter/material.dart';

class PremiumUpgradeScreen extends StatefulWidget {
  const PremiumUpgradeScreen({Key? key}) : super(key: key);

  @override
  _PremiumUpgradeScreenState createState() => _PremiumUpgradeScreenState();
}

class _PremiumUpgradeScreenState extends State<PremiumUpgradeScreen> {
  String selectedPlan = "1 MONTH"; // Default selected plan

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Let the theme handle scaffold background (dark or light):
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // Use theme’s AppBar background & icon color
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Restore action
            },
            child: Text(
              "Restore",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
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
              // Header with Icon
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        // If you want your brand color or theme color:
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star,
                        // Use onPrimary or iconTheme color
                        color: theme.colorScheme.onPrimary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Upgrade to Premium Now",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Access all servers worldwide, fast and powerful",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Feature Rows
              buildFeatureRow(
                Icons.block,
                "No Ads",
                "Enjoy surfing without annoying ads",
                context,
              ),
              buildFeatureRow(
                Icons.speed,
                "Fast",
                "Increase connection speed",
                context,
              ),
              buildFeatureRow(
                Icons.public,
                "All Servers",
                "Access all server worldwide",
                context,
              ),
              const SizedBox(height: 20),

              // Plan Selections
              Column(
                children: [
                  buildPlanDetails(
                    title: "1 MONTH",
                    price: "\$9.99",
                    description: "Link up to 2 Device",
                    isSelected: selectedPlan == "1 MONTH",
                    context: context,
                  ),
                  buildPlanDetails(
                    title: "1 YEAR",
                    price: "\$99.99",
                    description: "Link up to 4 Device",
                    isSelected: selectedPlan == "1 YEAR",
                    context: context,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Upgrade Button
              ElevatedButton(
                onPressed: () {
                  // Add your upgrade action logic here
                  print("Selected Plan: $selectedPlan");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Center(
                  child: Text(
                    "Upgrade to Premium Now",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Continue with 3 days free trial.",
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeatureRow(
    IconData icon,
    String title,
    String subtitle,
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.iconTheme.color,
            size: 30,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPlanDetails({
    required String title,
    required String price,
    required String description,
    required bool isSelected,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = title; // Update selected plan on tap
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Plan Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: isSelected
                        ? theme.colorScheme.onPrimary.withOpacity(0.8)
                        : theme.hintColor,
                  ),
                ),
              ],
            ),
            // Price + Radio
            Row(
              children: [
                Text(
                  price,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(width: 10),
                Radio<String>(
                  value: title,
                  groupValue: selectedPlan,
                  activeColor: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
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
