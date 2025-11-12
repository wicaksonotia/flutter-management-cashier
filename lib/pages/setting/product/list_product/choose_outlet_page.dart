import 'package:cashier_management/controllers/product_controller.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseOutletPage extends StatelessWidget {
  final ProductController controller;

  const ChooseOutletPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .3,
      maxChildSize: 0.9,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Obx(() {
          if (controller.isLoadingKios.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: controller.resultDataKios.length,
              itemBuilder: (context, index) {
                final outlet = controller.resultDataKios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      controller.idKios.value = outlet.idKios!;
                      controller.selectedKios.value = outlet.kios!;
                      controller.productCategoryId.value = 0;
                      controller.productCategoryName.value = 'Category';
                      controller.fetchDataListProductCategory(
                        onAfterSuccess: () async =>
                            controller.fetchDataListProduct(),
                      );
                    },
                    title: Text(
                      outlet.kios!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      outlet.keterangan!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: MySizes.fontSizeSm,
                      ),
                    ),
                    trailing: Obx(
                      () => Icon(
                        Icons.check_circle,
                        color: (outlet.idKios == controller.idKios.value)
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
