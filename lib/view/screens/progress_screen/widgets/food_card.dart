import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final bool isWeekly;
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final VoidCallback onEdit;

  const FoodCard({
    super.key,
    required this.isWeekly,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Takes full width of the parent (like a list)
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 253, 245, 245),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.appLightRed),
      ),
      //clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section using dynamic imageUrl

          // Content Section using dynamic text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            Icon(
                              title == 'Food'
                                  ? Icons.fastfood_sharp
                                  : title == 'Petrol'
                                  ? Icons.local_gas_station
                                  : title == 'Travel'
                                  ? Icons.car_repair_outlined
                                  : Icons.outlet_sharp,
                            ),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        //  const SizedBox(height: 8),
                        SizedBox(
                          width: isWeekly
                              ? MediaQuery.of(context).size.width * 0.80
                              : MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF777777),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isWeekly) Spacer(),
                    if (!isWeekly)
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        width: 50,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 30,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),

                // Footer Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isWeekly)
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.appDarkGrey,
                        ),
                      ),
                    if (isWeekly)
                      Text(
                        "Approved $price",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.appDarkGrey,
                        ),
                      ),
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
                              vertical: 3,
                              horizontal: 5,
                            ),
                            child: Text(
                              'Edit',
                              style: TextStyle(
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
        ],
      ),
    );
  }
}
