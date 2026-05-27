import 'package:flutter/material.dart';

class LoginState {
  final TextEditingController pincontroller;
  final bool isLoading;
  LoginState({required this.pincontroller, this.isLoading = false});

  LoginState copyWith({TextEditingController? pincontroller, bool? isLoading}) {
    return LoginState(
      pincontroller: pincontroller ?? this.pincontroller,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
