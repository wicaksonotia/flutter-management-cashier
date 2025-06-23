import 'package:chips_choice/chips_choice.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipsFilterCategory extends StatefulWidget {
  const ChipsFilterCategory({super.key});

  @override
  _ChipsFilterCategoryState createState() => _ChipsFilterCategoryState();
}

class _ChipsFilterCategoryState extends State<ChipsFilterCategory> {
  final HistoryController _historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return ChipsChoice.single(
      value: _historyController.filterBy,
      onChanged: (val) => setState(() {
        _historyController.filterBy.value = val.toString();
        _historyController.getDataByFilter();
      }),
      choiceItems: C2Choice.listFrom<String, Map<String, String>>(
        source: filterKategori,
        value: (i, v) => v['value']!,
        label: (i, v) => v['nama']!,
      ),
      choiceCheckmark: false,
      choiceStyle: C2ChipStyle.filled(
        selectedStyle: const C2ChipStyle(
          backgroundColor: MyColors.primary,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }
}
