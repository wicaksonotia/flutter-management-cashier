import 'package:chips_choice/chips_choice.dart';
import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChipsTransaction extends StatefulWidget {
  const ChipsTransaction({super.key});

  @override
  _ChipsTransactionState createState() => _ChipsTransactionState();
}

class _ChipsTransactionState extends State<ChipsTransaction> {
  final HistoryController _historyController = Get.find<HistoryController>();
  List<String> tags = [];
  @override
  Widget build(BuildContext context) {
    return ChipsChoice.multiple(
      value: tags,
      onChanged: (val) => setState(() {
        tags = val;
        _historyController.tags.value = val;
        _historyController.getDataByDate();
      }),
      choiceItems: C2Choice.listFrom<String, Map<String, String>>(
        source: tipeKategori,
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
  }
}
