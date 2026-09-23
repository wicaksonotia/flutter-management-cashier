import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeController extends BaseController {
  // ==========================================================
  // DATA
  // ==========================================================

  final resultDataEmployee = <DataEmployee>[].obs;

  final isLoadingSaveEmployee = false.obs;
  final isLoadingEmployee = true.obs;

  final idKasir = 0.obs;

  // ==========================================================
  // FORM
  // ==========================================================

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController namaController = TextEditingController();

  final TextEditingController noTelponController = TextEditingController();

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void onInit() {
    super.onInit();

    usernameController.addListener(update);
    namaController.addListener(update);
    noTelponController.addListener(update);
  }

  // ==========================================================
  // VALIDATION
  // ==========================================================

  bool get canSaveEmployee {
    return usernameController.text.trim().isNotEmpty &&
        namaController.text.trim().isNotEmpty &&
        noTelponController.text.trim().isNotEmpty &&
        idCabang.value != 0;
  }

  // ==========================================================
  // USERNAME PREFIX
  // ==========================================================

  /// Membuat prefix username berdasarkan nama brand.
  ///
  /// Contoh:
  /// Himalaya       -> himalaya-
  /// Helios         -> helios-
  /// Helios Adikara -> helios-adikara-
  /// Citra Vera     -> citra-vera-
  /// CitraVera      -> citravera-
  String generateUsernamePrefix(String brand) {
    final normalized =
        brand.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '.');

    if (normalized.isEmpty) {
      return '';
    }

    return '$normalized.';
  }

  /// Mengisi username awal dengan prefix brand.
  ///
  /// Hanya dipanggil saat membuat karyawan baru.
  /// Setelah user mulai mengedit username, method ini tidak
  /// dipanggil otomatis lagi.
  void setInitialUsernamePrefix() {
    if (idKasir.value != 0) {
      return;
    }

    final prefix = generateUsernamePrefix(
      selectedKios.value,
    );

    if (prefix.isEmpty) {
      usernameController.clear();
      return;
    }

    usernameController.value = TextEditingValue(
      text: prefix,
      selection: TextSelection.collapsed(
        offset: prefix.length,
      ),
    );

    update();
  }

  // ==========================================================
  // CLEAR FORM
  // ==========================================================

  void clearEmployeeController() {
    idKasir.value = 0;

    usernameController.clear();
    namaController.clear();
    noTelponController.clear();

    idCabang.value = 0;
    selectedCabang.value = '';

    // Username baru otomatis mendapatkan prefix brand.
    setInitialUsernamePrefix();

    update();
  }

  // ==========================================================
  // EDIT
  // ==========================================================

  void editEmployee(DataEmployee employeeModel) {
    idKasir.value = employeeModel.idKasir!;

    // Username existing tidak diubah.
    usernameController.text = employeeModel.usernameKasir!;

    namaController.text = employeeModel.namaKasir!;

    noTelponController.text = employeeModel.phoneKasir!;

    idCabang.value = employeeModel.defaultOutlet!;

    selectedCabang.value = employeeModel.defaultOutletName!;

    update();
  }

  // ==========================================================
  // FETCH EMPLOYEE
  // ==========================================================

  Future<void> fetchDataListEmployee() async {
    try {
      isLoadingEmployee(true);

      final rawFormat = {
        'id_kios': idKios.value,
      };

      final result = await RemoteDataSource.getListEmployee(
        rawFormat,
      );

      if (result != null) {
        resultDataEmployee.assignAll(result);
      }
    } finally {
      isLoadingEmployee(false);
    }
  }

  // ==========================================================
  // SAVE
  // ==========================================================

  // ==========================================================
// SAVE
// ==========================================================

  Future<Map<String, dynamic>> saveEmployee() async {
    try {
      isLoadingSaveEmployee(true);
      update();

      final username = usernameController.text.trim();
      final nama = namaController.text.trim();
      final phone = noTelponController.text.trim();

      if (username.isEmpty || nama.isEmpty || phone.isEmpty) {
        throw '* Semua field wajib diisi';
      }

      if (username.contains(' ')) {
        throw '* Username tidak boleh mengandung spasi';
      }

      if (idCabang.value == 0) {
        throw '* Silakan pilih outlet';
      }

      final rawFormat = {
        'id_kasir': idKasir.value,
        'username': username,
        'nama_kasir': nama,
        'phone_kasir': phone,
        'id_cabang': idCabang.value,
      };

      final result = await RemoteDataSource.saveEmployee(
        rawFormat,
      );

      if (result['status'] != 'ok') {
        return result;
      }

      Get.snackbar(
        'Notifikasi',
        idKasir.value != 0
            ? 'Karyawan berhasil diperbarui'
            : 'Karyawan berhasil ditambahkan',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );

      await fetchDataListEmployee();

      return result;
    } catch (error) {
      return {
        'status': 'error',
        'message': error.toString(),
      };
    } finally {
      isLoadingSaveEmployee(false);
      update();
    }
  }

  // ==========================================================
  // UPDATE STATUS
  // ==========================================================

  Future<void> updateEmployeeStatus(
    int id,
    bool newStatus,
  ) async {
    try {
      final rawFormat = {
        'id': id,
        'status': newStatus,
      };

      final success = await RemoteDataSource.updateEmployeeStatus(
        rawFormat,
      );

      if (success) {
        final index = resultDataEmployee.indexWhere(
          (item) => item.idKasir == id,
        );

        if (index != -1) {
          resultDataEmployee[index].statusKasir = newStatus;

          resultDataEmployee.refresh();
        }

        Get.snackbar(
          'Notifikasi',
          'Status berhasil diperbarui',
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Notifikasi',
          'Gagal memperbarui data',
          icon: const Icon(Icons.error),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ==========================================================
  // EMPLOYEE - BRANCH
  // ==========================================================

  Future<void> processKasirCabang(
    int idEmployee,
    int idOutlet,
    String proses,
  ) async {
    final rawFormat = {
      'id_kasir': idEmployee,
      'id_kios_cabang': idOutlet,
      'proses': proses,
    };

    final resultUpdate = await RemoteDataSource.updateEmployeeBranch(
      rawFormat,
    );

    if (resultUpdate) {
      Get.snackbar(
        'Notifikasi',
        'Data berhasil diperbarui',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );

      fetchDataListEmployee();
    } else {
      Get.snackbar(
        'Notifikasi',
        'Gagal memperbarui data',
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  Future<void> deleteEmployee(int id) async {
    final resultUpdate = await RemoteDataSource.deleteEmployee(id);

    if (resultUpdate) {
      Get.snackbar(
        'Notifikasi',
        'Data berhasil dihapus',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );

      fetchDataListEmployee();
    } else {
      Get.snackbar(
        'Notifikasi',
        'Gagal menghapus data',
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ==========================================================
  // RESET PASSWORD
  // ==========================================================

  Future<void> resetPassword(int id) async {
    final result = await RemoteDataSource.resetPassword(id);

    if (result) {
      Get.snackbar(
        'Notifikasi',
        'Password berhasil direset',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        'Notifikasi',
        'Gagal mereset password',
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void onClose() {
    usernameController.dispose();
    namaController.dispose();
    noTelponController.dispose();

    super.onClose();
  }
}
