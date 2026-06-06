import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/home_screen/widget/doctor_list_shimmer.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RefreshIndicator(
              color: AppColors.appPrimaryRed, // spinner color
              backgroundColor: AppColors.appLightRed, // circle background
              strokeWidth: 2,
              onRefresh: () async {
                await homeScreenRead.getDoctorsVisit();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
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
                              "${homeScreenWatch.doctorsListAPI.length} doctors scheduled today",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 40,
                          width: 70,
                          decoration: BoxDecoration(
                            color: AppColors.appPrimaryRed,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: homeScreenWatch.isLoading
                              ? Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.appWhite,
                                      strokeWidth: 1,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "${homeScreenWatch.doctorsListAPI.length}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (homeScreenWatch.doctorsListAPI.isEmpty &&
                        homeScreenWatch.isLoading == false)
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: const Center(
                          child: Text(
                            'No doctors have been assigned to you yet.',
                          ),
                        ),
                      ),
                    if (homeScreenWatch.isLoading) DoctorListShimmer(),
                    if (homeScreenWatch.isLoading == false)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: homeScreenWatch.doctorsListAPI.length,
                        itemBuilder: (context, index) {
                          final doctor = homeScreenWatch.doctorsListAPI[index];
                          return DoctorCard(
                            indexGet: index,
                            name: doctor.drName ?? '',
                            address: doctor.drAddress ?? '',
                            phone: (doctor.drPhone?.length ?? 0) >= 10
                                ? doctor.drPhone!.substring(0, 10)
                                : doctor.drPhone?.trim() ?? '',
                            location: doctor.drLocation ?? '',
                            initial: doctor.drName?.isNotEmpty == true
                                ? doctor.drName![0]
                                : 'A',
                            isDone: doctor.visitStatus == null
                                ? null
                                : doctor.visitStatus == 1
                                ? 1
                                : 2,
                            isSelected: doctor.drIsGoing == true ? true : false,
                          );
                        },
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                      ),

                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
