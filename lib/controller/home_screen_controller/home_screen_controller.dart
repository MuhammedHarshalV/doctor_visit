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
    if (AppConstants.mstKey.isNotEmpty) {
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

        if (AppConstants.mstKey.isEmpty) {
          await prefs.setString(
            'mst_key',
            response.data?.proMstKey?.toString() ?? '',
          );
          await prefs.setString(
            'det_key',
            response.data?.proDetKey?.toString() ?? '',
          );
          await prefs.setString('Today_date', currentDate);
          AppConstants.mstKey = response.data?.proMstKey?.toString() ?? '';
          AppConstants.detKey = response.data?.proDetKey?.toString() ?? '';
          AppConstants.date = currentDate;
          log('date : ${AppConstants.date}');
          log('mstkey :${AppConstants.mstKey}');
          log('detkey :${AppConstants.detKey}');
        }

        log('Stored mstkey : ${AppConstants.mstKey}');
        log('Stored detKey : ${AppConstants.detKey}');
        log('stored date : ${AppConstants.date}');
      } else if (AppConstants.date != currentDate) {
        await prefs.setString(
          'mst_key',
          response.data?.proMstKey?.toString() ?? '',
        );
        await prefs.setString(
          'det_key',
          response.data?.proDetKey?.toString() ?? '',
        );
        await prefs.setString('Today_date', currentDate);
        AppConstants.mstKey = response.data?.proMstKey?.toString() ?? '';
        AppConstants.detKey = response.data?.proDetKey?.toString() ?? '';
        AppConstants.date = currentDate;
        log('mstkey :${AppConstants.mstKey}');
        log('detkey :${AppConstants.detKey}');
        log('date : ${AppConstants.date}');
      }
      log('work update details : $response');
    } catch (e) {
      log("Controller error : $e");
    }
  }

  //  Open Box ──
  // Future<Box> _openBox() async {
  //   if (Hive.isBoxOpen('DoctorList')) {
  //     return Hive.box('DoctorList');
  //   }
  //   return await Hive.openBox('DoctorList');
  // }

  //  Read All
  // Future<void> checkDatabaseStatus() async {
  //   try {
  //     final box = await _openBox();
  //     final List<DoctorModel> doctorsList = box.values.map((e) {
  //       final map = Map<String, dynamic>.from(e);
  //       return DoctorModel(
  //         name: map['name'] ?? '',
  //         speciality: map['speciality'] ?? '',
  //         phoneNumber: map['pnoneNumber'] ?? '',
  //         timing: map['timing'] ?? '',
  //         status: map['status'] ?? '',
  //         isGoing: map['isGo'] ?? '',
  //         isReach: map['isReach'] ?? '',
  //       );
  //     }).toList();
  //     log('All History of Doctorlist(Hive): $doctorsList');
  //     state = state.copyWith(doctorsList: doctorsList);
  //   } catch (e) {
  //     log('checkDatabaseStatus error(Hive): $e');
  //   }
  // }

  //  Save to Doctors
  // Future<bool> saveToHive({
  //   required String name,
  //   required String speciality,
  //   required String phoneNumber,
  //   required String timing,
  //   required String status,
  //   required String isStartGoing,
  // }) async {
  //   try {
  //     final box = await _openBox();
  //     final requestData = {
  //       "name": name,
  //       'speciality': speciality,
  //       "pnoneNumber": phoneNumber,
  //       "timing": timing,
  //       "status": status,
  //     };
  //     await box.add(requestData);
  //     checkDatabaseStatus();
  //     log('Saved data(Hive) : $requestData');
  //     return true;
  //   } catch (e) {
  //     log('saveToHive error: $e');
  //     return false;
  //   }
  // }

  //Edit hive
  //   Future<void> updateDoctor(
  //     int index,
  //     String updatedStatus,
  //     String? time,
  //     bool isStartGoing,
  //   ) async {
  //     try {
  //       final box = await _openBox();
  //       final oldData = Map<String, dynamic>.from(box.getAt(index));
  //       oldData['status'] = updatedStatus;
  //       oldData['timing'] = time ?? '1:00';
  //       // save updated data
  //       await box.putAt(index, oldData); //Update Both No Issue
  //       log('Updated status at $index: $updatedStatus');
  //       log('Updated status at $index: $time');
  //       await checkDatabaseStatus();
  //       state = state.copyWith(isStartGoing: isStartGoing);
  //     } catch (e) {
  //       log('updateJobRequest error: $e');
  //     }
  //   }

  //   //edit Isgoing
  //   Future<void> updateIsGoing(
  //     int index,
  //     String isGoing,
  //     bool isStartGoing,
  //   ) async {
  //     try {
  //       final box = await _openBox();
  //       final oldData = Map<String, dynamic>.from(box.getAt(index));
  //       // update only status
  //       oldData['isGo'] = isGoing;

  //       // save updated data
  //       await box.putAt(index, oldData);
  //       log('Updated status at $index: $isGoing');
  //       state = state.copyWith(isStartGoing: isStartGoing);
  //       await checkDatabaseStatus();
  //     } catch (e) {
  //       log('updateJobRequest error: $e');
  //     }
  //   }

  //   //edit isReach
  //   Future<void> updateIsReach(int index, String isReach) async {
  //     try {
  //       final box = await _openBox();
  //       final oldData = Map<String, dynamic>.from(box.getAt(index));

  //       // update only status
  //       oldData['isReach'] = isReach;

  //       // save updated data
  //       await box.putAt(index, oldData);

  //       log('Updated status at $index: $isReach');

  //       await checkDatabaseStatus();
  //     } catch (e) {
  //       log('updateJobRequest error: $e');
  //     }
  //   }

  //   void setIndex(int index) {
  //     state = state.copyWith(doctorCount: index);
  //   }

  void setIsOn(bool isOn) {
    state = state.copyWith(isOn: isOn);
  }

  //   void setIsGoing(bool isGoing) {
  //     state = state.copyWith(isGoing: isGoing);
  //   }
}

// Provider for home screen
final homeScreenProvider =
    StateNotifierProvider.autoDispose<HomeScreenNotifier, HomeScreenState>((
      ref,
    ) {
      return HomeScreenNotifier();
    });
