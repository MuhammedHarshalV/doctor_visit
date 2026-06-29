import 'dart:developer';

import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/screens/assign_doctor/widgets/drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Function(String) onTap;
  final List<String>? item;

  const SelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    required BuildContext context,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) async {
        if (item != null) {
          DropDownWidget.showDropDown(context, details.globalPosition, item!, (
            value,
          ) {
            onTap(value);
          });
        } else {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.appPrimaryRed, // Header & selected date
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ),
                  datePickerTheme: DatePickerThemeData(
                    dayBackgroundColor: WidgetStateProperty.resolveWith((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.appPrimaryRed;
                      }
                      return null;
                    }),
                    dayForegroundColor: WidgetStateProperty.resolveWith((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white; // Makes selected date visible
                      }
                      return Colors.black;
                    }),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (pickedDate != null) {
            onTap(DateFormat('yyyy-MM-dd').format(pickedDate));
            log("${pickedDate.day.toString().padLeft(2, '0')}/");
          }
        }
      },
      // onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.appPrimaryRed, width: .5),
        ),
        child: Row(
          children: [
            // Styled Icon Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.appPrimaryRed.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFF05138), // Your primary brand red
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C333A),
                    ),
                  ),
                  if (subtitle != null) SizedBox(height: 4),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),

            // Forward Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
