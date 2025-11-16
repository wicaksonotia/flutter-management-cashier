import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/models/category_model.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_form.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_list_shimmer.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CategoryList extends GetView<CategoryController> {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            final reachBottom =
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;

            if (reachBottom && !controller.isLoadingMore.value) {
              controller.loadMore();
            }
            return false;
          },
          child: controller.isLoadingCategory.value
              ? const CategoryListShimmer()
              : _buildList(),
        ),
      );
    });
  }

  Widget _buildList() {
    final data = controller.resultDataCategory;
    final showLoadingMore = controller.isLoadingMore.value;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: data.length + (showLoadingMore ? 1 : 0),
      itemBuilder: (_, index) {
        if (index == data.length && showLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return _CategoryItem(data[index], controller);
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final DataCategory item;
  final CategoryController controller;

  const _CategoryItem(this.item, this.controller);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.categoryName!,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            const Gap(10),
            InkWell(
              onTap: () {
                // DIALOG CONFIRMATION ACTIVE OR INACTIVE
                Get.bottomSheet(
                  ConfirmDialog(
                      title: item.status!
                          ? 'Non-Activate Category'
                          : 'Activate Category',
                      message: item.status!
                          ? 'This category will be deactivated.\nAre you sure you want to continue?'
                          : 'This category will be activated.\nAre you sure you want to continue?',
                      onConfirm: () async {
                        controller.updateStatusCategory(
                            item.id!, !item.status!);
                      }),
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.status! ? Colors.green[200] : Colors.red[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.status! ? 'Active' : 'Inactive',
                  style: const TextStyle(fontSize: MySizes.fontSizeXsm),
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "edit") {
              controller.editCategory(item);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    content: const CategoryForm(),
                  );
                },
              );
              return;
            }
            if (value == "delete") {
              // can't delete product category, cause product category is in use
              if (item.statusTransaksi == 1) {
                Get.snackbar(
                  'Error',
                  'Cannot delete this category. This category has been used in transactions',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[800],
                );
                return;
              }
              // Show confirmation dialog
              Get.bottomSheet(
                ConfirmDialog(
                  title: 'Delete Product Category',
                  message:
                      'Are you sure, you want to delete this product category?',
                  onConfirm: () async {
                    controller.deleteCategory(item.id!);
                  },
                ),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
              return;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "edit",
              child: Row(
                children: [
                  Icon(Icons.edit),
                  Gap(8),
                  Text("Edit"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Icon(Icons.delete),
                  Gap(8),
                  Text("Delete"),
                ],
              ),
            ),
          ],
          color: Colors.white,
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
