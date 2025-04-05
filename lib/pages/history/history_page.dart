import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/pages/history/filter.dart';
import 'package:financial_apps/pages/history/filter_date_range.dart';
import 'package:financial_apps/pages/history/filter_month.dart';
import 'package:financial_apps/pages/history/history_list.dart';
import 'package:financial_apps/pages/history/total_transaction.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/lists.dart';
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
  int? groupValue = 0;
  Future<void> _refresh() async {
    _historyController.getDataByFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          // PopupMenuButton<int>(
          //   icon: const Icon(Icons.more_vert),
          //   onSelected: (value) {
          //     if (value == 1) {
          //       // Handle Add action
          //     } else if (value == 2) {
          //       // Handle Filter action
          //       showModalBottomSheet(
          //         context: context,
          //         builder: (context) => const FilterReport(),
          //         isScrollControlled: true,
          //         backgroundColor: Colors.white,
          //         shape: const RoundedRectangleBorder(
          //           borderRadius:
          //               BorderRadius.vertical(top: Radius.circular(20)),
          //         ),
          //       );
          //     }
          //   },
          //   itemBuilder: (context) => [
          //     const PopupMenuItem(
          //       value: 1,
          //       child: Row(
          //         children: [
          //           Icon(Icons.add_box, color: MyColors.green),
          //           SizedBox(width: 10),
          //           Text('Add Transaction'),
          //         ],
          //       ),
          //     ),
          //     const PopupMenuItem(
          //       value: 2,
          //       child: Row(
          //         children: [
          //           Icon(Icons.filter_alt_outlined, color: MyColors.green),
          //           SizedBox(width: 10),
          //           Text('Filter'),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          IconButton(
            icon: const Icon(Icons.add_box, color: MyColors.green),
            onPressed: () {
              // Handle Add action
            },
          ),
        ],
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
                          _historyController.filterBy.value =
                              filterKategori[index]['value']!;
                          _historyController.getDataByFilter();
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
              child: Obx(() => _historyController.filterBy.value == 'bulan'
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
