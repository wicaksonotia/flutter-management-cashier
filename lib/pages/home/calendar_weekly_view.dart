import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/utils/colors.dart';
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
    // Widget calendarBox(BuildContext context) {
    //   return SizedBox(
    //     height: MediaQuery.of(context).size.height * 0.1,
    //     width: MediaQuery.of(context).size.width * 0.9,
    //     child: Container(
    //         alignment: Alignment.center,
    //         child: CupertinoSlidingSegmentedControl<int>(
    //             backgroundColor: Colors.transparent,
    //             thumbColor: Colors.greenAccent,
    //             padding: const EdgeInsets.all(5),
    //             groupValue: groupValue,
    //             children: {
    //               0: Text('a'),
    //               1: Text('a'),
    //               2: Text('a'),
    //               3: Text('a'),
    //               4: Text('a'),
    //             },
    //             onValueChanged: (value) {
    //               setState(() {
    //                 groupValue = value;
    //                 print(groupValue);
    //               });
    //             })),
    //   );
    // }

    return EasyDateTimeLine(
      initialDate: DateTime.now(),
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
      activeColor: MyColors.green,
      dayProps: const EasyDayProps(
        todayHighlightStyle: TodayHighlightStyle.withBackground,
        todayHighlightColor: Color(0xffE1ECC8),
      ),
      headerProps: const EasyHeaderProps(
        monthPickerType: MonthPickerType.switcher,
        monthStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        showMonthPicker: true,
        // selectedDateFormat: SelectedDateFormat.fullDateDMY,
      ),
    );
  }
}
