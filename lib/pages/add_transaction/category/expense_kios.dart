import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ExpenseKios extends StatefulWidget {
  const ExpenseKios({super.key});

  @override
  State<ExpenseKios> createState() => _ExpenseKiosState();
}

class _ExpenseKiosState extends State<ExpenseKios> {
  final KiosController _kiosController = Get.find<KiosController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kios'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        return _kiosController.isLoading.value
            ? ListView.builder(
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: .5,
                    color: Colors.grey.shade300,
                  );
                },
                itemCount: _kiosController.listKios.length,
                itemBuilder: (context, index) {
                  final kios = _kiosController.listKios[index];
                  return ListTile(
                    title: Text(kios.kios!),
                    onTap: () {
                      _kiosController.idKios.value = kios.idKios!;
                      _kiosController.namaKios.value = kios.kios!;
                      Get.back(result: kios);
                    },
                    trailing: Icon(
                      Icons.check_circle,
                      color: _kiosController.idKios.value == kios.idKios
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
