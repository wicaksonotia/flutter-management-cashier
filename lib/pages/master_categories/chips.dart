import 'package:chips_choice/chips_choice.dart';
import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chips extends StatefulWidget {
  const Chips({super.key});

  @override
  _ChipsState createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  final CategoryController categoryController = Get.find<CategoryController>();
  List<String> tags = [];
  @override
  Widget build(BuildContext context) {
    return ChipsChoice.multiple(
      value: tags,
      onChanged: (val) => setState(() {
        tags = val;
        categoryController.tags.value = val;
        categoryController.getData(val, '');
      }),
      choiceItems: C2Choice.listFrom<String, Map<String, String>>(
        source: tipeKategori,
        value: (i, v) => v['value']!,
        label: (i, v) => v['nama']!,
      ),
      choiceCheckmark: false,
      choiceStyle: C2ChipStyle.filled(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey.shade300,
        selectedStyle: const C2ChipStyle(
          backgroundColor: MyColors.primary,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
      ),
    );
  }
}
