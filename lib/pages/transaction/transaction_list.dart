import 'package:financial_apps/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: historyController.resultData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(historyController.resultData[index].note ?? 'No Note'),
          subtitle: Text(historyController.resultData[index].amount.toString()),
        );
      },
    );
  }
}
