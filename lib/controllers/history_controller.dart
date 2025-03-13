import 'package:financial_apps/database/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_apps/models/history_model.dart';

class HistoryController extends GetxController {
  var resultData = <DataHistory>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData('PEMASUKAN');
  }

  void getData(kategori) async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.history(kategori);
      if (result != null && result.data != null) {
        resultData.assignAll(result.data!);
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
