import 'dart:developer';

import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';

import 'package:doctor_visit/view/screens/visit_completion_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorCard extends ConsumerWidget {
  final int indexGet;
  final String name;
  final String specialty;
  final String phone;
  final String time;
  final String initial;
  final String isDone;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.time,
    required this.initial,
    required this.isDone,
    required this.indexGet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 👉 Example: you can watch providers here if needed
    final homeState = ref.watch(homeScreenProvider);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        final newList = homeState.doctorsList.reversed.toList();
        homeState.isOn
            ? PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: VisitCompletionScreen(index: indexGet),
                withNavBar: false, // 🔥 THIS HIDES BOTTOM NAV
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              )
            : showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: AppColors.appWhite,
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "You are currently offline.Start your duty to view and manage visits.",
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // close dialog
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.appPrimaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
      },
      child: Container(
        //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: AppColors.appGrey.withOpacity(.20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              // blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 5,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.appLightRed,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  //spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.start,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      specialty,
                      style: TextStyle(color: Colors.orange[700]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 14,
                          color: Color(0xFFE53935),
                        ),
                        const SizedBox(width: 4),
                        Text(phone, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(time, style: const TextStyle(fontSize: 12)),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDone == 'Done'
                                ? Colors.green[50]
                                : isDone == 'Postponed'
                                ? Colors.cyan
                                : Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isDone,
                            style: TextStyle(
                              color: isDone == 'Done'
                                  ? Colors.green
                                  : isDone == 'Postponed'
                                  ? Colors.white
                                  : Colors.orange,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Spacer(),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.call, color: Colors.white, size: 20),
                  onPressed: () async {
                    final Uri url = Uri(scheme: 'tel', path: '+91$phone');

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url); // opens dialer safely
                    } else {
                      log('Could not launch dialer');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
