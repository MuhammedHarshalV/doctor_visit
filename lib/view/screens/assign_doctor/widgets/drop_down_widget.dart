import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';

class DropDownWidget {
  static void showDropDown(
    BuildContext context,
    Offset tapPosition,
    List<String> items,
    final Function(String)? onChanged,
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
      items: items.map((item) {
        return PopupMenuItem<String>(value: item, child: Text(item,style:  AppTextStyles.anekMalayalam(),));
      }).toList(),
      constraints: BoxConstraints(maxHeight: screenSize.height / 2),
    );

    if (selected != null) {
      if (onChanged != null) {
        onChanged(selected);
      }
    }
  }
}
