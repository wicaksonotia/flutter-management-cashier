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
  final HistoryController historyController = Get.find<HistoryController>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        historyController.startDate.value = picked.start;
        historyController.endDate.value = picked.end;
        historyController.textStartDate.value =
            DateFormat('dd MMMM yyyy').format(picked.start);
        historyController.textEndDate.value =
            DateFormat('dd MMMM yyyy').format(picked.end);
        historyController.getDataByFilter();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.date_range,
          color: MyColors.green,
        ),
        label: Obx(() => Text(
              '${historyController.textStartDate.value} - ${historyController.textEndDate.value}',
              style: const TextStyle(
                color: Colors.black,
              ),
            )),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          _selectDate(context);
        },
      ),
    );
  }
}
