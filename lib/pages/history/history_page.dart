import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/pages/history/filter.dart';
import 'package:financial_apps/pages/history/filter_month.dart';
import 'package:financial_apps/pages/history/history_list.dart';
import 'package:financial_apps/pages/history/total_transaction.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final HistoryController historyController = Get.find<HistoryController>();
  Future<void> _refresh() async {
    historyController.getDataByFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                // Handle Add action
              } else if (value == 2) {
                // Handle Filter action
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
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.add_box, color: MyColors.green),
                    SizedBox(width: 10),
                    Text('Add Transaction'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, color: MyColors.green),
                    SizedBox(width: 10),
                    Text('Filter'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NEXT AND PREVIOUS MONTH YEAR
            FilterMonth(),

            // INCOME, EXPENSE, AND BALANCE
            TotalTransaction(),
            Gap(10),
            Expanded(
              child: HistoryList(),
            ),
          ],
        ),
      ),
    );
  }
}
