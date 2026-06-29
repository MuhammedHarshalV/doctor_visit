import 'dart:developer';
import 'dart:typed_data';


import 'package:doctor_visit/apis/work_completion_api/pro_is_going.dart';
import 'package:doctor_visit/apis/work_completion_api/work_start_going_api.dart';
import 'package:doctor_visit/controller/doctor_visit_controller/doctor_visit_state.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/model/work_completion_and_start_duty/is_going_response_model.dart';
import 'package:doctor_visit/model/work_completion_and_start_duty/work_completion_and_start_duty_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitController extends StateNotifier<DoctorVisitCompletion> {
  VisitController()
    : super(DoctorVisitCompletion(feedbackController: TextEditingController()));

  Future<void> isGoingStart({required String doctorID}) async {
    final IsGoingResponseModel response = await GetIsGoingApi.getIsGoingApi(
      doctorID: doctorID,
    );
    log('========${response.message}${response.status}');
  }

  Future<void> isGoingAndCompletionLocationSend({
    bool? isStart = false,
    bool? isCompleted = false,
    required String doctorID,
    required String date,
    required String? startLocation,
    required String? startTime,
    required String? endLocation,
    required String? endTime,
    required String? feedback,
    required String? detKey,
    required String? workstatus,
    required String? base64Image,
  }) async {
    try {
      if (isStart == true) state = state.copyWith(isLoading: true);
      if (isCompleted == true) state = state.copyWith(isComplete: true);

      final WorkCompletionAndStartDutyResponseModel response =
          await PostWorkStartGoingApi.postWorkStartGoingApi(
            date: date,
            startTime: startTime,
            endTime: endTime,
            detKey: detKey,
            doctorID: doctorID,
            feedback: feedback,
            workstatus: workstatus,
            startLocation: startLocation,
            endLocation: endLocation,
            base64Image: base64Image,
          );
      if (response.status == true) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        state = state.copyWith(response: response.message);
        await prefs.setString(
          'det_key',
          response.data?.proDetKey?.toString() ?? '',
        );
        AppConstants.detKey = response.data?.proDetKey?.toString() ?? '';
        log('stored det_key :${AppConstants.detKey}');
        state = state.copyWith(
          base64toApi: '',
          startTime: null,
          endTime: null,
          base64Image: Uint8List(0),
        );
      }
      log('==============$response');
    } catch (e) {
      log(e.toString());
    } finally {
      if (isStart == true) state = state.copyWith(isLoading: false);
      if (isCompleted == true) state = state.copyWith(isComplete: false);
    }
  }

  void setStartTime(TimeOfDay? time) {
    state = state.copyWith(startTime: time);
  }

  void updateImage(Uint8List? image) {
    state = state.copyWith(base64Image: image);
  }

  void base64ToApiUpdate(String imageString) {
    state = state.copyWith(base64toApi: imageString);
  }

  void updateResponse(String response) {
    state = state.copyWith(response: response);
  }

  void setIsGoing(bool isGoing) {
    state = state.copyWith(isGoing: isGoing);
  }

  void setIsCompleted(bool isCompleted) {
    state = state.copyWith(isCompleted: isCompleted);
  }

  void setEndTime(TimeOfDay? time) {
    state = state.copyWith(endTime: time);
  }

  void setPostponedTime(TimeOfDay? time) {
    state = state.copyWith(postponedTime: time);
  }
}

final doctorVisitProvider =
    StateNotifierProvider<VisitController, DoctorVisitCompletion>(
      (ref) => VisitController(),
    );
