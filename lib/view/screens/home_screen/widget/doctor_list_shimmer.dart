import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DoctorListShimmer extends StatelessWidget {
  final int itemCount;

  const DoctorListShimmer({
    super.key,
    this.itemCount = 15,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: AppColors.appWhite,
            highlightColor: AppColors.appPrimaryRed,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.appPrimaryRed,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}