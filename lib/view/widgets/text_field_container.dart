import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ValidationType { none, name, email, phone, url }

class TypeTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final bool isSuffix;
  final bool isNumber;
  final Icon preIcon;
  final bool isIncentive;
  final ValidationType validationType;
  final bool isReadOnly;
  final Function(String)? onChanged;

  const TypeTextFormField({
    super.key,
    required this.hintText,
    required this.textController,
    this.isSuffix = false,
    this.isNumber = false,
    this.isIncentive = false,
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
              case ValidationType.url:
                if (text.isEmpty) {
                  return 'URL is required';
                }

                if (!text.startsWith('http://') &&
                    !text.startsWith('https://')) {
                  return 'Enter a valid URL';
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
          suffixIcon: isSuffix
              ? InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTapDown: (details) {
                    dropDown(context, details.globalPosition, isIncentive);
                  },
                  child: Icon(Icons.arrow_drop_down, color: AppColors.appBlack),
                )
              : null,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: AppTextStyles.anekMalayalam(color: AppColors.appBlack),
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

  void dropDown(
    BuildContext context,
    Offset tapPosition,
    bool isIncentive,
  ) async {
    final screenSize = MediaQuery.of(context).size;

    final selected = await showMenu<String>(
      context: context,
      color: AppColors.appWhite,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        screenSize.width,
        screenSize.height - tapPosition.dy,
      ),
      items: isIncentive == true
          ? [
              PopupMenuItem(
                value: 'Yes',
                child: Text('Yes', style: AppTextStyles.anekMalayalam()),
              ),
              PopupMenuItem(
                value: 'No',
                child: Text('No', style: AppTextStyles.anekMalayalam()),
              ),
            ]
          : [
              PopupMenuItem(
                value: 'Male',
                child: Text('Male', style: AppTextStyles.anekMalayalam()),
              ),
              PopupMenuItem(
                value: 'Female',
                child: Text('Female', style: AppTextStyles.anekMalayalam()),
              ),
              PopupMenuItem(
                value: 'Others',
                child: Text('Others', style: AppTextStyles.anekMalayalam()),
              ),
            ],
    );

    if (selected != null) {
      textController.text = selected;

      // send value outside
      if (onChanged != null) {
        onChanged!(selected);
      }
    }
  }
}
