import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/routes/app_route_names.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/home_screen/widget/doctor_list_shimmer.dart';
import 'package:doctor_visit/view/widgets/common_appbar.dart';
import 'package:doctor_visit/view/screens/home_screen/widget/doctor_visits_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                    if (AppConstants.isHiTech == true) SizedBox(height: 10),
                    if (AppConstants.isHiTech == true)
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onTap: () {
                          context.pushNamed(AppRouteNames.assignedScreen.name);
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.appPrimaryRed),
                            // color: AppColors.appBlue.withOpacity(.7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Assign Doctors',
                                  style: AppTextStyles.anekMalayalam(
                                    color: AppColors.appPrimaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_outward_sharp,
                                  color: AppColors.appPrimaryRed,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (AppConstants.isHiTech == true) SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today Visits",
                              style: AppTextStyles.anekMalayalam(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${homeScreenWatch.doctorsListAPI.length} doctors scheduled today",
                              style: AppTextStyles.anekMalayalam(
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
                                    style: AppTextStyles.anekMalayalam(
                                      color: Colors.white,
                                    ),
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
                        child: Center(
                          child: Text(
                            'No doctors have been assigned to you yet.',
                            style: AppTextStyles.anekMalayalam(),
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
                                : doctor.visitStatus == 0
                                ? 0
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
