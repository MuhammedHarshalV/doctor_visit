import 'package:doctor_visit/controller/expense_controller/expense_controller.dart';
import 'package:doctor_visit/theme/colors/appcolors.dart';
import 'package:doctor_visit/view/widgets/common_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseHistoryCard extends ConsumerWidget {
  const ExpenseHistoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    final progressState = ref.watch(dayExpenseProvider);
    final progressController = ref.read(dayExpenseProvider.notifier);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,

      onTap: () {
        progressController.updateISExpandedHistory(
          !progressState.isExpandedHistory,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE), // Soft Red Background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Color(0xFFE53935)),
                SizedBox(width: 12),
                Text(
                  "Expense History",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Spacer(),

                Icon(
                  progressState.isExpandedHistory
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  size: 30,
                ),
              ],
            ),

            if (progressState.isExpandedHistory == true) SizedBox(height: 10),
            if (progressState.isExpandedHistory == true)
              CommonSearchBar(controller: controller),
            if (progressState.isExpandedHistory == true) SizedBox(height: 10),

            if (progressState.isExpandedHistory == true)
              SizedBox(
                child: Column(
                  spacing: 4,
                  children: List.generate(
                    progressState.expenseList.length,
                    (index) => FoodCard(
                      title: progressState.expenseList[index].typeOfExpense,
                      description: progressState.expenseList[index].note,
                      price: progressState.expenseList[index].amount,
                      imageUrl: '',
                      onAddToCart: () {},
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final VoidCallback onAddToCart;

  const FoodCard({
    Key? key,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Takes full width of the parent (like a list)
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          right: BorderSide(color: AppColors.appPrimaryRed, width: 5),
          // Dark slate/navy color for the "shadowed" edges
          bottom: BorderSide(color: AppColors.appPrimaryRed, width: 3),
          left: BorderSide(color: AppColors.appPrimaryRed, width: .5),
        ),
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
                          width: MediaQuery.of(context).size.width * 0.65,
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
                    Spacer(),
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
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 243, 174, 46),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: onAddToCart, // Dynamic action
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: AppColors.appPrimaryRed,
                    //     foregroundColor: Colors.white,
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 10,
                    //       vertical: 7,
                    //     ),
                    //   ),
                    //   child: const Text(
                    //     'Edit',
                    //     style: TextStyle(fontWeight: FontWeight.w600),
                    //   ),
                    // ),
                    Container(
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
