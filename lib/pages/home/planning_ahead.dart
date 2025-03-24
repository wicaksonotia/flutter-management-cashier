import 'package:financial_apps/controllers/total_per_type_controller.dart';
import 'package:financial_apps/utils/colors.dart';
// import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class PlanningAhead extends StatelessWidget {
  const PlanningAhead({super.key});

  @override
  Widget build(BuildContext context) {
    final TotalPerTypeController totalPerTypeController =
        Get.find<TotalPerTypeController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Saldo per Type",
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              // Row(
              //   // ignore: prefer_const_literals_to_create_immutables
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: ((context) => TransactionPage())));
              //       },
              //       child: Text(
              //         CurrencyFormat.convertToIdr(2000000, 0),
              //         style: TextStyle(
              //             color: Colors.grey[700], fontWeight: FontWeight.w500),
              //       ),
              //     ),
              //     const Icon(
              //       Icons.arrow_forward_ios,
              //       size: 12,
              //     )
              //   ],
              // )
            ],
          ),
        ),
        const Gap(15),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SizedBox(
            height: 120,
            child: Obx(() {
              if (totalPerTypeController.isLoading.value) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, int index) {
                    return SizedBox(
                      width: 120,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 20,
                                    width: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: totalPerTypeController.resultData.length,
                  itemBuilder: (context, int index) {
                    return SizedBox(
                      width: 120,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/${totalPerTypeController.resultData[index].gambar}',
                                  height: 50,
                                ),
                                Text(
                                  totalPerTypeController.resultData[index].total
                                      .toString(),
                                  style: const TextStyle(
                                      color: MyColors.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  totalPerTypeController
                                          .resultData[index].kategori ??
                                      '',
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}
