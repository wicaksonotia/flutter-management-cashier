import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeBranchPage<T extends BaseController> extends StatelessWidget {
  final T controller;

  const ChangeBranchPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .3,
      maxChildSize: 0.9,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Obx(() {
          if (controller.isLoadingCabang.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: controller.resultDataCabang.length,
              itemBuilder: (context, index) {
                final outlet = controller.resultDataCabang[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      controller.idCabang.value = outlet.id!;
                      controller.selectedCabang.value = outlet.cabang!;
                    },
                    title: Text(
                      outlet.cabang!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      outlet.alamat!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: MySizes.fontSizeSm,
                      ),
                    ),
                    trailing: Obx(
                      () => Icon(
                        Icons.check_circle,
                        color: (outlet.id == controller.idCabang.value)
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
