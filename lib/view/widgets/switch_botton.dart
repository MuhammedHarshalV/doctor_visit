import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/core/services/location_services/location_services.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class CustomSwitchButton extends ConsumerWidget {
  const CustomSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeScreenProvider);
    final homeController = ref.read(homeScreenProvider.notifier);

    return GestureDetector(
      onTap: () async {
        //must check steps
        //1 network on location off  yes
        //2 network of location off  yes
        //3 network on location on   yes
        //4 network of location on

        bool isConnected = await checkInternetConnection();
        log("1========${isConnected.toString()}");

        if (isConnected) {
          log("Internet ON");
        } else {
          log("2========${isConnected.toString()}");
          log("Internet OFF");
        }

        if (homeState.isOn == false && isConnected == true) {
          try {
            log(homeState.isOn.toString());
            homeController.setIsOn(true);
            Position position = await getCurrentLocation();
            String currentTime = DateTime.now().toIso8601String();
            String currentDate = DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now());
            String mapUrl =
                "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

            log("Time: $currentTime");
            log("Date: $currentDate");
            log("Lat: ${position.latitude}");
            log("Lng: ${position.longitude}");
            log(mapUrl);
            homeController.startAndOffDuty(
              date: currentDate,
              starttime: currentTime,
              startLocation: mapUrl,
            );
            // if (context.mounted) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(
            //         "Location sent at ${currentTime.hour}: ${currentTime.minute}  $mapUrl",
            //         style: TextStyle(
            //           color: AppColors.appWhite,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       backgroundColor: Colors.green,
            //       behavior: SnackBarBehavior.floating,
            //       margin: EdgeInsets.only(
            //         bottom: MediaQuery.of(context).size.height - 120,
            //         left: 16,
            //         right: 16,
            //       ),
            //     ),
            //   );
            // }
            //  Example: send to API / show / store
          } catch (e) {
            log("harshal==================${e.toString()}");
            homeController.setIsOn(false);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.toString(),
                    style: TextStyle(
                      color: AppColors.appWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.blue,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 120,
                    left: 16,
                    right: 16,
                  ),
                ),
              );
            }
          }
        } else if (homeState.isOn == false && isConnected == false) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // padding: EdgeInsets.all(10),
                content: Text(
                  "No internet connection. Please try again when the network is available.",
                  style: AppTextStyles.anekMalayalam(
                    color: AppColors.appBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColors.appWhite,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 120,
                  left: 16,
                  right: 16,
                ),
              ),
            );
          }
        } else if (homeState.isOn == true && isConnected == true) {
          try {
            log(homeState.isOn.toString());
            homeController.setIsOn(false);
            Position position = await getCurrentLocation();
            String currentTime = DateTime.now().toIso8601String();
            String currentDate = DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now());
            String mapUrl =
                "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

            log("Time: $currentTime");
            log("date: $currentDate");

            log("Lat: ${position.latitude}");
            log("Lng: ${position.longitude}");
            log(mapUrl);
            homeController.startAndOffDuty(
              date: currentDate,
              endtime: currentTime,
              endLocation: mapUrl,
            );
          } catch (e) {
            log("harshal==================${e.toString()}");
            homeController.setIsOn(true);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.toString(),
                    style: AppTextStyles.anekMalayalam(),
                  ),
                  backgroundColor: Colors.blue,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height - 120,
                    left: 16,
                    right: 16,
                  ),
                ),
              );
            }
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // padding: EdgeInsets.all(10),
                content: Text(
                  "No internet connection. Please try again when the network is available.",
                  style: AppTextStyles.anekMalayalam(
                    color: AppColors.appBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColors.appWhite,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 120,
                  left: 16,
                  right: 16,
                ),
              ),
            );
          }
        }
        // update via Riverpod
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 70,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: homeState.isOn == true
              ? const Color(0xFF4CAF50)
              : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Text
            Align(
              alignment: homeState.isOn == true
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  homeState.isOn == true ? "On" : "Off",
                  style: AppTextStyles.anekMalayalam(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            //  Moving circle
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: homeState.isOn == true
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  homeState.isOn == true ? Icons.check : Icons.close,
                  size: 16,
                  color: homeState.isOn == true ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    log(connectivityResult.toString());

    // ignore: unrelated_type_equality_checks
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }
}
