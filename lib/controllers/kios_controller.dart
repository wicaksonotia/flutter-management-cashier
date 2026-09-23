import 'dart:io';

import 'package:cashier_management/controllers/base_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class KiosController extends BaseController {
  @override
  var resultDataKios = <KiosModel>[].obs;

  var isLoading = true.obs;
  var isLoadingFinancialKios = true.obs;
  var isLoadingSaveKios = true.obs;

  final TextEditingController kios = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController description = TextEditingController();

  /// Logo yang sedang ditampilkan dari server.
  var logo = ''.obs;

  /// Logo lama yang akan dikirim ke backend
  /// untuk kebutuhan replace/delete file lama.
  var oldLogo = ''.obs;

  /// File logo baru yang dipilih dari device.
  var pickedFile1 = XFile('').obs;

  // ============================================================
  // RESET FORM
  // ============================================================

  void clearOutletController() {
    kios.clear();
    phone.clear();
    description.clear();

    logo.value = '';
    oldLogo.value = '';

    idKios.value = 0;

    resetPickedLogo();

    update();
  }

  /// Reset hanya file lokal yang dipilih.
  ///
  /// Dipanggil ketika:
  /// - membuka form baru
  /// - membuka edit brand lain
  /// - selesai save
  /// - membatalkan perubahan logo
  void resetPickedLogo() {
    pickedFile1.value = XFile('');
  }

  // ============================================================
  // EDIT
  // ============================================================

  void editKios(KiosModel kiosModel) {
    // Sangat penting:
    // jangan membawa file lokal dari proses edit sebelumnya.
    resetPickedLogo();

    kios.text = kiosModel.kios ?? '';
    phone.text = kiosModel.phone ?? '';
    description.text = kiosModel.keterangan ?? '';

    logo.value = kiosModel.logo ?? '';
    oldLogo.value = kiosModel.logo ?? '';

    idKios.value = kiosModel.idKios ?? 0;

    update();
  }

  // ============================================================
  // FETCH
  // ============================================================

  Future<void> fetchDataListKiosFinancial() async {
    try {
      isLoadingFinancialKios(false);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final rawFormat = {
        'id_owner': prefs.getInt('id_owner')!,
      };

      final result = await RemoteDataSource.getListKiosAndDetail(rawFormat);

      if (result != null) {
        resultDataKios.assignAll(result);
      }
    } finally {
      isLoadingFinancialKios(false);
    }
  }

  // ============================================================
  // CHANGE OUTLET
  // ============================================================

  Future<void> changeOutlet() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'id_kios',
      idKios.value,
    );

    await prefs.setString(
      'kios',
      selectedKios.value,
    );
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Future<void> selectImage1(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final picked = await picker.pickImage(
      source: source,
    );

    if (picked == null) return;

    pickedFile1.value = picked;
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> saveOutlet() async {
    try {
      isLoadingSaveKios(true);

      // --------------------------------------------------------
      // VALIDASI
      // --------------------------------------------------------

      if (kios.text.trim().isEmpty ||
          phone.text.trim().isEmpty ||
          description.text.trim().isEmpty) {
        throw 'Please fill all fields';
      }

      final filePath = pickedFile1.value.path;
      final logoFromApi = logo.value;
      final oldLogoFromApi = oldLogo.value;

      late dio.FormData formData;

      // --------------------------------------------------------
      // LOGO BARU
      // --------------------------------------------------------

      if (filePath.isNotEmpty) {
        final file = File(filePath);

        if (!file.existsSync()) {
          throw 'Selected image not found';
        }

        final fileSizeInBytes = await file.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 2) {
          throw 'File size must be less than 2 MB';
        }

        formData = dio.FormData.fromMap({
          'id_owner': idOwner.value,
          'kios_id': idKios.value,
          'kios': kios.text.trim(),
          'phone': phone.text.trim(),
          'description': description.text.trim(),
          'old_logo': oldLogoFromApi,
          'logo': await dio.MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          ),
        });
      }

      // --------------------------------------------------------
      // TANPA LOGO BARU
      // --------------------------------------------------------

      else {
        if (logoFromApi.isEmpty) {
          throw 'Please select an image';
        }

        formData = dio.FormData.fromMap({
          'id_owner': idOwner.value,
          'kios_id': idKios.value,
          'kios': kios.text.trim(),
          'phone': phone.text.trim(),
          'description': description.text.trim(),
          'old_logo': oldLogoFromApi,
          'logo': logoFromApi,
        });
      }

      // --------------------------------------------------------
      // REQUEST
      // --------------------------------------------------------

      final result = await RemoteDataSource.saveOutlet(formData);

      if (!result) {
        throw 'Failed to save Kios';
      }

      // --------------------------------------------------------
      // CLEAR STATE
      // --------------------------------------------------------

      clearOutletController();

      Get.snackbar(
        'Success',
        'Kios saved successfully',
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        snackPosition: SnackPosition.TOP,
      );
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(
          Icons.error,
        ),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingSaveKios(false);

      fetchDataListKiosFinancial();
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> deleteOutlet(int id) async {
    final resultUpdate = await RemoteDataSource.deleteOutlet(id);

    if (resultUpdate) {
      Get.snackbar(
        'Notification',
        'Data deleted successfully',
        icon: const Icon(
          Icons.check,
        ),
        snackPosition: SnackPosition.TOP,
      );

      fetchDataListKiosFinancial();
    } else {
      Get.snackbar(
        'Notification',
        'Failed to delete data',
        icon: const Icon(
          Icons.error,
        ),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ============================================================
  // STATUS
  // ============================================================

  Future<void> updateStatusOutlet(
    int id,
    bool newStatus,
  ) async {
    try {
      final rawFormat = {
        'id': id,
        'status': newStatus,
      };

      final success = await RemoteDataSource.updateOutletStatus(
        rawFormat,
      );

      if (success) {
        final index = resultDataKios.indexWhere(
          (item) => item.idKios == id,
        );

        if (index != -1) {
          resultDataKios[index].isActive = newStatus;
          resultDataKios.refresh();
        }

        Get.snackbar(
          'Notification',
          'Status updated successfully',
          icon: const Icon(
            Icons.check,
          ),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Notification',
          'Failed to update data',
          icon: const Icon(
            Icons.error,
          ),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        icon: const Icon(
          Icons.error,
        ),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
