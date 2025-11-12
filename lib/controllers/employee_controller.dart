// import 'dart:convert';

import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/employee_model.dart';
// import 'package:cashier_management/models/kios_model.dart';
// import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class EmployeeController extends BaseController {
  var resultDataEmployee = <DataEmployee>[].obs;
  var isLoadingSave = true.obs;
  var isLoadingEmployee = true.obs;

  var idKasir = 0.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController noTelponController = TextEditingController();

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchDataListKios(
  //     onAfterSuccess: () async => fetchDataListEmployee(),
  //   );
  // }

  void clearEmployeeController() {
    idKasir.value = 0;
    usernameController.clear();
    namaController.clear();
    noTelponController.clear();
    idCabang.value = 0;
    selectedCabang.value = 'Cabang';
    update();
  }

  void editEmployee(DataEmployee employeeModel) {
    idKasir.value = employeeModel.idKasir!;
    usernameController.text = employeeModel.usernameKasir!;
    namaController.text = employeeModel.namaKasir!;
    noTelponController.text = employeeModel.phoneKasir!;
    idCabang.value = employeeModel.defaultOutlet!;
    selectedCabang.value = employeeModel.defaultOutletName!;
    update();
  }

  void fetchDataListEmployee() async {
    try {
      var rawFormat = {
        'id_kios': idKios.value,
        // 'id_cabang': idCabang.value,
      };
      var result = await RemoteDataSource.getListEmployee(rawFormat);
      if (result != null) {
        resultDataEmployee.assignAll(result);
      }
    } finally {
      isLoadingEmployee(false);
    }
  }

  Future<void> saveEmployee() async {
    try {
      isLoadingSave(true);
      if (usernameController.text.isEmpty ||
          namaController.text.isEmpty ||
          noTelponController.text.isEmpty) {
        throw "* All fields are required";
      }
      if (usernameController.text.contains(' ')) {
        throw "* Username cannot contain spaces";
      }
      if (idCabang.value == 0) {
        throw "* Please select a branch";
      }
      var rawFormat = {
        "id_kasir": idKasir.value,
        "username": usernameController.text,
        "nama_kasir": namaController.text,
        "phone_kasir": noTelponController.text,
        "id_cabang": idCabang.value,
      };
      bool result = await RemoteDataSource.saveEmployee(rawFormat);
      if (result) {
        Get.snackbar(
          'Notification',
          'Saved successfully',
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP,
        );
        fetchDataListEmployee();
      } else {
        throw "Failed to save data";
      }
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingSave(false);
    }
  }

  void updateEmployeeStatus(int id, bool status) async {
    var rawFormat = {'id': id, 'status': status};
    var resultUpdate = await RemoteDataSource.updateEmployeeStatus(rawFormat);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data updated successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListEmployee();
    } else {
      Get.snackbar('Notification', 'Failed to update data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }

  void processKasirCabang(int idEmployee, int idOutlet, String proses) async {
    var rawFormat = {
      'id_kasir': idEmployee,
      'id_kios_cabang': idOutlet,
      'proses': proses
    };
    var resultUpdate = await RemoteDataSource.updateEmployeeBranch(rawFormat);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data updated successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListEmployee();
    } else {
      Get.snackbar('Notification', 'Failed to update data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }

  void deleteEmployee(int id) async {
    var resultUpdate = await RemoteDataSource.deleteEmployee(id);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data deleted successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListEmployee();
    } else {
      Get.snackbar('Notification', 'Failed to delete data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }
}
