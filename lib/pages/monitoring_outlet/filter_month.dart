import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/utils/colors.dart';
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
  final MonitoringOutletController _monitoringOutletController =
      Get.find<MonitoringOutletController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _monitoringOutletController.goToPreviousMonth,
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
                        selectionColor: MyColors.primary,
                        disableFuture:
                            true // This will disable future years. It is false by default.
                        );
                if (selectedDate.year < DateTime.now().year ||
                    (selectedDate.year == DateTime.now().year &&
                        selectedDate.month <= DateTime.now().month)) {
                  _monitoringOutletController.monthDate.value = selectedDate;
                  _monitoringOutletController.monthYear.value =
                      "${selectedDate.month.toString()}-${selectedDate.year.toString()}";
                  _monitoringOutletController.getDataByFilter();
                }
                // Use the selected date as needed.
                // debugPrint("month :" + selectedDate.month.toString());
                // debugPrint("year :" + selectedDate.year.toString());
                // debugPrint('Selected date: $selectedDate');
              },
              child: Obx(() => Text(
                    DateFormat('MMMM yyyy')
                        .format(_monitoringOutletController.monthDate.value),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            if (_monitoringOutletController.monthDate.value.isBefore(
                DateTime(DateTime.now().year, DateTime.now().month))) {
              _monitoringOutletController.goToNextMonth();
            }
          },
        ),
      ],
    );
  }
}
