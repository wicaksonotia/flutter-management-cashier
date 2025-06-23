import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarWeeklyView extends StatefulWidget {
  const CalendarWeeklyView({super.key});

  @override
  State<CalendarWeeklyView> createState() => _CalendarWeeklyViewState();
}

class _CalendarWeeklyViewState extends State<CalendarWeeklyView> {
  // int? groupValue = 0;
  final HistoryController _historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      locale: 'id', // Set locale to Indonesian
      disabledDates: [
        for (var i = DateTime.now().add(const Duration(days: 1));
            i.isBefore(DateTime(2100));
            i = i.add(const Duration(days: 1)))
          i
      ],
      onDateChange: (selectedDate) {
        _historyController.selectedDate.value = selectedDate;
        _historyController.getDataSingleDate();
      },
      activeColor: MyColors.primary,
      dayProps: const EasyDayProps(
        todayHighlightStyle: TodayHighlightStyle.withBackground,
        todayHighlightColor: MyColors.notionBgPurple,
      ),
      headerProps: const EasyHeaderProps(
        monthPickerType: MonthPickerType.switcher,
        monthStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        showMonthPicker: true,
        // selectedDateFormat: SelectedDateFormat.fullDateDMY,
      ),
    );
  }
}
