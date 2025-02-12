import 'package:chips_choice/chips_choice.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';

class Chips extends StatefulWidget {
  @override
  _ChipsState createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  List<String> tags = [];
  @override
  Widget build(BuildContext context) {
    // final CategoryController categoryController =
    //     Get.find<CategoryController>();
    return ChipsChoice.multiple(
      value: tags,
      onChanged: (val) => setState(() {
        tags = val;
      }),
      choiceItems: C2Choice.listFrom<String, String>(
        source: dropDownKategori,
        value: (i, v) => v,
        label: (i, v) => v,
      ),
      choiceStyle: const C2ChoiceStyle(
        showCheckmark: true,
        color: MyColors.primary,
      ),
      choiceActiveStyle: const C2ChoiceStyle(
        color: Colors.red,
      ),
    );
  }
}
