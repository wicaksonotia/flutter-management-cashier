import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

class FilterMonth extends StatefulWidget {
  const FilterMonth({super.key});

  @override
  State<FilterMonth> createState() => _FilterMonthState();
}

class _FilterMonthState extends State<FilterMonth> {
  final HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: historyController.goToPreviousMonth,
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () async {
                final selectedDate =
                    await SimpleMonthYearPicker.showMonthYearPickerDialog(
                        context: context,
                        titleTextStyle: const TextStyle(),
                        monthTextStyle: const TextStyle(),
                        yearTextStyle: const TextStyle(),
                        selectionColor: MyColors.green,
                        disableFuture:
                            true // This will disable future years. It is false by default.
                        );
                if (selectedDate.year < DateTime.now().year ||
                    (selectedDate.year == DateTime.now().year &&
                        selectedDate.month <= DateTime.now().month)) {
                  historyController.singleDate.value = selectedDate;
                  historyController.monthYear.value =
                      "${selectedDate.month.toString()}-${selectedDate.year.toString()}";
                  historyController.getDataByFilter();
                }
                // Use the selected date as needed.
                // debugPrint("month :" + selectedDate.month.toString());
                // debugPrint("year :" + selectedDate.year.toString());
                // debugPrint('Selected date: $selectedDate');
              },
              child: Obx(() => Text(
                    DateFormat('MMMM yyyy')
                        .format(historyController.singleDate.value),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            if (historyController.singleDate.value.isBefore(
                DateTime(DateTime.now().year, DateTime.now().month))) {
              historyController.goToNextMonth();
            }
          },
        ),
      ],
    );
  }
}
