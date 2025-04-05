import 'package:chips_choice/chips_choice.dart';
import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipsSubCategory extends StatefulWidget {
  const ChipsSubCategory({super.key});

  @override
  _ChipsSubCategoryState createState() => _ChipsSubCategoryState();
}

class _ChipsSubCategoryState extends State<ChipsSubCategory> {
  final HistoryController _historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ChipsChoice.multiple(
        wrapped: true,
        padding: EdgeInsets.zero,
        value: _historyController.temporaryTagSubCategory,
        onChanged: (val) => setState(() {
          _historyController.temporaryTagSubCategory.value = val.cast<String>();
        }),
        choiceItems: C2Choice.listFrom<String, Map<String, String>>(
          source: _historyController.listSubCategory,
          value: (i, v) => v['value']!,
          label: (i, v) => v['nama']!,
        ),
        choiceStyle: C2ChoiceStyle(
          showCheckmark: true,
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        choiceActiveStyle: const C2ChoiceStyle(
          color: MyColors.green,
        ),
      );
    });
  }
}
