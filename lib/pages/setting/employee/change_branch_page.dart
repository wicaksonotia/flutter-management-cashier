import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeBranchPage extends StatefulWidget {
  const ChangeBranchPage({super.key});

  @override
  State<ChangeBranchPage> createState() => _ChangeBranchPageState();
}

class _ChangeBranchPageState extends State<ChangeBranchPage> {
  final EmployeeController employeeController = Get.find<EmployeeController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .3,
      maxChildSize: 0.9,
      minChildSize: .2,
      builder: (context, scrollController) {
        return Obx(() {
          if (employeeController.isLoadingCabang.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: employeeController.resultDataCabang.length,
              itemBuilder: (context, index) {
                final outlet = employeeController.resultDataCabang[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () {
                      employeeController.idCabang.value = outlet.id!;
                      employeeController.selectedCabang.value = outlet.cabang!;
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
                        color: (outlet.id == employeeController.idCabang.value)
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
