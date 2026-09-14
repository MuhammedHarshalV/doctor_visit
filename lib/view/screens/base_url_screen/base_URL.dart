import 'package:doctor_visit/controller/login_controller/login_controller.dart';
import 'package:doctor_visit/core/constants/app_constants.dart';
import 'dart:developer';
import 'package:doctor_visit/core/routes/app_route_names.dart';
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BaseUrlScreen extends ConsumerWidget {
  const BaseUrlScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.appWhite,
        statusBarIconBrightness: Brightness.dark, // Android icons
        statusBarBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.appWhite,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: loginState.formKey,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'asset/image/iconinfoware logo.png',
                      width: MediaQuery.of(context).size.width / 1.2,

                      fit: BoxFit.fill,
                    ),
                  ),
                  // SizedBox(height: 7),
                  TypeTextFormField(
                    hintText: 'BaseURL',
                    textController: loginState.baseUrlController,
                    preIcon: Icon(Icons.link_sharp),
                    validationType: ValidationType.url,
                  ),

                  //  TopText(heading: 'Branch ID'),
                  // SizedBox(height: 7),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appPrimaryRed,
                        padding: const EdgeInsets.symmetric(
                          //vertical: 10,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (loginState.formKey.currentState!.validate()) {
                          AppConstants.baseUrl = loginState
                              .baseUrlController
                              .text
                              .trim();

                          log('baseUrl ${AppConstants.baseUrl}');

                          context.goNamed(AppRouteNames.loginScreen.name);
                        }
                      },
                      child: Text(
                        "Sumbit",
                        style:  AppTextStyles.anekMalayalam(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
