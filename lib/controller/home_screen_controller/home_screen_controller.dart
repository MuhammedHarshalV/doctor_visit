import 'dart:developer';

import 'package:doctor_visit/apis/get_doctors/get_doctors_list_api.dart';
import 'package:doctor_visit/apis/work_completion_api/work_starts_api.dart';
import 'package:doctor_visit/controller/home_screen_controller/home_screen_state.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';

import 'package:doctor_visit/model/doctos_assign_get/doctors_assign_response_model.dart';
import 'package:doctor_visit/model/work_completion_and_start_duty/work_completion_and_start_duty_response_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenNotifier extends StateNotifier<HomeScreenState> {
  HomeScreenNotifier() : super(HomeScreenState()) {
    iniatialCall();
  }
  Future<void> iniatialCall() async {
    // await checkDatabaseStatus();
    await getDoctorsVisit();
  }

  @override
  void dispose() {
    log('Home controller Dispose.');
    super.dispose();
  }

  //get doctors visit list api

  Future<void> getDoctorsVisit() async {
    if (AppConstants.mstKey.isNotEmpty && AppConstants.mstKey != '0') {
      state = state.copyWith(isOn: true);
    }
    try {
      state = state.copyWith(isLoading: true);
      await Future.delayed(Duration(seconds: 1));
      final DoctorsAssignResponseModel? response =
          await GetDoctorsListApi.getDoctorsListApi(
            proID: AppConstants.employeeID,
          );
      if (response == null) {
        return;
      }
      if (response.status == true) {
        state = state.copyWith(doctorsListAPI: response.drList ?? []);
      }
      log('get doctors list : $response');
    } catch (e) {
      log("Controller error : $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  //work start and off api
  Future<void> startAndOffDuty({
    required String date,
    String? starttime,
    String? startLocation,
    String? endtime,
    String? endLocation,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final WorkCompletionAndStartDutyResponseModel? response =
          await PostWorkStartApi.postWorkStartApi(
            date: date,
            startTime: starttime,
            startLocation: startLocation,
            endLocation: endLocation,
            endTime: endtime,
          );
      if (response == null) {
        return;
      }
      if (response.status == true) {
        state = state.copyWith(workRetatedData: response.data);

        await prefs.setString(
          'mst_key',
          response.data?.proMstKey?.toString() ?? '',
        );

        await prefs.setString('Today_date', currentDate);
        AppConstants.mstKey = response.data?.proMstKey?.toString() ?? '';

        AppConstants.date = currentDate;
        log('date : ${AppConstants.date}');
        log('mstkey :${AppConstants.mstKey}');
        log('detkey :${AppConstants.detKey}');

        log('Stored mstkey : ${AppConstants.mstKey}');

        log('stored date : ${AppConstants.date}');
      }
      log('work update details : $response');
    } catch (e) {
      log("Controller error : $e");
    }
  }

  void setIsOn(bool isOn) {
    state = state.copyWith(isOn: isOn);
  }
}

// Provider for home screen
final homeScreenProvider =
    StateNotifierProvider.autoDispose<HomeScreenNotifier, HomeScreenState>((
      ref,
    ) {
      return HomeScreenNotifier();
    });
