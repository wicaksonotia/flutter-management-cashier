import 'package:financial_apps/database/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_apps/models/history_model.dart';

class HistoryController extends GetxController {
  var resultData = <DataHistory>[].obs;
  RxBool isLoading = false.obs;
  var kategori = 'ALL'.obs;
  var singleDate = DateTime.now().obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var checkSingleDate = true.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
    getDataByDate();
  }

  void getData() async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.history(kategori.value);
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

  void getDataByDate() async {
    kategori.value = 'ALL';
    try {
      isLoading(true);
      final result = await RemoteDataSource.historyByDate(
        startDate.value,
        endDate.value,
        singleDate.value,
        checkSingleDate.value,
      );
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
