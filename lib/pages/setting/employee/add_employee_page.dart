import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/pages/setting/change_branch_page.dart';
import 'package:cashier_management/pages/setting/change_outlet_page.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final EmployeeController employeeController = Get.find<EmployeeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade50, // Set your desired background color here
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: BackgroundForm(
              headerTitle: 'Employee Form',
              container: containerPage(),
            )),
      ),
    );
  }

  Container containerPage() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 120, 20, 0),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: employeeController.usernameController,
              decoration: InputDecoration(
                labelText: "Username *",
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const Gap(16),
            TextField(
              controller: employeeController.namaController,
              decoration: InputDecoration(
                labelText: "Employee Name *",
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const Gap(16),
            TextField(
              controller: employeeController.noTelponController,
              decoration: InputDecoration(
                labelText: "Phone Number *",
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const Gap(16),
            Obx(
              () {
                if (employeeController.idKasir.value == 0) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => ChangeOutletPage(
                                controller: Get.find<EmployeeController>()),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                          );
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Set Default Outlet',
                            labelStyle: const TextStyle(
                              color: Colors.black54,
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                employeeController.selectedKios.value,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: MyColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(16),
                    ],
                  );
                }
                return Container();
              },
            ),
            InkWell(
              onTap: () {
                Get.to(
                  () => ChangeBranchPage(
                      controller: Get.find<EmployeeController>()),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                );
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Set Default Branch',
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        employeeController.selectedCabang.value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: MyColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const Gap(50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  employeeController.saveEmployee();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: MySizes.fontSizeMd,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
