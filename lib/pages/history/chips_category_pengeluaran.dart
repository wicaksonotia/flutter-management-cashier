import 'package:chips_choice/chips_choice.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipsCategoryPengeluaran extends StatefulWidget {
  final HistoryController historyController;
  const ChipsCategoryPengeluaran(this.historyController, {super.key});

  @override
  _ChipsCategoryPengeluaranState createState() =>
      _ChipsCategoryPengeluaranState();
}

class _ChipsCategoryPengeluaranState extends State<ChipsCategoryPengeluaran> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.historyController.isLoadingCategoryPengeluaran.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (widget.historyController.listCategoryPengeluaran.isEmpty) {
        return const Center(
          child: Text('No categories available'),
        );
      }
      return ChipsChoice.multiple(
        wrapped: true,
        padding: EdgeInsets.zero,
        value: widget.historyController.tagCategory,
        onChanged: (val) => setState(() {
          widget.historyController.tagCategory.value = val;
          widget.historyController.getHistoriesByFilter();
        }),
        choiceItems: C2Choice.listFrom<int, Map<String, dynamic>>(
          source: widget.historyController.listCategoryPengeluaran,
          value: (i, v) => v['value'],
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
