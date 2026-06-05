import 'dart:convert';

import 'package:doctor_visit/controller/profile_details_controller/profile_details_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileDetailsProvider);

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
                      // ignore: deprecated_member_use
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
                              profileState.profileDetails.first.name![0],
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.appPrimaryRed,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            profileState.profileDetails.first.name ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            profileState
                                        .profileDetails
                                        .first
                                        .email
                                        ?.isNotEmpty ==
                                    true
                                ? profileState.profileDetails.first.email!
                                : 'example@gmail.com',
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
                        'DETAILS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      buildSettingsItem(
                        Icons.receipt_long,
                        profileState.profileDetails.first.name ?? '',
                      ),

                      buildSettingsItem(
                        Icons.mail_outline_outlined,
                        profileState.profileDetails.first.email?.isNotEmpty ==
                                true
                            ? profileState.profileDetails.first.email!
                            : 'Email address not available.',
                      ),
                      buildSettingsItem(
                        Icons.phone,
                        profileState.profileDetails.first.mobile?.isNotEmpty ==
                                true
                            ? profileState.profileDetails.first.mobile!
                            : 'Mobile Number not available.',
                      ),
                      buildSettingsItem(
                        Icons.home_outlined,
                        profileState.profileDetails.first.address?.isNotEmpty ==
                                true
                            ? profileState.profileDetails.first.address!
                            : 'address not available.',
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

//profile image
Uint8List? decodeImage(String? base64String) {
  try {
    if (base64String == null || base64String.trim().isEmpty) {
      return null;
    }

    String cleaned = base64String.trim();

    if (cleaned.contains(',')) {
      cleaned = cleaned.split(',').last;
    }

    cleaned = cleaned
        .replaceAll('\n', '')
        .replaceAll('\r', '')
        .replaceAll(' ', '');

    return base64Decode(cleaned);
  } catch (e) {
    debugPrint("Decode Error: $e");
    return null;
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
