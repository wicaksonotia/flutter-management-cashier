import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ChangeOutletPage<T extends BaseController> extends StatelessWidget {
  final T controller;

  const ChangeOutletPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Outlet',
          style: TextStyle(
              fontSize: MySizes.fontSizeHeader, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (controller.isLoadingKios.value) {
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
          itemCount: controller.resultDataKios.length,
          itemBuilder: (context, index) {
            final outlet = controller.resultDataKios[index];
            return ListTile(
              onTap: () {
                Get.back();
                controller.idKios.value = outlet.idKios!;
                controller.selectedKios.value = outlet.kios!;
                controller.fetchDataListCabang();
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
              trailing: Icon(
                Icons.check_circle,
                color: outlet.idKios == controller.idKios.value
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
