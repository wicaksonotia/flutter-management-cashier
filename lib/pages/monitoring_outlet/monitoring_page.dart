import 'package:financial_apps/controllers/monitoring_outlet_controller.dart';
import 'package:financial_apps/pages/monitoring_outlet/filter.dart';
import 'package:financial_apps/pages/monitoring_outlet/filter_date_range.dart';
import 'package:financial_apps/pages/monitoring_outlet/filter_month.dart';
import 'package:financial_apps/pages/monitoring_outlet/history_list.dart';
import 'package:financial_apps/pages/monitoring_outlet/total_transaction.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final MonitoringOutletController _monitoringOutletController =
      Get.find<MonitoringOutletController>();
  int? groupValue = 1;
  Future<void> _refresh() async {
    _monitoringOutletController.getDataByFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Monitoring Outlet',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SHOW DISPLAY BY DATE, MONTH, YEAR
                  ...List.generate(
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
                                color: groupValue == index
                                    ? MyColors.green
                                    : Colors.black,
                                fontWeight: groupValue == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),

                  // FILTER
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const FilterReport(),
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
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
                        color: MyColors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // NEXT AND PREVIOUS MONTH YEAR
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: context.height * 0.05,
              child: Obx(() =>
                  _monitoringOutletController.filterBy.value == 'bulan'
                      ? const FilterMonth()
                      : const FilterDateRange()),
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
