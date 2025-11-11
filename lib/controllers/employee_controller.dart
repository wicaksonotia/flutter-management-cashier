import 'dart:convert';

import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/employee_model.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeController extends GetxController {
  var resultDataEmployee = <DataEmployee>[].obs;
  var resultDataKios = <KiosModel>[].obs;
  var resultDataCabang = <DataListOutletBranch>[].obs;
  RxList<Map<String, dynamic>> listKios = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listCabang = <Map<String, dynamic>>[].obs;
  var isLoadingSave = true.obs;
  var isLoadingEmployee = true.obs;
  var isLoadingKios = true.obs;
  var isLoadingCabang = true.obs;
  var idKios = 0.obs;
  var selectedKios = 'Kios'.obs;
  var idCabang = 0.obs;
  var selectedCabang = 'Cabang'.obs;

  var idKasir = 0.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController noTelponController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDataListKios();
  }

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

  void fetchDataListKios() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = {'id_owner': prefs.getInt('id_owner')!};
      var result = await RemoteDataSource.getListKios(rawFormat);
      if (result != null) {
        resultDataKios.assignAll(result);
        idKios.value = prefs.getInt('id_kios')!;
        selectedKios.value = result.first.kios!;
        listKios.assignAll(result.map((category) => {
              'value': category.idKios,
              'nama': category.kios!,
            }));
        fetchDataListCabang();
        // fetchDataListEmployee();
      }
    } finally {
      isLoadingKios(false);
    }
  }

  void fetchDataListCabang() async {
    try {
      var rawFormat = {'id_kios': idKios.value};
      var result = await RemoteDataSource.getListCabangKios(rawFormat);
      if (result != null) {
        resultDataCabang.assignAll(result);
        idCabang.value = result.first.id!;
        selectedCabang.value = result.first.cabang!;
        listCabang.assignAll(result.map((category) => {
              'value': category.id,
              'nama': category.cabang!,
            }));
        fetchDataListEmployee();
      }
    } finally {
      isLoadingCabang(false);
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
      print(jsonEncode(rawFormat));
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
