import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ValidationType { none, name, email, phone }

class TypeTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final bool isSuffix;
  final bool isNumber;
  final Icon preIcon;
  final ValidationType validationType;
  final bool isReadOnly;
  final Function(String)? onChanged;

  const TypeTextFormField({
    super.key,
    required this.hintText,
    required this.textController,
    this.isSuffix = false,
    this.isNumber = false,
    this.validationType = ValidationType.none,
    required this.preIcon,

    this.isReadOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        // textCapitalization: TextCapitalization.words,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: isNumber == true ? TextInputType.number : null,
        readOnly: isReadOnly ? true : false,
        controller: textController,
        inputFormatters: isNumber == true
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
            : null,
        onChanged: onChanged,
        // VALIDATION ONLY HERE
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) {
            return '$hintText is required';
          } else {
            switch (validationType) {
              case ValidationType.none:
                return null;

              case ValidationType.name:
                if (text.isEmpty) {
                  return 'Name is required';
                }
                if (text.length < 3) {
                  return 'Enter a valid name';
                }
                return null;

              case ValidationType.email:
                if (text.isEmpty) {
                  return 'Email is required';
                }

                final emailRegex = RegExp(
                  r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                );

                if (!emailRegex.hasMatch(text)) {
                  return 'Enter a valid email';
                }
                return null;

              case ValidationType.phone:
                if (text.isEmpty) {
                  return 'Phone number is required';
                }

                if (text.length != 10) {
                  return 'Enter a valid 10 digit phone number';
                }
                return null;
            }
          }
        },
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          prefixIcon: preIcon,

          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.appBlack),
          labelText: null,

          labelStyle: TextStyle(color: AppColors.appPrimaryRed),
          floatingLabelStyle: TextStyle(color: AppColors.appPrimaryRed),

          filled: true,
          fillColor: Color(0xFFFFEBEE),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none, // no visible border line
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),

          errorStyle: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
