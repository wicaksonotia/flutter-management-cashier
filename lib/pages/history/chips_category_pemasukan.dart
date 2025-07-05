import 'package:chips_choice/chips_choice.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipsCategoryPemasukan extends StatefulWidget {
  final HistoryController historyController;
  const ChipsCategoryPemasukan(this.historyController, {super.key});

  @override
  _ChipsCategoryPemasukanState createState() => _ChipsCategoryPemasukanState();
}

class _ChipsCategoryPemasukanState extends State<ChipsCategoryPemasukan> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.historyController.isLoadingCategoryPemasukan.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (widget.historyController.listCategoryPemasukan.isEmpty) {
        return const Center(
          child: Text('No categories available'),
        );
      }
      return ChipsChoice.multiple(
        wrapped: true,
        padding: EdgeInsets.zero,
        value: widget.historyController.tagCabangKios,
        onChanged: (val) => setState(() {
          widget.historyController.tagCabangKios.value = val;
          widget.historyController.getHistoriesByFilter();
        }),
        choiceItems: C2Choice.listFrom<int, Map<String, dynamic>>(
          source: widget.historyController.listCategoryPemasukan,
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
