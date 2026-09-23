import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CabangController extends GetxController {
  // ============================================================
  // STATE
  // ============================================================

  final RxList<DataListOutletBranch> resultItem = <DataListOutletBranch>[].obs;

  final RxBool isLoadingSave = false.obs;
  final RxBool isLoadingList = false.obs;

  final RxInt kiosId = 0.obs;
  final RxInt branchId = 0.obs;

  final RxString headerNamaKios = ''.obs;

  // ============================================================
  // FORM CONTROLLER
  // ============================================================

  final TextEditingController kodeCabang = TextEditingController();

  final TextEditingController namaCabang = TextEditingController();

  final TextEditingController alamatCabang = TextEditingController();

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onClose() {
    kodeCabang.dispose();
    namaCabang.dispose();
    alamatCabang.dispose();

    super.onClose();
  }

  // ============================================================
  // FORM
  // ============================================================

  void clearBranchController() {
    kodeCabang.clear();
    namaCabang.clear();
    alamatCabang.clear();

    branchId.value = 0;

    update();
  }

  void editBranch(DataListOutletBranch model) {
    branchId.value = model.id ?? 0;

    kodeCabang.text = model.kode ?? '';
    namaCabang.text = model.cabang ?? '';
    alamatCabang.text = model.alamat ?? '';

    update();
  }

  // ============================================================
  // GET LIST OUTLET
  // ============================================================

  Future<void> fetchDataListCabangFinancial() async {
    if (kiosId.value <= 0) {
      resultItem.clear();
      isLoadingList(false);
      return;
    }

    try {
      isLoadingList(true);

      final result = await RemoteDataSource.homeTotalBranchSaldo(
        kiosId.value,
      );

      if (result != null && result.data != null) {
        resultItem.assignAll(result.data!);
      } else {
        resultItem.clear();
      }
    } catch (error) {
      resultItem.clear();

      Get.snackbar(
        'Gagal',
        'Gagal mengambil data outlet.',
        icon: const Icon(
          Icons.error_outline_rounded,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingList(false);
    }
  }

  // ============================================================
  // SAVE / UPDATE OUTLET
  // ============================================================

  Future<bool> saveBranch() async {
    if (isLoadingSave.value) {
      return false;
    }

    try {
      // ----------------------------------------------------------
      // VALIDASI
      // ----------------------------------------------------------

      if (kodeCabang.text.trim().isEmpty) {
        _showWarning('Kode outlet wajib diisi.');
        return false;
      }

      if (namaCabang.text.trim().isEmpty) {
        _showWarning('Nama outlet wajib diisi.');
        return false;
      }

      if (alamatCabang.text.trim().isEmpty) {
        _showWarning('Alamat outlet wajib diisi.');
        return false;
      }

      if (kiosId.value <= 0) {
        _showWarning('Brand tidak ditemukan.');
        return false;
      }

      // ----------------------------------------------------------
      // LOADING
      // ----------------------------------------------------------

      isLoadingSave(true);

      // ----------------------------------------------------------
      // PAYLOAD
      // ----------------------------------------------------------

      final rawFormat = {
        'kios_id': kiosId.value,
        'cabang_id': branchId.value,
        'kode_cabang': kodeCabang.text.trim(),
        'nama_cabang': namaCabang.text.trim(),
        'alamat_cabang': alamatCabang.text.trim(),
      };

      // ----------------------------------------------------------
      // REQUEST
      // ----------------------------------------------------------

      final result = await RemoteDataSource.saveBranch(
        rawFormat,
      );

      if (!result) {
        _showError('Gagal menyimpan outlet.');
        return false;
      }

      // ----------------------------------------------------------
      // SUCCESS
      // ----------------------------------------------------------

      clearBranchController();

      await fetchDataListCabangFinancial();

      return true;
    } catch (error) {
      _showError(error.toString());
      return false;
    } finally {
      isLoadingSave(false);
    }
  }

  // ============================================================
  // DELETE OUTLET
  // ============================================================

  Future<bool> deleteBranch(int id) async {
    if (id <= 0) {
      return false;
    }

    try {
      final resultUpdate = await RemoteDataSource.deleteBranch(id);

      if (!resultUpdate) {
        _showError('Gagal menghapus outlet.');
        return false;
      }

      await fetchDataListCabangFinancial();

      return true;
    } catch (error) {
      _showError(error.toString());
      return false;
    }
  }

  // ============================================================
  // UPDATE STATUS OUTLET
  // ============================================================

  Future<bool> updateStatusBranch(
    int id,
    bool status,
  ) async {
    if (id <= 0) {
      return false;
    }

    try {
      final rawFormat = {
        'id': id,
        'status': status,
      };

      final resultUpdate = await RemoteDataSource.updateStatusBranch(
        rawFormat,
      );

      if (!resultUpdate) {
        _showError('Gagal mengubah status outlet.');
        return false;
      }

      await fetchDataListCabangFinancial();

      return true;
    } catch (error) {
      _showError(error.toString());
      return false;
    }
  }

  // ============================================================
  // HELPER
  // ============================================================

  void setBrand({
    required int idKios,
    required String namaKios,
  }) {
    kiosId.value = idKios;
    headerNamaKios.value = namaKios;
  }

  void resetOutlet() {
    kiosId.value = 0;
    branchId.value = 0;
    headerNamaKios.value = '';

    resultItem.clear();

    clearBranchController();
  }

  void _showWarning(String message) {
    Get.snackbar(
      'Perhatian',
      message,
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Gagal',
      message,
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
