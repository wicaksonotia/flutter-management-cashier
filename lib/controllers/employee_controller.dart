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

  final selectedOutletIds = <int>[].obs;
  final defaultOutletId = 0.obs;

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
        selectedOutletIds.isNotEmpty &&
        defaultOutletId.value != 0;
  }

  // ==========================================================
  // USERNAME PREFIX
  // ==========================================================

  /// Membuat prefix username berdasarkan nama brand.
  ///
  /// Contoh:
  /// Himalaya       -> himalaya.
  /// Helios         -> helios.
  /// Helios Adikara -> helios.adikara.
  /// Citra Vera     -> citra.vera.
  /// CitraVera      -> citravera.
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
  /// Hanya digunakan saat membuat karyawan baru.
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

    selectedOutletIds.clear();
    defaultOutletId.value = 0;

    setInitialUsernamePrefix();

    update();
  }

  // ==========================================================
  // EDIT
  // ==========================================================

  void editEmployee(DataEmployee employeeModel) {
    // ========================================================
    // RESET STATE OUTLET
    // ========================================================

    selectedOutletIds.clear();
    defaultOutletId.value = 0;

    // ========================================================
    // DATA KARYAWAN
    // ========================================================

    idKasir.value = employeeModel.idKasir!;

    usernameController.text = employeeModel.usernameKasir ?? '';

    namaController.text = employeeModel.namaKasir ?? '';

    noTelponController.text = employeeModel.phoneKasir ?? '';

    // ========================================================
    // OUTLET
    // ========================================================

    if (employeeModel.idCabang != null) {
      selectedOutletIds.assignAll(
        employeeModel.idCabang!,
      );
    }

    // ========================================================
    // DEFAULT OUTLET
    // ========================================================

    if (employeeModel.defaultOutlet != null) {
      defaultOutletId.value = employeeModel.defaultOutlet!;
    }

    update();
  }

  // ==========================================================
  // FETCH EMPLOYEE
  // ==========================================================

  Future<void> fetchDataListEmployee({
    int? kiosId,
  }) async {
    try {
      isLoadingEmployee(true);

      // Jika kiosId diberikan, sinkronkan idKios terlebih dahulu.
      if (kiosId != null && kiosId > 0) {
        idKios.value = kiosId;
      }

      final rawFormat = {
        'id_kios': idKios.value,
      };

      final result = await RemoteDataSource.getListEmployee(
        rawFormat,
      );

      if (result != null) {
        resultDataEmployee.assignAll(result);
      } else {
        resultDataEmployee.clear();
      }
    } finally {
      isLoadingEmployee(false);
    }
  }

  // ==========================================================
  // REFRESH AFTER BRAND CHANGED
  // ==========================================================

  Future<void> refreshAfterBrandChanged(
    int newKiosId,
  ) async {
    if (newKiosId <= 0) {
      return;
    }

    // ========================================================
    // UPDATE BRAND
    // ========================================================

    idKios.value = newKiosId;

    // ========================================================
    // CLEAR DATA LAMA
    // ========================================================

    resultDataEmployee.clear();

    // ========================================================
    // FETCH DATA BRAND BARU
    // ========================================================

    await fetchDataListEmployee(
      kiosId: newKiosId,
    );

    update();
  }

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

      // ========================================================
      // VALIDASI
      // ========================================================

      if (username.isEmpty || nama.isEmpty || phone.isEmpty) {
        throw '* Semua field wajib diisi';
      }

      if (username.contains(' ')) {
        throw '* Username tidak boleh mengandung spasi';
      }

      if (selectedOutletIds.isEmpty) {
        throw '* Silakan pilih minimal 1 outlet';
      }

      if (defaultOutletId.value == 0) {
        throw '* Silakan tentukan outlet default';
      }

      if (!selectedOutletIds.contains(
        defaultOutletId.value,
      )) {
        throw '* Outlet default harus termasuk outlet yang dipilih';
      }

      // ========================================================
      // PAYLOAD
      // ========================================================

      final rawFormat = {
        'id_kasir': idKasir.value,
        'username': username,
        'nama_kasir': nama,
        'phone_kasir': phone,
        'default_outlet': defaultOutletId.value,
        'outlets': selectedOutletIds.toList(),
      };

      // ========================================================
      // SAVE
      // ========================================================

      final result = await RemoteDataSource.saveEmployee(
        rawFormat,
      );

      if (result['status'] != 'ok') {
        return result;
      }

      // Refresh employee sesuai brand aktif.
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

      await fetchDataListEmployee();
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

  Future<bool> deleteEmployee(int id) async {
    try {
      final resultUpdate = await RemoteDataSource.deleteEmployee(id);

      if (!resultUpdate) {
        return false;
      }

      final index = resultDataEmployee.indexWhere(
        (item) => item.idKasir == id,
      );

      if (index != -1) {
        resultDataEmployee.removeAt(index);
      }

      return true;
    } catch (e) {
      return false;
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
  // OUTLET
  // ==========================================================

  void toggleOutlet(int id) {
    if (selectedOutletIds.contains(id)) {
      selectedOutletIds.remove(id);

      if (defaultOutletId.value == id) {
        defaultOutletId.value =
            selectedOutletIds.isEmpty ? 0 : selectedOutletIds.first;
      }
    } else {
      selectedOutletIds.add(id);

      if (defaultOutletId.value == 0) {
        defaultOutletId.value = id;
      }
    }

    update();
  }

  void setDefaultOutlet(int id) {
    if (!selectedOutletIds.contains(id)) {
      return;
    }

    defaultOutletId.value = id;

    update();
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
