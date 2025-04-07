import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilterDateRange extends StatefulWidget {
  const FilterDateRange({super.key});

  @override
  State<FilterDateRange> createState() => _FilterDateRangeState();
}

class _FilterDateRangeState extends State<FilterDateRange> {
  final HistoryController _historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.date_range,
          color: MyColors.green,
        ),
        const SizedBox(width: 10),
        Obx(() => GestureDetector(
              onTap: () {
                _historyController.showDialogDateRangePicker();
              },
              child: Text(
                '${DateFormat('dd MMMM yyyy').format(_historyController.startDate.value)} - ${DateFormat('dd MMMM yyyy').format(_historyController.endDate.value)}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            )),
      ],
    );
  }
}
