import 'package:chips_choice/chips_choice.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/utils/colors.dart';
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
          _historyController.setDataByFilter();
        }),
        choiceItems: C2Choice.listFrom<String, Map<String, String>>(
          source: _historyController.listCategory,
          value: (i, v) => v['value']!,
          label: (i, v) => v['nama']!,
        ),
        choiceCheckmark: false,
        choiceStyle: C2ChipStyle.filled(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey.shade100,
          selectedStyle: const C2ChipStyle(
            backgroundColor: MyColors.primary,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
        ),
      );
    });
  }
}
