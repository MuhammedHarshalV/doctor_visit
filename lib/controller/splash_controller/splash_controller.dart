import 'dart:developer';

import 'package:doctor_visit/controller/splash_controller/splash_state.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum SplashNavigationState { loading, login, baseUrl }

class SplashNotifierController extends StateNotifier<SplashState> {
  SplashNotifierController() : super(const SplashState()) {
    _initialize();
  }
  @override
  void dispose() {
    log(
      'Splash controller disposed---------------------------------------------------------',
    );
    super.dispose();
  }

  Future<void> _initialize() async {
    await Future.wait([checkInitialRoute()]);
  }

  Future<void> checkInitialRoute() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? baseUrl = prefs.getString('BaseURL');

    await Future.delayed(const Duration(seconds: 2)).then((value) {
      if (baseUrl != null && baseUrl.isNotEmpty) {
        AppConstants.baseUrl = baseUrl;
        log('Stored BaseUrl : $baseUrl');
        return state = state.copyWith(
          navigationScreen: SplashNavigationState.login,
        );
      } else {
        log('Stored BaseUrl : $baseUrl');
        return state = state.copyWith(
          navigationScreen: SplashNavigationState.baseUrl,
        );
      }
    });
  }
}

final splashDisposeProvider =
    StateNotifierProvider<SplashNotifierController, SplashState>((ref) {
      return SplashNotifierController();
    });
final splashProvider =
    StateNotifierProvider<SplashNotifierController, SplashState>((ref) {
      return SplashNotifierController();
    });

final splashScreenProvider = Provider<SplashNavigationState>((ref) {
  return ref.watch(splashProvider).navigationScreen;
});
