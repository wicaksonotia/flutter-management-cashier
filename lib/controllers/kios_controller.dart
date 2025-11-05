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
  var idOwner = 0.obs;
  var idKios = 0.obs;
  var namaKios = ''.obs;
  TextEditingController kios = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();
  Rx<XFile> pickedFile1 = XFile('').obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataListKios();
  }

  void clearController() {
    kios.clear();
    phone.clear();
    description.clear();
    pickedFile1.value = XFile('');
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

  void saveKios() async {
    try {
      if (pickedFile1.value.path.isEmpty) {
        throw 'Please select an image';
      }
      final file = File(pickedFile1.value.path);
      final fileSizeInBytes = await file.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB > 2) {
        throw 'File size must be less than 2 MB';
      }
      if (kios.text.isEmpty || phone.text.isEmpty || description.text.isEmpty) {
        throw 'Please fill all fields';
      }
      dio.FormData formData = dio.FormData.fromMap({
        "id_owner": idOwner.value,
        "kios": kios.text,
        "phone": phone.text,
        "description": description.text,
        "logo": await dio.MultipartFile.fromFile(pickedFile1.value.path,
            filename: pickedFile1.value.path.split('/').last),
      });
      final result = await RemoteDataSource.saveKios(formData);
      if (result) {
        clearController();
        Get.snackbar(
          'Success',
          'Kios saved successfully',
          icon: const Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.TOP,
        );

        // Delay sedikit agar snackbar sempat muncul sebelum kembali
        await Future.delayed(const Duration(seconds: 5));
        Get.back();
      }
    } catch (error) {
      Get.snackbar('Notification', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    } finally {
      isLoadingSaveKios(false);
      fetchDataListKiosFinancial();
    }
  }
}
