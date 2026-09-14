import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:flutter/material.dart';

class CommonDiscrptionDecoration extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;

  const CommonDiscrptionDecoration({
    super.key,
    required this.hint,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.anekMalayalam(),
        filled: true,
        fillColor: const Color.fromARGB(255, 245, 194, 113),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
