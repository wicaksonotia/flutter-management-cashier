import 'package:financial_apps/controllers/category_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCategories extends StatelessWidget {
  ListCategories({super.key});
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => categoryController.isLoading.value
          ? Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chips(),
                    // SelectBoxSearch(),
                    // const MultiSelectHome(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .8,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 5),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: categoryController.resultData.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            color: Colors.white,
                            elevation: 3,
                            child: ListTile(
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: MyColors.primary,
                                    onPressed: () => categoryController
                                        .detailCategory(categoryController
                                            .resultData[index].id!),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: MyColors.red,
                                    onPressed: () => categoryController
                                        .deleteCategory(categoryController
                                            .resultData[index].id!),
                                  ),
                                ],
                              ),
                              leading: categoryController
                                          .resultData[index].categoryType ==
                                      "PEMASUKAN"
                                  ? const Icon(
                                      Icons.download,
                                      color: MyColors.green,
                                    )
                                  : const Icon(
                                      Icons.upload,
                                      color: MyColors.red,
                                    ),
                              title: Text(
                                categoryController
                                        .resultData[index].categoryName ??
                                    '',
                                style: const TextStyle(color: MyColors.primary),
                              ),
                              // leading: categoryController[index][0],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
