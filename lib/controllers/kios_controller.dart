import 'dart:io';

import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class KiosController extends GetxController {
  var listKios = <KiosModel>[].obs;
  var listKiosFinancial = <KiosModel>[].obs;
  var isLoading = true.obs;
  var isLoadingFinancialKios = true.obs;
  var isLoadingSaveKios = true.obs;
  var isLoadingSaveCabang = true.obs;
  var idOwner = 0.obs;
  var idKios = 0.obs;
  var namaKios = ''.obs;
  TextEditingController kios = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();
  var logo = ''.obs;
  var oldLogo = ''.obs;
  var kiosId = 0.obs;
  var headerNamaKios = ''.obs;
  Rx<XFile> pickedFile1 = XFile('').obs;
  TextEditingController kodeCabang = TextEditingController();
  TextEditingController namaCabang = TextEditingController();
  TextEditingController alamatCabang = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDataListKios();
  }

  void clearOutletController() {
    kios.clear();
    phone.clear();
    description.clear();
    logo.value = '';
    oldLogo.value = '';
    kiosId.value = 0;
    pickedFile1.value = XFile('');
    update();
  }

  void clearBranchController() {
    kodeCabang.clear();
    namaCabang.clear();
    alamatCabang.clear();
    update();
  }

  void editKios(KiosModel kiosModel) {
    kios.text = kiosModel.kios!;
    phone.text = kiosModel.phone!;
    description.text = kiosModel.keterangan!;
    logo.value = kiosModel.logo!;
    oldLogo.value = kiosModel.logo!;
    kiosId.value = kiosModel.idKios!;
    update();
  }

  void fetchDataListKios() async {
    try {
      isLoading(false);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      idOwner.value = prefs.getInt('id_owner')!;
      idKios.value = prefs.getInt('id_kios')!;
      namaKios.value = prefs.getString('kios') ?? '';
      var rawFormat = {'id_owner': idOwner.value};
      var result = await RemoteDataSource.getListKios(rawFormat);
      if (result != null) {
        listKios.assignAll(result);
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchDataListKiosFinancial() async {
    try {
      isLoadingFinancialKios(false);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var rawFormat = {'id_owner': prefs.getInt('id_owner')!};
      var result = await RemoteDataSource.getListKiosAndDetail(rawFormat);
      if (result != null) {
        listKiosFinancial.assignAll(result);
      }
    } finally {
      isLoadingFinancialKios(false);
    }
  }

  void changeBranchOutlet() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('id_kios', idKios.value);
      prefs.setString('kios', namaKios.value);
    });
  }

  Future<void> selectImage1(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      pickedFile1.value = picked;
    }
  }

  // === SIMPAN KIOS ===
  void saveOutlet() async {
    try {
      // === CEK VALIDASI DASAR ===
      if (kios.text.isEmpty || phone.text.isEmpty || description.text.isEmpty) {
        throw 'Please fill all fields';
      }

      final filePath = pickedFile1.value.path;
      final logoFromApi = logo.value;
      final oldLogoFromApi = oldLogo.value;

      dio.FormData formData;

      // === JIKA ADA FILE BARU DIPILIH ===
      if (filePath.isNotEmpty) {
        final file = File(filePath);
        final fileSizeInBytes = await file.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 2) {
          throw 'File size must be less than 2 MB';
        }

        formData = dio.FormData.fromMap({
          "id_owner": idOwner.value,
          "kios_id": kiosId.value,
          "kios": kios.text,
          "phone": phone.text,
          "description": description.text,
          "old_logo": oldLogoFromApi,
          // kirim file baru
          "logo": await dio.MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          ),
        });
      } else {
        // === JIKA TIDAK ADA FILE BARU, GUNAKAN LOGO LAMA ===
        if (logoFromApi.isEmpty) {
          throw 'Please select an image';
        }

        formData = dio.FormData.fromMap({
          "id_owner": idOwner.value,
          "kios_id": kiosId.value,
          "kios": kios.text,
          "phone": phone.text,
          "description": description.text,
          "old_logo": oldLogoFromApi,
          "logo": logoFromApi, // kirim nama file lama saja
        });
      }

      final result = await RemoteDataSource.saveOutlet(formData);
      if (result) {
        clearOutletController();
        Get.snackbar(
          'Success',
          'Kios saved successfully',
          icon: const Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.TOP,
        );

        // Delay sedikit agar snackbar tampil
        // await Future.delayed(const Duration(seconds: 2));
        // Get.back();
      } else {
        throw 'Failed to save Kios';
      }
    } catch (error) {
      Get.snackbar(
        'Notification',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingSaveKios(false);
      fetchDataListKiosFinancial();
    }
  }

  void deleteOutlet(int id) async {
    var resultUpdate = await RemoteDataSource.deleteOutlet(id);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data deleted successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListKiosFinancial();
    } else {
      Get.snackbar('Notification', 'Failed to delete data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }

  // === SIMPAN CABANG ===
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
      isLoadingSaveCabang(false);
      fetchDataListKiosFinancial();
    }
  }

  void updateStatusOutlet(int id, bool status) async {
    var resultUpdate = await RemoteDataSource.updateStatusOutlet(id, status);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data updated successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      fetchDataListKiosFinancial();
    } else {
      Get.snackbar('Notification', 'Failed to update data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }
}
