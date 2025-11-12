import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/models/employee_model.dart';
import 'package:cashier_management/pages/setting/employee/change_outlet_page.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;

class ListEmployeePage extends StatefulWidget {
  const ListEmployeePage({super.key});

  @override
  State<ListEmployeePage> createState() => _ListEmployeePageState();
}

class _ListEmployeePageState extends State<ListEmployeePage>
    with SingleTickerProviderStateMixin {
  final EmployeeController employeeController = Get.find<EmployeeController>();

  @override
  void initState() {
    super.initState();
    employeeController.fetchDataListKios(
      onAfterSuccess: () => employeeController.fetchDataListCabang(
        onAfterSuccess: () async => employeeController.fetchDataListEmployee(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        surfaceTintColor: Colors.transparent,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Employee Settings',
              style: TextStyle(
                  fontSize: MySizes.fontSizeHeader,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              employeeController.clearEmployeeController();
              Get.toNamed(RouterClass.addemployee);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// --- MENU ---
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              color: Colors.grey[200],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KIOS
                  Obx(() {
                    return DropdownTabButton(
                      label: employeeController.selectedKios.value,
                      isLoading: employeeController.isLoadingKios.value,
                      onTap: () {
                        Get.to(
                          () => ChangeOutletPage(
                              controller: Get.find<EmployeeController>()),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  if (employeeController.isLoadingEmployee.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final items = employeeController.resultDataEmployee;
                    if (items.isEmpty) {
                      return const Center(child: Text("No data found"));
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var data = items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            color: Colors.white,
                            child: _buildAccountTile(
                              id: data.idKasir!,
                              name: data.namaKasir!,
                              username: data.usernameKasir!,
                              phone: data.phoneKasir!,
                              cabangId: data.idCabang!,
                              cabang: data.cabang!,
                              defaultOutletName: data.defaultOutletName!,
                              defaultOutletId: data.defaultOutlet!,
                              isActive: data.statusKasir!,
                              statusTransaksi: data.statusTransaksi!,
                              dataEmployee: data,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required int id,
    required String name,
    required String username,
    required String phone,
    required List<int> cabangId,
    required List<String> cabang,
    required String defaultOutletName,
    required int defaultOutletId,
    bool isActive = false,
    bool statusTransaksi = false,
    required DataEmployee dataEmployee,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // DIALOG CONFIRMATION ACTIVE OR INACTIVE
                  Get.bottomSheet(
                    ConfirmDialog(
                        title: isActive
                            ? 'Non-Activate Cashier'
                            : 'Activate Cashier',
                        message: isActive
                            ? 'This cashier will be deactivated.\nAre you sure you want to continue?'
                            : 'This cashier will be activated.\nAre you sure you want to continue?',
                        onConfirm: () async {
                          employeeController.updateEmployeeStatus(
                            id,
                            !isActive,
                          );
                        }),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/clerk.png'),
                      backgroundColor: Colors.white,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green : Colors.red,
                          border: Border.all(color: Colors.white, width: 2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Gap(2),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_box_outlined,
                        size: 16,
                        color: MyColors.grey,
                      ),
                      const Gap(5),
                      Text(
                        username,
                        style: const TextStyle(
                          color: MyColors.grey,
                          fontSize: MySizes.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                  const Gap(2),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 16,
                        color: MyColors.grey,
                      ),
                      const Gap(5),
                      Text(
                        phone,
                        style: const TextStyle(
                          color: MyColors.grey,
                          fontSize: MySizes.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                  const Gap(2),
                  Row(
                    children: [
                      const Icon(
                        Icons.home,
                        size: 16,
                        color: MyColors.grey,
                      ),
                      const Gap(5),
                      Text(
                        defaultOutletName,
                        style: const TextStyle(
                          color: MyColors.grey,
                          fontSize: MySizes.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                  const Gap(2),
                  SizedBox(
                    width: 300,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          employeeController.listCabang.map<Widget>((cabang) {
                        final int cabangValue = cabang['value'];
                        final String cabangNama = cabang['nama'];
                        final bool isSelected = cabangId.contains(cabangValue);
                        return GestureDetector(
                          onTap: () {
                            // print('Cabang dipilih: $cabangNama ($cabangValue)');
                            if (isSelected) {
                              // if selected just one then can't remove
                              if (cabangId.length == 1) {
                                Get.snackbar(
                                  'Error',
                                  'Cannot delete this employee, because there is only one branch assigned to this employee.',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red[100],
                                  colorText: Colors.red[800],
                                );
                                return;
                              }
                              Get.bottomSheet(
                                ConfirmDialog(
                                  title: 'Remove Employee from Outlet',
                                  message:
                                      'This employee will be removed from $cabangNama.\nAre you sure you want to continue?',
                                  onConfirm: () async {
                                    employeeController.processKasirCabang(
                                        id, cabangValue, 'remove');
                                  },
                                ),
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                              );
                            } else {
                              Get.bottomSheet(
                                ConfirmDialog(
                                  title: 'Add Employee to Outlet',
                                  message:
                                      'This employee will be added to $cabangNama.\nAre you sure you want to continue?',
                                  onConfirm: () async {
                                    employeeController.processKasirCabang(
                                        id, cabangValue, 'add');
                                  },
                                ),
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? MyColors.secondary
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              cabangNama,
                              style: TextStyle(
                                fontSize: MySizes.fontSizeSm,
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -10,
            right: -10,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "edit") {
                  employeeController.editEmployee(dataEmployee);
                  Get.toNamed(RouterClass.addemployee);
                  return;
                }
                if (value == "delete") {
                  // can't delete employee if they are having an order
                  if (statusTransaksi) {
                    Get.snackbar(
                      'Error',
                      'Cannot delete this employee, it has financial records.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red[100],
                      colorText: Colors.red[800],
                    );
                    return;
                  }
                  // Show confirmation dialog
                  Get.bottomSheet(
                    ConfirmDialog(
                      title: 'Delete Employee',
                      message:
                          'Are you sure, you want to delete this employee?',
                      onConfirm: () async {
                        employeeController.deleteEmployee(id);
                      },
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  );
                  return;
                }
                if (value == "reset_password") {
                  // Show confirmation dialog
                  Get.bottomSheet(
                    ConfirmDialog(
                      title: 'Reset Password',
                      message:
                          'Are you sure, you want to reset password this employee?',
                      onConfirm: () async {
                        employeeController.resetPassword(id);
                      },
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
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
                const PopupMenuItem(
                  value: "reset_password",
                  child: Row(
                    children: [
                      Icon(Icons.password),
                      Gap(8),
                      Text("Reset Password"),
                    ],
                  ),
                ),
              ],
              color: Colors.white,
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownTabButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const DropdownTabButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            isLoading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.keyboard_arrow_down,
                    color: MyColors.grey,
                  ),
          ],
        ),
      ),
    );
  }
}
