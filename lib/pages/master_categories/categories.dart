import 'package:financial_apps/controllers/category_controller.dart';
import 'package:financial_apps/pages/master_categories/chips.dart';
import 'package:financial_apps/pages/master_categories/list_categories.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:financial_apps/utils/search_bar_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FormCategories extends StatefulWidget {
  const FormCategories({super.key});

  @override
  State<FormCategories> createState() => _FormCategoriesState();
}

class _FormCategoriesState extends State<FormCategories> {
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
              color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                Container(
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
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 3, 3, 3)),
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
                                    categoryController.tipeContoller.value =
                                        value!;
                                  },
                                  isExpanded: true,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: MyColors.darkTextColor),
                                ),
                              ),
                            )),
                        const Gap(10),
                        TextFormField(
                          controller: categoryController.nameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Category Name"),
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
                                minimumSize:
                                    const Size(100, 40), // Set width and height
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
                                minimumSize:
                                    const Size(100, 40), // Set width and height
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
                ),
              );
            },
            icon: const Icon(
              Icons.add_box,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SearchBarContainer(),
          ),
          const Chips(),
          Expanded(
            child: ListCategories(),
          ),
        ],
      ),
    );
  }
}
