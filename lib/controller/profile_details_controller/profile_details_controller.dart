import 'dart:developer';

import 'package:doctor_visit/apis/pro_details/get_pro_details_api.dart';

import 'package:doctor_visit/controller/profile_details_controller/profile_details_state.dart';

import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/model/profile/pro_profile_details_response_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDetailsController extends StateNotifier<ProfileDetailsState> {
  ProfileDetailsController() : super(ProfileDetailsState());
  Future<void> getProProfileDetails() async {
    try {
      state = state.copyWith(isLoading: true);
      final ProProfileDetailsResponseModel? response =
          await GetProDetailsApi.getProDetailsApi(
            proID: AppConstants.employeeID,
          );
      if (response == null) {
        return;
      }
      if (response.status == true) {
        state = state.copyWith(profileDetails: response.details ?? []);
      }
      log('get profile list : $response');
    } catch (e) {
      log("Controller error : $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final profileDetailsProvider =
    StateNotifierProvider<ProfileDetailsController, ProfileDetailsState>(
      (ref) => ProfileDetailsController(),
    );
