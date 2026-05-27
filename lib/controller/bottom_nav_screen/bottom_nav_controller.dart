import 'package:doctor_visit/controller/bottom_nav_screen/bottom_nav_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavNotifier extends StateNotifier<BottomNavState> {
  BottomNavNotifier() : super(BottomNavState(currentIndex: 0));

  void setIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

// Provider for bottom navigation
final bottomNavProvider =
    StateNotifierProvider<BottomNavNotifier, BottomNavState>((ref) {
      return BottomNavNotifier();
    });

// Provider for PersistentTabController
final tabControllerProvider = Provider<PersistentTabController>((ref) {
  final controller = PersistentTabController(initialIndex: 0);

  // Listen to bottom nav state changes and update controller
  ref.listen<BottomNavState>(bottomNavProvider, (previous, next) {
    if (previous?.currentIndex != next.currentIndex) {
      controller.jumpToTab(next.currentIndex);
    }
  });

  return controller;
});
