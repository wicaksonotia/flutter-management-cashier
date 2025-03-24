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
  DateTime _selectedDate = DateTime.now();

  void _goToPreviousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
      // debugPrint("month :" + _selectedDate.month.toString());
      // debugPrint("year :" + _selectedDate.year.toString());
    });
    historyController.monthYear.value =
        "${_selectedDate.month.toString()}-${_selectedDate.year.toString()}";
    historyController.getDataByFilter();
  }

  void _goToNextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
      // debugPrint("month :" + _selectedDate.month.toString());
      // debugPrint("year :" + _selectedDate.year.toString());
    });
    historyController.monthYear.value =
        "${_selectedDate.month.toString()}-${_selectedDate.year.toString()}";
    historyController.getDataByFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _goToPreviousMonth,
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
                  setState(() {
                    _selectedDate = selectedDate;
                  });
                  historyController.monthYear.value =
                      "${_selectedDate.month.toString()}-${_selectedDate.year.toString()}";
                  historyController.getDataByFilter();
                }
                // Use the selected date as needed.
                // debugPrint("month :" + _selectedDate.month.toString());
                // debugPrint("year :" + _selectedDate.year.toString());
                // debugPrint('Selected date: $_selectedDate');
              },
              child: Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            if (_selectedDate.isBefore(
                DateTime(DateTime.now().year, DateTime.now().month))) {
              _goToNextMonth();
            }
          },
        ),
      ],
    );
  }
}
