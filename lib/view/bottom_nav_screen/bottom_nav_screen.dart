import 'package:doctor_visit/controller/add_doctor_controller/add_doctor_controller.dart';
import 'package:doctor_visit/controller/bottom_nav_screen/bottom_nav_controller.dart';
import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:doctor_visit/controller/home_screen_controller/home_screen_controller.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';

import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/add_doctor_screen/add_doctor.dart';
import 'package:doctor_visit/view/screens/home_screen/screen/home_screens.dart';
import 'package:doctor_visit/view/screens/progress_screen/screen/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(tabControllerProvider);
    final bottomNavState = ref.watch(bottomNavProvider);
    final bottomNavNotifier = ref.read(bottomNavProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.appPrimaryRed,
        statusBarIconBrightness: Brightness.dark, // Android icons
        statusBarBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: PopScope(
          canPop: false,
          // ignore: deprecated_member_use
          onPopInvoked: (didPop) async {
            if (bottomNavState.currentIndex == 0) {
              //  Exit app
              SystemNavigator.pop();
            } else {
              //  Go to Home tab
              controller.jumpToTab(0);
              bottomNavNotifier.setIndex(0);
            }
          },
          child: PersistentTabView(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            context,
            controller: controller,
            screens: _buildScreens(),
            items: _navBarsItems(context),

            navBarStyle: NavBarStyle.style9,
            confineToSafeArea: true,
            backgroundColor: AppColors.appWhite,
            handleAndroidBackButtonPress: false,
            //resizeToAvoidBottomInset: true,

            //hideNavigationBarWhenKeyboardShows: true,
            stateManagement: true,
            onItemSelected: (index) {
              if (index == 1) {
                bottomNavNotifier.setIndex(0);

                controller.jumpToTab(0);
              }
              final currentIndex = bottomNavState.currentIndex;

              // Dispose the screen we are leaving
              switch (currentIndex) {
                case 0:
                  if (index != 0) {
                    ref.invalidate(dayExpenseProvider);
                    ref.invalidate(addDoctorProvider);
                  }
                  break;

                case 1:
                  if (index != 1) {
                    ref.invalidate(dayExpenseProvider);
                    ref.invalidate(homeScreenProvider);
                  }
                  break;

                case 2:
                  if (index != 2) {
                    ref.invalidate(homeScreenProvider);
                    ref.invalidate(addDoctorProvider);
                  }
                  break;
              }
              // Change tab

              bottomNavNotifier.setIndex(index);
              // }
            },
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(90),
              border: Border.all(color: AppColors.appWhite, width: .5),
              colorBehindNavBar: Theme.of(
                context,
                // ignore: deprecated_member_use
              ).scaffoldBackgroundColor.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [HomeScreen(), AddDoctorScreen(), ProgressScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        inactiveIcon: Icon(Icons.home),
        title: "Home",
        textStyle: AppTextStyles.anekMalayalam(fontWeight: FontWeight.w500),
        activeColorPrimary: AppColors.appPrimaryRed,
        inactiveColorPrimary: AppColors.appDarkGrey,
      ),
      PersistentBottomNavBarItem(
        title: 'Add Doctor',
        icon: Icon(Icons.add_box_outlined),
        textStyle: AppTextStyles.anekMalayalam(fontWeight: FontWeight.w500),
        inactiveIcon: Icon(Icons.add_box_outlined),
        activeColorPrimary: AppColors.appPrimaryRed,
        inactiveColorPrimary: AppColors.appDarkGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.bar_chart),
        inactiveIcon: Icon(Icons.leaderboard_outlined),
        title: 'Progress',
        textStyle: AppTextStyles.anekMalayalam(fontWeight: FontWeight.w500),
        activeColorPrimary: AppColors.appPrimaryRed,
        inactiveColorPrimary: AppColors.appDarkGrey,
      ),
    ];
  }
}
