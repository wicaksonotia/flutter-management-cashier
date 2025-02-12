import 'package:financial_apps/controllers/category_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectBoxSearch extends StatelessWidget {
  SelectBoxSearch({super.key});
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InputDecorator(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Category",
            contentPadding: EdgeInsets.fromLTRB(10, 3, 3, 3)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: categoryController.kategoriSearch.value,
            items: dropDownKategoriSearch.map(
              (String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            onChanged: (value) {
              categoryController.kategoriSearch.value = value!;
              categoryController
                  .getData(categoryController.kategoriSearch.value);
            },
            isExpanded: true,
            style: const TextStyle(fontSize: 17, color: MyColors.darkTextColor),
          ),
        ),
      ),
    );
  }
}
