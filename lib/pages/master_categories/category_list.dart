import 'package:financial_apps/controllers/category_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCategories extends StatelessWidget {
  ListCategories({super.key});
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: () async {
          categoryController.getData(categoryController.tags);
        },
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: .5,
              // indent: 20,
              // endIndent: 20,
              color: Colors.grey.shade300,
            );
          },
          // padding: const EdgeInsets.only(top: 5),
          // shrinkWrap: true,
          // scrollDirection: Axis.vertical,
          itemCount: categoryController.resultData.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: categoryController.resultData[index].categoryType ==
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
                categoryController.resultData[index].categoryName ?? '',
              ),
              subtitle: Text(
                categoryController.resultData[index].status == true
                    ? 'active'
                    : 'inactive',
                style: TextStyle(
                    color: categoryController.resultData[index].status == true
                        ? MyColors.green
                        : MyColors.red),
              ),
              trailing: PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black26,
                ),
                // onSelected: (String value) {
                //   if (value == 'edit') {
                //     categoryController.detailCategory(
                //         categoryController.resultData[index].id!);
                //   } else if (value == 'delete') {
                //     categoryController.deleteCategory(
                //         categoryController.resultData[index].id!);
                //   }
                // },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      // value: 'edit',
                      child: ListTile(
                          leading: const Icon(Icons.edit_document),
                          title: const Text('Edit'),
                          onTap: () {
                            Get.back();
                            categoryController.detailCategory(
                                categoryController.resultData[index].id!);
                          }),
                    ),
                    PopupMenuItem(
                      // value: 'edit',
                      child: ListTile(
                          leading: const Icon(Icons.edit_document),
                          title: const Text('Update Status'),
                          onTap: () {
                            Get.back();
                            categoryController.updateCategoryStatus(
                                categoryController.resultData[index].id!,
                                categoryController.resultData[index].status ??
                                    false);
                          }),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      // value: 'delete',
                      child: ListTile(
                          leading: const Icon(Icons.delete_forever),
                          title: const Text('Delete'),
                          onTap: () {
                            Get.back();
                            categoryController.deleteCategory(
                                categoryController.resultData[index].id!);
                          }),
                    ),
                  ];
                },
              ),
            );
          },
        ),
      );
    });
  }
}
