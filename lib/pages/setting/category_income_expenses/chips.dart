import 'package:chips_choice/chips_choice.dart';
import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Chips extends StatefulWidget {
  const Chips({super.key});

  @override
  _ChipsState createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChipsChoice.multiple(
          value: categoryController.tags,
          onChanged: (val) => setState(() {
            categoryController.tags.value = List<String>.from(val);
            categoryController.getData();
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
        ),
        Obx(() {
          final isAsc = categoryController.sortOrder.value == "ASC";

          return GestureDetector(
            onTap: categoryController.toggleSort,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedRotation(
                    turns: isAsc ? 0 : 0.5, // rotate 180°
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.unfold_more, size: 20),
                  ),
                  const Gap(5),
                  Text(
                    isAsc ? "ASC" : "DESC",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}
