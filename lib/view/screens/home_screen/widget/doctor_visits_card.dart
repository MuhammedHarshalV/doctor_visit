import 'dart:developer';

import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/home_screen/widget/alert_dialog.dart';

import 'package:doctor_visit/view/screens/visit_completion_screen/visit_completion_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorCard extends ConsumerWidget {
  final int indexGet;
  final String name;
  final String address;
  final String phone;
  final String location;
  final bool isDone;
  final String initial;
  final bool isSelected;

  const DoctorCard({
    super.key,
    this.isSelected = false,
    required this.name,
    required this.address,
    required this.phone,

    required this.initial,

    required this.indexGet,
    required this.isDone,
    required this.location,
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
        if (homeState.isOn &&
            homeState.doctorsListAPI[indexGet].drIsGoing == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CommonAlertDialog(
                message: "You are already completed this task",
              );
            },
          );
        }
        if (homeState.isOn &&
            (homeState.doctorsListAPI[indexGet].drIsGoing == true ||
                homeState.doctorsListAPI[indexGet].drIsGoing == null)) {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: VisitCompletionScreen(index: indexGet),
            withNavBar: false, // 🔥 THIS HIDES BOTTOM NAV
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }

        if (homeState.isOn == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CommonAlertDialog(
                message:
                    "You are currently offline.Start your duty to view and manage visits.",
              );
            },
          );
        }
      },
      child: Container(
        //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected == true
              ? const Color.fromARGB(255, 251, 157, 151)
              : AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: isDone == false
                ? Colors.orange.withOpacity(.20)
                : Colors.green.withOpacity(.20),
          ),
          boxShadow: [
            BoxShadow(
              color: isDone == false
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: isDone == false
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
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
                    Text(address, style: TextStyle(color: Colors.orange[700])),
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
                            color: isDone ? Colors.green : Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isDone ? 'Completed' : 'Upcomming',
                            style: TextStyle(
                              color: AppColors.appWhite,

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
              Column(
                spacing: 10,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: location.isNotEmpty
                          ? AppColors.appBlue
                          : const Color.fromARGB(255, 168, 212, 247),

                      // border: Border.all(
                      //   width: 2,
                      //   color: AppColors.appPrimaryRed,
                      // ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.near_me_outlined,
                        color: AppColors.appWhite,
                        size: 20,
                      ),
                      onPressed: location.isEmpty
                          ? () {
                              showDialog(
                                context: context,
                                builder: (context) => CommonAlertDialog(
                                  message:
                                      "No location information is available for this doctor.",
                                ),
                              );
                            }
                          : () async {
                              final Uri url = Uri.parse(
                                'google.navigation:q=$location',
                              );

                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                final Uri fallback = Uri.parse(
                                  'https://www.google.com/maps/dir/?api=1&destination=$location',
                                );

                                await launchUrl(
                                  fallback,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: phone.isNotEmpty
                          ? AppColors.appPrimaryRed
                          : const Color.fromARGB(255, 245, 170, 165),
                      // border: Border.all(
                      //   width: 2,
                      //   color: AppColors.appPrimaryRed,
                      // ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.phone_in_talk_outlined,
                        color: AppColors.appWhite,
                        size: 20,
                      ),
                      onPressed: phone.isEmpty
                          ? () {
                              showDialog(
                                context: context,
                                builder: (context) => CommonAlertDialog(
                                  message:
                                      "This doctor's phone number is currently unavailable.",
                                ),
                              );
                            }
                          : () async {
                              final Uri url = Uri(
                                scheme: 'tel',
                                path: '+91$phone',
                              );

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
            ],
          ),
        ),
      ),
    );
  }
}
