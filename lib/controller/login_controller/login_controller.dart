import 'dart:developer';

import 'package:doctor_visit/apis/login/login_api_service.dart';
import 'package:doctor_visit/controller/login_controller/login_state.dart';
import 'package:doctor_visit/core/api_errors/api_errors.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/model/login/login_response_model.dart';
import 'package:doctor_visit/view/bottom_nav_screen/bottom_nav_screen.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(LoginState(pincontroller: TextEditingController()));

  void decryptValue({
    required String encryptedUsername,
    required String secretKey,
    required String encryptedEmployeeID,
  }) {
    try {
      final key = encrypt.Key.fromUtf8(secretKey);

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'),
      );

      final decryptedName = encrypter.decrypt64(encryptedUsername);
      final decryptedEmployeeID = encrypter.decrypt64(encryptedEmployeeID);

      log("Decrypted username: $decryptedName");
      log("Decrypted employeeId: $decryptedEmployeeID");

      AppConstants.userName = decryptedName;
      AppConstants.employeeID = decryptedEmployeeID;
    } catch (e) {
      log("Decrypt error: $e");
    }
  }

  //login api calling
  Future<void> loginApiCalling({
    required String pin,
    required BuildContext context,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final LoginResponseModel? response =
          await LoginApiService.loginApiService(pin: pin, context: context);
      if (response == null) {
        return;
      }
      if (response.message == 'Invalid pin.') {
        AppMessage.show(context, "Invalid pin.");
        return;
      } else {
        decryptValue(
          encryptedUsername: response.username ?? '',
          encryptedEmployeeID: response.empid ?? '',
          secretKey: "sblw-3hn8-sqoy19",
        );

        if (response.success == true) {
          AppConstants.yearID = response.yrId.toString();
          mstKeyAndDetKeyChecking();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavScreen()),
            (route) => false,
          );
        }
      }
      log("controller response $response");
    } catch (e) {
      log("Controller error : $e");

      AppMessage.show(context, e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  //mstKey checking
  Future<void> mstKeyAndDetKeyChecking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? mstKey = prefs.getString('mst_key');
    final String? detKey = prefs.getString('det_key');
    final String? date = prefs.getString('Today_date');

    if (mstKey != null && mstKey.isNotEmpty) {
      AppConstants.mstKey = mstKey;
    }
    if (detKey != null && detKey.isNotEmpty) {
      AppConstants.detKey = detKey;
    }
    if (date != null && date.isNotEmpty) {
      AppConstants.date = date;
    }

    log('Stored mstkey : $mstKey');
    log('Stored detKey : $detKey');
    log('Stored date : $date');
  }
}

final loginProvider = StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(),
);
