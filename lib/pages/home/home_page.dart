import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/pages/home/bar_chart.dart';
import 'package:cashier_management/pages/home/calendar_weekly_view.dart';
import 'package:cashier_management/pages/home/header.dart';
import 'package:cashier_management/pages/home/branch_saldo.dart';
import 'package:cashier_management/pages/home/transaction_list.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TotalPerTypeController totalPerTypeController =
      Get.find<TotalPerTypeController>();
  final HistoryController historyController = Get.find<HistoryController>();

  Future<void> _refresh() async {
    totalPerTypeController.getTotalSaldo();
    totalPerTypeController.getTotalBranchSaldo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.grey[50], // Set background color
          ),
          RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              children: const [
                Header(),
                Gap(15),
                BranchSaldo(),
                Gap(20),
                BarChartSample3(),
                CalendarWeeklyView(),
                SizedBox(
                  height: 260,
                  child: TransactionList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
