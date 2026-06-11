import 'package:flutter/material.dart';

class LoginState {
  final TextEditingController pincontroller;
  final TextEditingController baseUrlController;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  LoginState({
    required this.pincontroller,
    this.isLoading = false,
    required this.baseUrlController,
    required this.formKey,
  });

  LoginState copyWith({
    TextEditingController? pincontroller,
    bool? isLoading,
    TextEditingController? baseUrlController,
    GlobalKey<FormState>? formKey,
  }) {
    return LoginState(
      baseUrlController: baseUrlController ?? this.baseUrlController,
      pincontroller: pincontroller ?? this.pincontroller,
      isLoading: isLoading ?? this.isLoading,
      formKey: formKey ?? this.formKey,
    );
  }
}
