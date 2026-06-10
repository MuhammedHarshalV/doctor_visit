import 'package:doctor_visit/core/routes/app_route_names.dart';
import 'package:doctor_visit/view/bottom_nav_screen/bottom_nav_screen.dart';
import 'package:doctor_visit/view/screens/add_doctor_screen/add_doctor.dart';
import 'package:doctor_visit/view/screens/home_screen/screen/home_screens.dart';
import 'package:doctor_visit/view/screens/login_screen/login_screen.dart';
import 'package:doctor_visit/view/screens/profile_screen/profile_screen.dart';
import 'package:doctor_visit/view/screens/progress_screen/screen/progress_screen.dart';
import 'package:doctor_visit/view/screens/visit_completion_screen/visit_completion_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRouteNames.loginScreen.route,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    // Splash Screen
    GoRoute(
      path: AppRouteNames.loginScreen.route,
      name: AppRouteNames.loginScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),

    //authentication routes
    GoRoute(
      path: AppRouteNames.bottomNavScreen.route,
      name: AppRouteNames.bottomNavScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return const BottomNavScreen();
      },
    ),
    GoRoute(
      path: AppRouteNames.homeScreen.route,
      name: AppRouteNames.homeScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: AppRouteNames.visitCompletionScreen.route,
      name: AppRouteNames.visitCompletionScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        final int index = state.extra as int;

        return VisitCompletionScreen(index: index);
      },
    ),
    GoRoute(
      path: AppRouteNames.addDoctorScreen.route,
      name: AppRouteNames.addDoctorScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return const AddDoctorScreen();
      },
    ),

    //bottom navigation screens
    GoRoute(
      path: AppRouteNames.progressScreen.route,
      name: AppRouteNames.progressScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return const ProgressScreen();
      },
    ),
    GoRoute(
      path: AppRouteNames.profileScreen.route,
      name: AppRouteNames.profileScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileScreen();
      },
    ),
  ],

  // Error page
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRouteNames.loginScreen.route),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  },
);
