import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/pages/setting/employee/employee_list.dart';
import 'package:cashier_management/utils/management_header.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  late final EmployeeController employeeController;

  @override
  void initState() {
    super.initState();

    employeeController = Get.isRegistered<EmployeeController>()
        ? Get.find<EmployeeController>()
        : Get.put(EmployeeController());

    _loadData();
  }

  Future<void> _loadData() async {
    employeeController.fetchDataListKios(
      onAfterSuccess: () => employeeController.fetchDataListCabang(
        onAfterSuccess: () async {
          await employeeController.fetchDataListEmployee();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          color: MyColors.primary,
          backgroundColor: MyColors.surface,
          onRefresh: _loadData,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // =====================================================
              // HEADER
              // =====================================================

              SliverToBoxAdapter(
                child: ManagementHeader(
                  title: 'Karyawan',
                  subtitle: 'Kelola akun dan akses outlet karyawan',
                  addLabel: 'Karyawan',
                  onAddTap: _onAddEmployee,
                ),
              ),

              // =====================================================
              // LIST
              // =====================================================

              SliverFillRemaining(
                hasScrollBody: true,
                child: EmployeeList(
                  controller: employeeController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // ADD EMPLOYEE
  // ==============================================================

  void _onAddEmployee() {
    employeeController.clearEmployeeController();

    Navigator.of(context).pushNamed(
      RouterClass.addemployee,
    );
  }
}
