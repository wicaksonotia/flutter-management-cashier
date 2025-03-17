import 'package:financial_apps/pages/history/filter.dart';
import 'package:financial_apps/pages/history/history_list.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors.green,
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
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
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: HistoryList(),
          ),
        ],
      ),
    );
  }
}
