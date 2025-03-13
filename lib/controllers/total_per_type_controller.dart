import 'package:financial_apps/database/api_request.dart';
import 'package:financial_apps/models/total_per_type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TotalPerTypeController extends GetxController {
  var resultData = <DataList>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void getData() async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.totalPerType();
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
