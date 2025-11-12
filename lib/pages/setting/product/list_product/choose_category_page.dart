import 'package:cashier_management/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseCategoryPage extends StatelessWidget {
  final ProductController controller;

  const ChooseCategoryPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .3,
      maxChildSize: 0.9,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Obx(() {
          if (controller.isLoadingList.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: controller.resultDataProductCategory.length,
              itemBuilder: (context, index) {
                final data = controller.resultDataProductCategory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      controller.productCategoryId.value = data.idCategories!;
                      controller.productCategoryName.value = data.name!;
                      controller.fetchDataListProduct();
                    },
                    title: Text(
                      data.name!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Obx(
                      () => Icon(
                        Icons.check_circle,
                        color: (data.idCategories ==
                                controller.productCategoryId.value)
                            ? Colors.lightGreen
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }
}
