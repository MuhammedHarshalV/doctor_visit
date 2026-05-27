import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/widgets/common_appbar.dart';
import 'package:doctor_visit/view/screens/home_screen/widget/doctor_visits_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeScreenWatch = ref.watch(homeScreenProvider);
    final homeScreenRead = ref.read(homeScreenProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.appPrimaryRed,
        statusBarIconBrightness: Brightness.dark, // Android icons
        statusBarBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.appWhite,
          appBar: const CommonAppBar(
            title: "HealthCare",
            subtitle: "Welcome back",
          ),

          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                spacing: 5,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today Visits",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${homeScreenWatch.doctorsList.length} doctors scheduled today",
                            style: TextStyle(
                              color: AppColors.appGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.appPrimaryRed, // healthRed
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "${homeScreenWatch.doctorsList.length}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  if (homeScreenWatch.doctorsList.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: Text(
                          'No doctors have been assigned to you yet.',
                        ),
                      ),
                    ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: homeScreenWatch.doctorsList.length,

                    itemBuilder: (context, index) {
                      return DoctorCard(
                        indexGet: index,
                        name: homeScreenWatch.doctorsList[index].name,
                        specialty:
                            homeScreenWatch.doctorsList[index].speciality,
                        phone: homeScreenWatch.doctorsList[index].phoneNumber,
                        time: homeScreenWatch.doctorsList[index].timing,
                        initial: homeScreenWatch.doctorsList[index].name[0],
                        isDone: homeScreenWatch.doctorsList[index].status,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                  ),
                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
