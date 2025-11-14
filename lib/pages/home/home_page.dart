import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/pages/change_outlet_page.dart';
// import 'package:cashier_management/pages/home/bar_chart.dart';
import 'package:cashier_management/pages/home/line_chart.dart';
import 'package:cashier_management/pages/home/calendar_weekly_view.dart';
// import 'package:cashier_management/pages/home/header.dart';
import 'package:cashier_management/pages/home/branch_saldo.dart';
import 'package:cashier_management/pages/home/transaction_list.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TotalPerTypeController totalPerTypeController =
      Get.find<TotalPerTypeController>();
  final HistoryController historyController = Get.find<HistoryController>();
  final KiosController kiosController = Get.find<KiosController>();

  Future<void> _refresh() async {
    totalPerTypeController.getTotalSaldo();
    totalPerTypeController.getTotalBranchSaldo();
    totalPerTypeController.getTotalPerMonth();
    historyController.getHistoriesBySingleDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang,',
              style: TextStyle(
                fontSize: MySizes.fontSizeSm,
                color: Colors.black54,
              ),
            ),
            Obx(() {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    builder: (context) => const ChangeOutletPage(),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      kiosController.selectedKios.value,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeMd,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Gap(5),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.black54),
                  ],
                ),
              );
            }),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[50],
          ),
          RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              children: const [
                // Header(),
                Gap(15),
                BranchSaldo(),
                Gap(20),
                // BarChartSample3(),
                LineChartSample1(),
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
