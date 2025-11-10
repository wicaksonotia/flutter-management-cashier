import 'dart:ui';

import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage>
    with SingleTickerProviderStateMixin {
  final EmployeeController employeeController = Get.find<EmployeeController>();
  bool isDropdownKiosOpen = false;
  bool isDropdownCabangOpen = false;

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  // late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    // _scaleAnimation = Tween<double>(begin: 0.98, end: 1).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    // );
  }

  void toggleDropdownKios() {
    setState(() {
      isDropdownKiosOpen = !isDropdownKiosOpen;
      if (isDropdownKiosOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void toggleDropdownCabang() {
    setState(() {
      isDropdownCabangOpen = !isDropdownCabangOpen;
      if (isDropdownCabangOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              // _kiosController.clearOutletController();
              // Get.toNamed(RouterClass.addoutlet);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const Gap(70), // beri jarak agar header tidak ketimpa
                Expanded(child: Obx(
                  () {
                    if (employeeController.isLoadingEmployee.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: employeeController.resultDataEmployee.length,
                        itemBuilder: (context, index) {
                          var employee =
                              employeeController.resultDataEmployee[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              color: Colors.white,
                              child: _buildAccountTile(
                                name: employee.namaKasir!,
                                username: employee.usernameKasir!,
                                phone: employee.phoneKasir!,
                                isActive: employee.statusKasir!,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                )),
              ],
            ),

            /// --- BACKDROP BLUR (HANYA MENUTUP LIST) ---
            if (isDropdownKiosOpen)
              Positioned.fill(
                top: 60, // mulai blur setelah tombol lokasi
                child: GestureDetector(
                  onTap: toggleDropdownKios,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            if (isDropdownCabangOpen)
              Positioned.fill(
                top: 60, // mulai blur setelah tombol lokasi
                child: GestureDetector(
                  onTap: toggleDropdownCabang,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),

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
                      isOpen: isDropdownKiosOpen,
                      isLoading: employeeController.isLoadingKios.value,
                      isDisabled:
                          isDropdownCabangOpen, // 👈 disable saat cabang open
                      onTap: toggleDropdownKios,
                    );
                  }),

                  const Gap(10),

                  // CABANG
                  Obx(() {
                    return DropdownTabButton(
                      label: employeeController.selectedCabang.value,
                      isOpen: isDropdownCabangOpen,
                      isLoading: employeeController.isLoadingCabang.value,
                      isDisabled:
                          isDropdownKiosOpen, // 👈 disable saat cabang open
                      onTap: toggleDropdownCabang,
                    );
                  }),
                ],
              ),
            ),

            /// --- DROPDOWN MENU ---
            _buildDropdownMenu(
              isOpen: isDropdownKiosOpen,
              opacityAnimation: _opacityAnimation,
              slideAnimation: _slideAnimation,
              source: employeeController.listKios,
              selectedValue: employeeController.idKios.value,
              onChanged: (val) {
                employeeController.idKios.value = val;
                final selectedItem = employeeController.listKios.firstWhere(
                  (item) => item['value'] == val,
                  orElse: () => {},
                );
                if (selectedItem.isNotEmpty) {
                  employeeController.selectedKios.value = selectedItem['nama'];
                }
                employeeController.fetchDataListCabang();
              },
              onClose: toggleDropdownKios,
            ),

            _buildDropdownMenu(
              isOpen: isDropdownCabangOpen,
              opacityAnimation: _opacityAnimation,
              slideAnimation: _slideAnimation,
              source: employeeController.listCabang,
              selectedValue: employeeController.idCabang.value,
              onChanged: (val) {
                employeeController.idCabang.value = val;
                final selectedItem = employeeController.listCabang.firstWhere(
                  (item) => item['value'] == val,
                  orElse: () => {},
                );
                if (selectedItem.isNotEmpty) {
                  employeeController.selectedCabang.value =
                      selectedItem['nama'];
                }
                employeeController.fetchDataListEmployee();
              },
              onClose: toggleDropdownCabang,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile({
    required String name,
    required String username,
    required String phone,
    bool isActive = false,
  }) {
    return ListTile(
      leading: Stack(
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
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildDropdownMenu({
    required bool isOpen,
    required Animation<double> opacityAnimation,
    required Animation<Offset> slideAnimation,
    required List<Map<String, dynamic>> source,
    required int selectedValue,
    required ValueChanged<int> onChanged,
    required VoidCallback onClose,
  }) {
    return Positioned(
      top: 58,
      left: 0,
      right: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        child: isOpen
            ? FadeTransition(
                opacity: opacityAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: Container(
                    width: double.infinity,
                    key: const ValueKey("dropdown"),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                    child: ChipsChoice.single(
                      wrapped: true,
                      padding: EdgeInsets.zero,
                      value: selectedValue,
                      onChanged: (val) {
                        onChanged(val);
                        onClose();
                      },
                      choiceItems: C2Choice.listFrom<int, Map<String, dynamic>>(
                        source: source,
                        value: (i, v) => v['value']!,
                        label: (i, v) => v['nama']!,
                      ),
                      choiceCheckmark: false,
                      choiceStyle: C2ChipStyle.filled(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade100,
                        selectedStyle: const C2ChipStyle(
                          backgroundColor: MyColors.primary,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class DropdownTabButton extends StatelessWidget {
  final String label;
  final bool isOpen;
  final bool isLoading;
  final VoidCallback onTap;
  final bool isDisabled; // 👈 tambahan

  const DropdownTabButton({
    super.key,
    required this.label,
    required this.isOpen,
    required this.isLoading,
    required this.onTap,
    this.isDisabled = false, // 👈 default false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap, // 👈 tidak bisa diklik saat disable
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        height: isOpen ? 50 : 40,
        decoration: BoxDecoration(
          color: isOpen ? Colors.white : Colors.grey.shade300,
        ),
        // decoration: BoxDecoration(
        //   color: isOpen ? Colors.white : Colors.grey.shade200,
        //   borderRadius: BorderRadius.only(
        //     topLeft: const Radius.circular(8),
        //     topRight: const Radius.circular(8),
        //     bottomLeft: isOpen ? Radius.zero : const Radius.circular(8),
        //     bottomRight: isOpen ? Radius.zero : const Radius.circular(8),
        //   ),
        //   border: isOpen
        //       ? const Border(
        //           top: BorderSide(color: Colors.grey),
        //           left: BorderSide(color: Colors.grey),
        //           right: BorderSide(color: Colors.grey),
        //         )
        //       : Border.all(color: Colors.grey),
        // ),
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
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
                  : Icon(
                      isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: MyColors.grey,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
