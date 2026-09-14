import 'package:doctor_visit/controller/profile_details_controller/profile_details_controller.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/profile_screen/profile_screen.dart';
import 'package:doctor_visit/view/widgets/switch_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;

  const CommonAppBar({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You can access providers here if needed
    ref.watch(profileDetailsProvider);

    return AppBar(
      backgroundColor: AppColors.appPrimaryRed,
      toolbarHeight: 100,
      automaticallyImplyLeading: false,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                subtitle,
                style: AppTextStyles.anekMalayalam(
                  fontSize: 14,
                  // ignore: deprecated_member_use
                  color: AppColors.appWhite.withOpacity(0.9),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              const Text("👋", style: TextStyle(fontSize: 14)),
            ],
          ),
          Text(
            title,
            style: AppTextStyles.anekMalayalam(
              fontSize: 24,
              color: AppColors.appWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      actions: [
        CustomSwitchButton(),
        SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,

            onTap: () async {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const ProfileScreen(),
                withNavBar: false, //  THIS HIDES BOTTOM NAV
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: CircleAvatar(
              // ignore: deprecated_member_use
              backgroundColor: AppColors.appWhite.withOpacity(0.2),
              child: Icon(Icons.person, color: AppColors.appWhite),
            ),
          ),
        ),
      ],

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
