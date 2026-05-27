import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:doctor_visit/apis/login/login_api_service.dart';
import 'package:doctor_visit/controller/login_controller/login_state.dart';
import 'package:doctor_visit/core/api_errors/api_errors.dart';
import 'package:doctor_visit/model/login/login_response_model.dart';
import 'package:doctor_visit/view/bottom_nav_screen/bottom_nav_screen.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(LoginState(pincontroller: TextEditingController()));

  int decryptValue({required String encryptedText, required String secretKey}) {
    try {
      // MD5-derived 16-byte key
      final keyBytes = md5.convert(utf8.encode(secretKey)).bytes;

      final key = encrypt.Key(Uint8List.fromList(keyBytes));

      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );

      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);

      log("Decrypted : $decrypted");

      return int.parse(decrypted);
    } catch (e) {
      log("Decrypt error : $e");
      return 0;
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
        final result = decryptValue(
          encryptedText: response.empid ?? '',
          secretKey: "sblw-3hn8-sqoy19",
        );

        log(result.toString());
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => BottomNavScreen()),
        //   (route) => false,
        // );
      }
      log("controller response $response");
    } catch (e) {
      log("Controller error : $e");

      AppMessage.show(context, e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginProvider = StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(),
);
