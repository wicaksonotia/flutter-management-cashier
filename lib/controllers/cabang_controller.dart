import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CabangController extends GetxController {
  var resultItem = <DataListOutletBranch>[].obs;
  var isLoadingSave = true.obs;
  var isLoadingList = true.obs;
  var kiosId = 0.obs;
  var branchId = 0.obs;
  var headerNamaKios = ''.obs;
  TextEditingController kodeCabang = TextEditingController();
  TextEditingController namaCabang = TextEditingController();
  TextEditingController alamatCabang = TextEditingController();

  void clearBranchController() {
    kodeCabang.clear();
    namaCabang.clear();
    alamatCabang.clear();
    update();
  }

  void editBranch(DataListOutletBranch model) {
    kodeCabang.text = model.kode!;
    namaCabang.text = model.cabang!;
    alamatCabang.text = model.alamat!;
    branchId.value = model.id!;
    update();
  }

  void fetchDataListCabangFinancial() async {
    try {
      isLoadingList(false);
      var result = await RemoteDataSource.homeTotalBranchSaldo(kiosId.value);
      if (result != null) {
        if (result.data != null) {
          resultItem.assignAll(result.data!);
        }
      }
    } finally {
      isLoadingList(false);
    }
  }

  void saveBranch() async {
    try {
      // === CEK VALIDASI DASAR ===
      if (kodeCabang.text.isEmpty ||
          namaCabang.text.isEmpty ||
          alamatCabang.text.isEmpty) {
        throw 'Please fill all fields';
      }

      var rawFormat = {
        'kios_id': kiosId.value,
        'cabang_id': branchId.value,
        'kode_cabang': kodeCabang.text,
        'nama_cabang': namaCabang.text,
        'alamat_cabang': alamatCabang.text,
      };
      final result = await RemoteDataSource.saveBranch(rawFormat);
      if (result) {
        clearBranchController();
        Get.snackbar(
          'Success',
          'Cabang saved successfully',
          icon: const Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        throw 'Failed to save branch outlet';
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
      fetchDataListCabangFinancial();
    }
  }

  void deleteBranch(int id) async {
    var resultUpdate = await RemoteDataSource.deleteBranch(id);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data deleted successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListCabangFinancial();
    } else {
      Get.snackbar('Notification', 'Failed to delete data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }

  void updateStatusBranch(int id, bool status) async {
    var rawFormat = {'id': id, 'status': status};
    var resultUpdate = await RemoteDataSource.updateStatusBranch(rawFormat);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data updated successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListCabangFinancial();
    } else {
      Get.snackbar('Notification', 'Failed to update data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }
}
