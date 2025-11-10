import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class TotalTransaction extends StatelessWidget {
  const TotalTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final MonitoringOutletController monitoringOutletController =
        Get.find<MonitoringOutletController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: SizedBox(
              height: 100,
              child: Obx(
                () => monitoringOutletController.isLoading.value
                    ? Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/expense.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const Text(
                                  'Expense',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '-${CurrencyFormat.convertToIdr(0, 0)}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/income.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const Text(
                                  'Income',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  CurrencyFormat.convertToIdr(
                                      monitoringOutletController
                                          .totalIncome.value,
                                      0),
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 100,
              child: Obx(
                () => monitoringOutletController.isLoading.value
                    ? Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/expense.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const Text(
                                  'Expense',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '-${CurrencyFormat.convertToIdr(0, 0)}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/expense.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const Text(
                                  'Expense',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '-${CurrencyFormat.convertToIdr(monitoringOutletController.totalExpense.value, 0)}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 100,
              child: Obx(
                () => monitoringOutletController.isLoading.value
                    ? Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/expense.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const Text(
                                  'Expense',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '-${CurrencyFormat.convertToIdr(0, 0)}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/balance.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const Text(
                                  'Balance',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  CurrencyFormat.convertToIdr(
                                      monitoringOutletController
                                          .totalBalance.value,
                                      0),
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
