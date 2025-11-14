import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/pages/change_outlet_page.dart';
import 'package:cashier_management/pages/monitoring_outlet/filter.dart';
import 'package:cashier_management/pages/monitoring_outlet/filter_date_range.dart';
import 'package:cashier_management/pages/monitoring_outlet/filter_month.dart';
import 'package:cashier_management/pages/monitoring_outlet/history_list.dart';
import 'package:cashier_management/pages/monitoring_outlet/total_transaction.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/lists.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final MonitoringOutletController _monitoringOutletController =
      Get.find<MonitoringOutletController>();
  final KiosController _kiosController = Get.find<KiosController>();
  int? groupValue = 1;

  Future<void> _refresh() async {
    _monitoringOutletController.getDataByFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
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
              'Riwayat Transaksi Per Outlet',
              style: TextStyle(
                  fontSize: MySizes.fontSizeHeader,
                  fontWeight: FontWeight.bold),
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
                      _kiosController.selectedKios.value,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const Gap(5),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.black54, size: 15),
                  ],
                ),
              );
            }),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => FilterReport(_monitoringOutletController),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 0.5,
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.filter_list,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final selectedIndex = filterKategori.indexWhere((e) =>
                        e['value'] ==
                        _monitoringOutletController.filterBy.value);
                    final currentIndex =
                        selectedIndex == -1 ? 0 : selectedIndex;
                    return SizedBox(
                      width: context.width * .5,
                      height: context.height * .05,
                      child: Row(
                        children: List.generate(
                          filterKategori.length,
                          (index) => Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  groupValue = index;
                                });
                                _monitoringOutletController.filterBy.value =
                                    filterKategori[index]['value']!;
                                _monitoringOutletController.getDataByFilter();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      width: 0.5,
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Center(
                                  child: Text(
                                    filterKategori[index]['nama']!,
                                    style: TextStyle(
                                      color: currentIndex == index
                                          ? MyColors.primary
                                          : Colors.black,
                                      fontWeight: currentIndex == index
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  // NEXT AND PREVIOUS MONTH YEAR
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: context.height * 0.05,
                    child: Obx(() =>
                        _monitoringOutletController.filterBy.value == 'bulan'
                            ? const FilterMonth()
                            : const FilterDateRange()),
                  ),
                ],
              ),
            ),
            const Gap(5),
            // INCOME, EXPENSE, AND BALANCE
            const TotalTransaction(),
            const Gap(5),
            const Expanded(
              child: HistoryList(),
            ),
          ],
        ),
      ),
    );
  }
}
