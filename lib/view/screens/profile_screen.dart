import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.appPrimaryRed,
        statusBarIconBrightness: Brightness.dark, // Android icons
        statusBarBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),

          body: CustomScrollView(
            slivers: [
              ///  Collapsing AppBar
              SliverAppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.appWhite.withOpacity(0.2),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.appWhite,
                      ),
                    ),
                  ),
                ),
                expandedHeight: 240,
                pinned: true,
                backgroundColor: AppColors.appPrimaryRed,
                elevation: 0,
                forceElevated: false,
                // 1. This is how you get the curved bottom on a SliverAppBar
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),

                // 2. Use FlexibleSpaceBar's title for the "fade-in" effect
                // instead of the SliverAppBar.title property.
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(
                    bottom: 16,
                  ), // Adjust position
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      // Only show text when the bar is nearly collapsed
                      var top = constraints.biggest.height;
                      return Opacity(
                        opacity: top < 120 ? 1.0 : 0.0,
                        child: null,
                      );
                    },
                  ),
                  background: Container(
                    // Keep your background decoration for when it is expanded
                    decoration: BoxDecoration(
                      color: AppColors.appPrimaryRed,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Text(
                              "A",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.appPrimaryRed,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Arun Kurian",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Sample Collector - Palarivattom",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'FIRST NAME',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      buildSettingsItem(Icons.sync, "Arun"),
                      Text(
                        'LAST NAME',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      buildSettingsItem(Icons.receipt_long, "Kurian"),

                      buildSettingsItem(
                        Icons.mail_outline_outlined,
                        "arun_kurian@gmail.com",
                      ),
                      buildSettingsItem(Icons.phone, "+91 7847839487"),
                      buildSettingsItem(
                        Icons.home_outlined,
                        "Kakkanad,Ernakulam PIN:-682030",
                      ),
                      buildSettingsItem(
                        Icons.location_city_outlined,
                        "Palarivattom",
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//header
Widget buildProfileHeader() {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
    decoration: const BoxDecoration(
      color: Color(0xFF0E8B5C),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
    ),
    child: Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: Text(
            "S",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E8B5C),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Sumesh K.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Sample Collector - Bengaluru",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 30),
        // Stats Row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatItem(label: "Today", value: "24"),
              VerticalDivider(color: Colors.white24, thickness: 1),
              StatItem(label: "This month", value: "312"),
              VerticalDivider(color: Colors.white24, thickness: 1),
              StatItem(label: "Rating", value: "4.9"),
            ],
          ),
        ),
      ],
    ),
  );
}

class StatItem extends StatelessWidget {
  final String label, value;
  const StatItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

//
Widget buildSettingsItem(IconData icon, String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.appWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade100),
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.appLightRed,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.appPrimaryRed, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}
