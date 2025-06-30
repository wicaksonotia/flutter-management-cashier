import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/pages/history/filter.dart';
import 'package:cashier_management/pages/history/filter_date_range.dart';
import 'package:cashier_management/pages/history/filter_month.dart';
import 'package:cashier_management/pages/history/history_list.dart';
import 'package:cashier_management/pages/history/total_transaction.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final HistoryController _historyController = Get.find<HistoryController>();
  int? groupValue = 1;
  Future<void> _refresh() async {
    _historyController.getHistoriesByFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => FilterReport(_historyController),
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
                color: MyColors.primary,
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
                  SizedBox(
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
                              _historyController.filterBy.value =
                                  filterKategori[index]['value']!;
                              _historyController.getHistoriesByFilter();
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
                                        ? MyColors.primary
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
                    ),
                  ),
                  // NEXT AND PREVIOUS MONTH YEAR
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: context.height * 0.05,
                    child: Obx(() =>
                        _historyController.filterBy.value == 'bulan'
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
