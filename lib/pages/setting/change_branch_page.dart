import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ChangeBranchPage<T extends BaseController> extends StatelessWidget {
  final T controller;

  const ChangeBranchPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Outlet Branch',
          style: TextStyle(
              fontSize: MySizes.fontSizeHeader, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (controller.isLoadingCabang.value) {
          ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                  ),
                ),
              );
            },
          );
        }
        return ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              thickness: .5,
              // indent: 20,
              // endIndent: 20,
              color: Colors.grey.shade300,
            );
          },
          itemCount: controller.resultDataCabang.length,
          itemBuilder: (context, index) {
            final outlet = controller.resultDataCabang[index];
            return ListTile(
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
              trailing: Icon(
                Icons.check_circle,
                color: (outlet.id == controller.idCabang.value)
                    ? MyColors.primary
                    : Colors.grey.shade300,
              ),
            );
          },
        );
      }),
    );
  }
}
