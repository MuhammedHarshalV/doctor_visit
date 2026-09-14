import 'dart:developer';

import 'package:doctor_visit/apis/login/login_api_service.dart';
import 'package:doctor_visit/controller/login_controller/login_state.dart';
import 'package:doctor_visit/core/api_errors/api_errors.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'package:doctor_visit/core/routes/app_route_names.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/model/login/login_response_model.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController()
    : super(
        LoginState(
          pincontroller: TextEditingController(),
          baseUrlController: TextEditingController(),
          formKey: GlobalKey<FormState>(),
        ),
      );

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
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.appWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_outlined,
                  color: AppColors.appBlack,
                  size: 30,
                ),
                SizedBox(width: 8),
                Text(
                  "Alert",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  "Connection failed. Please check the Base URL settings and try again. If the issue persists, contact Icon Support.",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    state.pincontroller.clear();
                    state.baseUrlController.clear();
                    AppConstants.baseUrl = '';
                    context.goNamed(AppRouteNames.baseUrlScreen.name);
                    log("baseUrl ${AppConstants.baseUrl}");
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.appPrimaryRed,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Base URL',
                            style: TextStyle(color: AppColors.appWhite),
                          ),
                        ),
                        Icon(
                          Icons.replay_rounded,
                          color: AppColors.appWhite,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
          ),
        );
        return;
      }
      if (response.message == 'Invalid pin.') {
        // ignore: use_build_context_synchronously
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
          AppConstants.isProAssign = response.proAssignDr ?? false;
          AppConstants.isHiTech = response.isPro2 ?? false;

          await mstKeyAndDetKeyChecking();
          // ignore: use_build_context_synchronously
          AppConstants.isHiTech
              ? context.goNamed(AppRouteNames.homeScreen.name)
              : context.goNamed(AppRouteNames.bottomNavScreen.name);
        }
      }
      log("controller response $response");
    } catch (e) {
      log("Controller error : $e");

      // ignore: use_build_context_synchronously
      AppMessage.show(context, e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  //mstKey checking
  Future<void> mstKeyAndDetKeyChecking() async {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? mstKey = prefs.getString('mst_key');
    final String? detKey = prefs.getString('det_key');
    final String? date = prefs.getString('Today_date');
    final String? url = prefs.getString('BaseURL');
    if (url == null) {
      await prefs.setString('BaseURL', state.baseUrlController.text);
    }

    if (mstKey != null && mstKey.isNotEmpty) {
      AppConstants.mstKey = mstKey;
    }
    if (url != null && url.isNotEmpty) {
      AppConstants.baseUrl = url;
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
    log('Stored baseUrl : $url');

    if (AppConstants.date != currentDate) {
      await prefs.setString('mst_key', '');

      AppConstants.mstKey = '';

      log('mstkey :${AppConstants.mstKey}');
      log('detkey :${AppConstants.detKey}');
      log('date : ${AppConstants.date}');
      log('baseUrl : ${AppConstants.baseUrl}');
    }
  }
}

final loginProvider = StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(),
);
