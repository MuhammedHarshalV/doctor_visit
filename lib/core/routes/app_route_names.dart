enum AppRouteNames {
  splashScreen(route: '/', name: 'splashScreen'),
  baseUrlScreen(route: '/baseUrlScreen', name: 'baseUrlScreen'),
  homeScreen(route: '/homeScreen', name: 'homeScreen'),
  addDoctorScreen(route: '/addDoctorScreen', name: 'addDoctorScreen'),
  visitCompletionScreen(
    route: '/visitCompletionScreen',
    name: 'visitCompletionScreen',
  ),

  loginScreen(route: '/loginScreen', name: 'loginScreen'),

  bottomNavScreen(route: '/bottomNavScreen', name: 'bottomNavScreen'),

  progressScreen(route: '/progressScreen', name: 'progressScreen'),
  assignedScreen(route: '/assignedScreen', name: 'assignedScreen'),

  profileScreen(route: '/profileScreen', name: 'profileScreen');

  final String route;
  final String name;

  const AppRouteNames({required this.route, required this.name});
}
