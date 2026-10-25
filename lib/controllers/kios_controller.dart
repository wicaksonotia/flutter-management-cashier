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
  // ============================================================
  // LOADING
  // ============================================================

  final RxBool isLoading = false.obs;
  final RxBool isLoadingFinancialKios = false.obs;
  final RxBool isLoadingSaveKios = false.obs;

  // ============================================================
  // FORM
  // ============================================================

  final TextEditingController kios = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController description = TextEditingController();

  // ============================================================
  // LOGO
  // ============================================================

  /// Nama/path logo dari server.
  ///
  /// Kosong berarti brand tidak memiliki logo.
  final RxString logo = ''.obs;

  /// Logo lama yang digunakan backend ketika:
  /// - mengganti logo
  /// - menghapus logo
  final RxString oldLogo = ''.obs;

  /// File logo baru yang dipilih dari device.
  final Rx<XFile> pickedFile1 = XFile('').obs;

  /// True jika user meminta logo lama dihapus.
  ///
  /// Logo tidak langsung dihapus dari server.
  /// Penghapusan dilakukan ketika user menekan Simpan.
  final RxBool removeLogo = false.obs;

  // ============================================================
  // FORM VALIDATION
  // ============================================================

  bool get isFormValid {
    return kios.text.trim().isNotEmpty &&
        phone.text.trim().isNotEmpty &&
        description.text.trim().isNotEmpty;
  }

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

    removeLogo.value = false;

    resetPickedLogo();

    update();
  }

  void resetPickedLogo() {
    pickedFile1.value = XFile('');
  }

  // ============================================================
  // LOGO ACTION
  // ============================================================

  /// Membatalkan status hapus logo.
  void resetLogoAction() {
    removeLogo.value = false;
    update();
  }

  /// Menandai logo lama untuk dihapus.
  ///
  /// File fisik di server baru dihapus ketika saveOutlet()
  /// berhasil diproses oleh backend.
  void removeLogoImage() {
    resetPickedLogo();

    if (logo.value.trim().isNotEmpty) {
      removeLogo.value = true;
    }

    update();
  }

  // ============================================================
  // EDIT
  // ============================================================

  void editKios(KiosModel kiosModel) {
    resetPickedLogo();

    removeLogo.value = false;

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
      isLoadingFinancialKios(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final ownerId = prefs.getInt('id_owner');

      if (ownerId == null) {
        resultDataKios.clear();
        return;
      }

      final rawFormat = {
        'id_owner': ownerId,
      };

      final result = await RemoteDataSource.getListKiosAndDetail(
        rawFormat,
      );

      if (result != null) {
        resultDataKios.assignAll(result);
      }
    } catch (e) {
      debugPrint(
        'KiosController.fetchDataListKiosFinancial: $e',
      );
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
  // IMAGE PICKER
  // ============================================================

  Future<bool> selectImage1(
    ImageSource source,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();

      final picked = await picker.pickImage(
        source: source,
      );

      if (picked == null) {
        return false;
      }

      final file = File(picked.path);

      if (!file.existsSync()) {
        return false;
      }

      final fileSizeInBytes = await file.length();

      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > 2) {
        return false;
      }

      // Memilih logo baru otomatis membatalkan
      // status hapus logo lama.
      removeLogo.value = false;

      pickedFile1.value = picked;

      update();

      return true;
    } catch (e) {
      debugPrint(
        'KiosController.selectImage1: $e',
      );

      return false;
    }
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<bool> saveOutlet() async {
    if (isLoadingSaveKios.value) return false;

    try {
      isLoadingSaveKios.value = true;

      // Nama Brand selalu disimpan dalam huruf besar.
      final String brandName = kios.text.trim().toUpperCase();

      if (brandName.isEmpty) {
        if (Get.key.currentState?.overlay != null) {
          Get.snackbar(
            'Peringatan',
            'Nama Brand wajib diisi.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        return false;
      }

      // Sinkronkan juga nilai controller dengan huruf besar.
      kios.value = kios.value.copyWith(
        text: brandName,
        selection: TextSelection.collapsed(offset: brandName.length),
        composing: TextRange.empty,
      );

      final prefs = await SharedPreferences.getInstance();

      // Simpan sesi Brand aktif sebelum penyimpanan.
      final int activeKiosId = prefs.getInt('id_kios') ?? 0;
      final int ownerId = prefs.getInt('id_owner') ?? idOwner.value;

      final Map<String, dynamic> formMap = {
        'id_owner': idOwner.value,
        'kios_id': idKios.value,
        'kios': brandName,
        'phone': phone.text.trim(),
        'description': description.text.trim(),
        'old_logo': oldLogo.value.trim(),
        'remove_logo': removeLogo.value ? '1' : '0',
      };

      // Upload logo hanya jika file benar-benar tersedia.
      final selectedFile = pickedFile1.value;

      if (selectedFile != null && selectedFile.path.trim().isNotEmpty) {
        final logoFile = File(selectedFile.path);

        if (await logoFile.exists()) {
          formMap['logo'] = await dio.MultipartFile.fromFile(
            logoFile.path,
            filename: logoFile.uri.pathSegments.last,
          );

          // Logo baru menggantikan logo lama.
          formMap['remove_logo'] = '0';
        } else {
          debugPrint('Logo tidak ditemukan: ${selectedFile.path}');

          if (Get.key.currentState?.overlay != null) {
            Get.snackbar(
              'Peringatan',
              'File logo tidak ditemukan. Silakan pilih logo kembali.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
          return false;
        }
      }

      final formData = dio.FormData.fromMap(formMap);

      final bool result = await RemoteDataSource.saveOutlet(formData);

      if (!result) {
        if (Get.key.currentState?.overlay != null) {
          Get.snackbar(
            'Gagal',
            'Brand gagal disimpan. Silakan coba kembali.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        return false;
      }

      // Ambil ulang daftar Brand milik owner.
      final List<KiosModel>? latestKios =
          await RemoteDataSource.getListKiosAndDetail({
        'id_owner': ownerId,
      });

      if (latestKios != null) {
        resultDataKios.assignAll(latestKios);

        // Jika owner belum mempunyai Brand aktif,
        // aktifkan Brand pertama yang tersedia.
        if (activeKiosId <= 0 && latestKios.isNotEmpty) {
          KiosModel? firstKios;

          for (final item in latestKios) {
            if ((item.idKios ?? 0) > 0) {
              firstKios = item;
              break;
            }
          }

          if (firstKios != null) {
            await prefs.setInt('id_kios', firstKios.idKios!);
            await prefs.setString('kios', firstKios.kios ?? '');
            await prefs.setString('phone', firstKios.phone ?? '');

            idKios.value = firstKios.idKios!;
            selectedKios.value = firstKios.kios ?? '';
          }
        }
      }

      clearOutletController();

      return true;
    } catch (e, stackTrace) {
      debugPrint('Save outlet error: $e');
      debugPrint('Stack trace: $stackTrace');

      // Hindari memunculkan snackbar jika overlay sudah tidak tersedia.
      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan saat menyimpan Brand.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      return false;
    } finally {
      isLoadingSaveKios.value = false;
    }
  }

  // ============================================================
  // DELETE OUTLET
  // ============================================================

  Future<bool> deleteOutlet(int id) async {
    try {
      final resultUpdate = await RemoteDataSource.deleteOutlet(id);

      if (resultUpdate) {
        await fetchDataListKiosFinancial();

        return true;
      }

      return false;
    } catch (e) {
      debugPrint(
        'KiosController.deleteOutlet: $e',
      );

      return false;
    }
  }

  // ============================================================
  // UPDATE STATUS OUTLET
  // ============================================================

  Future<bool> updateStatusOutlet(
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

      if (!success) {
        return false;
      }

      final index = resultDataKios.indexWhere(
        (item) => item.idKios == id,
      );

      if (index != -1) {
        resultDataKios[index].isActive = newStatus;

        resultDataKios.refresh();
      }

      return true;
    } catch (e) {
      debugPrint(
        'KiosController.updateStatusOutlet: $e',
      );

      return false;
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    kios.dispose();
    phone.dispose();
    description.dispose();

    super.onClose();
  }
}
