import 'package:chips_choice/chips_choice.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipsCategory extends StatefulWidget {
  const ChipsCategory({super.key});

  @override
  _ChipsCategoryState createState() => _ChipsCategoryState();
}

class _ChipsCategoryState extends State<ChipsCategory> {
  final HistoryController _historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return ChipsChoice.multiple(
      wrapped: true,
      padding: EdgeInsets.zero,
      value: _historyController.temporaryTagCategory,
      onChanged: (val) => setState(() {
        _historyController.temporaryTagCategory.value = val.cast<String>();
      }),
      choiceItems: C2Choice.listFrom<String, Map<String, String>>(
        source: tipeKategori,
        value: (i, v) => v['value']!,
        label: (i, v) => v['nama']!,
      ),
      choiceCheckmark: true,
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
