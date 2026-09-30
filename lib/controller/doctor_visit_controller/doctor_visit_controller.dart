import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doctor_visit/apis/work_completion_api/hi-tech_completion_api.dart';
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
    : super(
        DoctorVisitCompletion(
          feedbackController: TextEditingController(),
          placeController: TextEditingController(),
        ),
      );

  Future<void> isGoingStart({required String doctorID}) async {
    final IsGoingResponseModel response = await GetIsGoingApi.getIsGoingApi(
      doctorID: doctorID,
    );
    log('========${response.message}${response.status}');
  }

  Future<void> isGoingAndCompletionLocationSend({
    bool? isStart = false,
    bool? isCompleted = false,
    required BuildContext? context,
    required String doctorID,
    required String date,
    required String? startLocation,
    required String? startTime,
    required String? endLocation,
    required String? endTime,
    required String? feedback,

    required String? workstatus,
    required String? selfie,
  }) async {
    try {
      if (isStart == true) state = state.copyWith(isLoading: true);
      if (isCompleted == true) state = state.copyWith(isComplete: true);

      final WorkCompletionAndStartDutyResponseModel response =
          await PostWorkStartGoingApi.postWorkStartGoingApi(
            date: date,
            startTime: startTime,
            endTime: endTime,
            context: context,
            doctorID: doctorID,
            feedback: feedback,
            workstatus: workstatus,
            startLocation: startLocation,
            endLocation: endLocation,
            selfie: selfie,
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

        resetController();
      }
      log('==============$response');
    } catch (e) {
      log(e.toString());
    } finally {
      if (isStart == true) state = state.copyWith(isLoading: false);
      if (isCompleted == true) state = state.copyWith(isComplete: false);
    }
  }

  //is hi-tech
  Future<bool> hiTechCompletion({
    BuildContext? context,

    String? name,
    String? arrivalTime,
    String? date,
    String? doctorId,
    String? place,
    String? startTime,
    String? endTime,
    String? feedback,

    String? image,
  }) async {
    try {
      state = state.copyWith(isComplete: true);
      final Map<String, dynamic> data = {};

      if (name != null) {
        data['Pro_Name'] = name;
      }

      if (arrivalTime != null) {
        data['Pro_ArrTime'] = arrivalTime;
      }

      if (date != null) {
        data['Pro_Date'] = date;
      }

      if (doctorId != null) {
        data['Pro_DctrId'] = doctorId;
      }

      if (place != null) {
        data['Place'] = place;
      }
      if (startTime != null) {
        data['Pro_StartTime'] = startTime;
      }
      if (endTime != null) {
        data['Pro_EndTime'] = endTime;
      }
      if (feedback != null) {
        data['Pro_Remarks'] = feedback;
      }
      if (name != null) {
        data['Pro_UsrInfo'] = name;
      }
      if (image != null && image.isNotEmpty) {
        data['Pro_Img'] = await MultipartFile.fromFile(
          image,
          filename: image.split('/').last,
        );
      }

      data['Pro_Id'] = AppConstants.employeeID;

      final formData = FormData.fromMap(data);

      final response = await HiTechCompletionApi.hiTechCompletionApi(
        body: formData,
      );
      if (response == true) {
        resetController();
      }
      return response;
    } catch (e, stackTrace) {
      log('Update profile API error: $e', stackTrace: stackTrace);
    } finally {
      state = state.copyWith(isComplete: false);
    }
    return false;
  }

  void setStartTime(TimeOfDay? time) {
    state = state.copyWith(startTime: time);
  }

  void setArrivedTime(TimeOfDay? time) {
    state = state.copyWith(arrivedTime: time);
  }

  void base64ToApiUpdate(String imageString) {
    state = state.copyWith(base64toApi: imageString);
  }

  void setImagePath(String imagePath) {
    state = state.copyWith(imagePath: imagePath);
  }

  void updateResponse(String response) {
    state = state.copyWith(response: response);
  }

  void setPlace(String place) {
    state = state.copyWith(place: place);
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

  void resetController() {
    final feedbackController = state.feedbackController;
    final placeController = state.placeController;

    feedbackController.clear();
    placeController.clear();

    state = DoctorVisitCompletion(
      feedbackController: feedbackController,
      placeController: placeController,
    );
  }

  @override
  void dispose() {
    log('===== visit status controller =====');
    super.dispose();
  }
}

final doctorVisitProvider =
    StateNotifierProvider<VisitController, DoctorVisitCompletion>(
      (ref) => VisitController(),
    );
