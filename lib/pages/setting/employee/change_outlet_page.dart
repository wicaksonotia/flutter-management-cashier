import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeOutletPage extends StatefulWidget {
  const ChangeOutletPage({super.key});

  @override
  State<ChangeOutletPage> createState() => _ChangeOutletPageState();
}

class _ChangeOutletPageState extends State<ChangeOutletPage> {
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
          if (employeeController.isLoadingKios.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount: employeeController.resultDataKios.length,
              itemBuilder: (context, index) {
                final outlet = employeeController.resultDataKios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () {
                      employeeController.idKios.value = outlet.idKios!;
                      employeeController.selectedKios.value = outlet.kios!;
                      employeeController.fetchDataListCabang();
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
                        color:
                            (outlet.idKios == employeeController.idKios.value)
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
