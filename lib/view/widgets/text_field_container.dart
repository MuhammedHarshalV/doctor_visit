import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TypeTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final bool isSuffix;
  final bool isNumber;
  final Icon preIcon;

  final bool isReadOnly;
  final Function(String)? onChanged;

  const TypeTextFormField({
    super.key,
    required this.hintText,
    required this.textController,
    this.isSuffix = false,
    this.isNumber = false,

    required this.preIcon,

    this.isReadOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        keyboardType: isNumber == true ? TextInputType.number : null,
        readOnly: isReadOnly ? true : false,
        controller: textController,
        inputFormatters: isNumber == true
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
            : null,

        // VALIDATION ONLY HERE
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hintText is required';
          }
          return null;
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
                    genderDropDown(context, details.globalPosition);
                  },
                  child: Icon(Icons.arrow_drop_down, color: AppColors.appBlack),
                )
              : null,
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

  void genderDropDown(BuildContext context, Offset tapPosition) async {
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
      items: [
        PopupMenuItem(value: 'Male', child: Text('Male')),
        PopupMenuItem(value: 'Female', child: Text('Female')),
        PopupMenuItem(value: 'Others', child: Text('Others')),
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
