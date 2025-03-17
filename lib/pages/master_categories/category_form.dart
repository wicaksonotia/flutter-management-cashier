import 'package:financial_apps/controllers/category_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Add Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Obx(() => InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Category",
                      contentPadding: EdgeInsets.fromLTRB(10, 3, 3, 3)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: categoryController.tipeContoller.value,
                      items: dropDownKategori.map(
                        (String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        categoryController.tipeContoller.value = value!;
                      },
                      isExpanded: true,
                      style: const TextStyle(
                          fontSize: 17, color: MyColors.darkTextColor),
                    ),
                  ),
                )),
            const Gap(10),
            TextFormField(
              controller: categoryController.nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Category Name"),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: MyColors.green),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    minimumSize: const Size(100, 40), // Set width and height
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: MyColors.green),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () async {
                    categoryController.insertCategory();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: MyColors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    minimumSize: const Size(100, 40), // Set width and height
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
