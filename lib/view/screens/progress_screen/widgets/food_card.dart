// ============================================================
// food_card.dart — Redesigned
// ============================================================
import 'package:doctor_visit/core/theme/app_texts/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';

class FoodCard extends StatelessWidget {
  final String? isApproavedAmount;
  final bool isWeekly;
  final bool? isApproved;
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final VoidCallback onEdit;

  const FoodCard({
    super.key,
    this.isApproved,
    this.isApproavedAmount,
    required this.isWeekly,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.onEdit,
  });

  // ── Icon per category ──
  IconData get _categoryIcon {
    switch (title.toLowerCase()) {
      case 'food':
        return Icons.restaurant_outlined;
      case 'petrol':
        return Icons.local_gas_station_outlined;
      case 'travel':
        return Icons.directions_car_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  Color get colorGet {
    switch (title.toLowerCase()) {
      case 'food':
        return const Color.fromARGB(255, 121, 228, 124);
      case 'petrol':
        return const Color.fromARGB(255, 234, 135, 128);
      case 'travel':
        return const Color.fromARGB(255, 129, 192, 243);
      default:
        return Colors.grey;
    }
  }

  // ── Colors ──

  // Color get _iconBg =>
  //     isWeekly ? const Color(0xFFC0DD97) : const Color(0xFFF09595);

  // Color get _titleColor =>
  //     isWeekly ? const Color(0xFF27500A) : const Color(0xFF791F1F);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 253, 250, 250),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: AppColors.appGrey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Category icon box
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorGet),
                  ),
                  child: Icon(_categoryIcon, size: 18, color: colorGet),
                ),

                SizedBox(width: 10),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.anekMalayalam(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorGet,
                    ),
                  ),
                ),

                if (isWeekly)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: AppColors.appGrey),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 13,
                              color: Color(0xFF27500A),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isApproved == true ? 'Approved' : 'Waiting',
                              style: AppTextStyles.anekMalayalam(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF27500A),
                              ),
                            ),
                          ],
                        ),
                        if (isApproavedAmount != null)
                          Text(
                            "₹ $isApproavedAmount",
                            style: TextStyle(
                              color: const Color(0xFF27500A),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),

                // if (!isWeekly)
                //   Container(
                //     decoration: BoxDecoration(
                //       color: const Color(0xFFFFEBEE),
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     height: 50,
                //     width: 50,
                //     child: Image.network(
                //       imageUrl,
                //       fit: BoxFit.cover,
                //       errorBuilder: (context, error, stackTrace) {
                //         return const Center(
                //           child: Icon(
                //             Icons.image_not_supported_outlined,
                //             size: 30,
                //             color: Colors.grey,
                //           ),
                //         );
                //       },
                //     ),
                //   ),
              ],
            ),

            if (description.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: AppTextStyles.anekMalayalam(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.anekMalayalam(
                      fontSize: 13,
                      color: Color(0xFF555555),
                      height: 1.5,
                    ),
                  ),
                ],
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: AppTextStyles.anekMalayalam(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹ $price',
                      style: AppTextStyles.anekMalayalam(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ],
                ),

                // Edit button (only if not weekly)
                if (!isWeekly)
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: onEdit,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.appPrimaryRed,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 15,
                        ),
                        child: Text(
                          'Edit',
                          style: AppTextStyles.anekMalayalam(
                            fontWeight: FontWeight.bold,
                            color: AppColors.appWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
