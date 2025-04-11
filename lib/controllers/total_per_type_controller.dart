import 'package:financial_apps/database/api_request.dart';
import 'package:financial_apps/models/total_per_type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TotalPerTypeController extends GetxController {
  var resultTotalPerType = <DataList>[].obs;
  var resultTotal = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTotalPerType();
    getTotal();
  }

  void getTotalPerType() async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.totalPerType();
      if (result != null && result.data != null) {
        resultTotalPerType.assignAll(result.data!);
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void getTotal() async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.total();
      if (result != null) {
        resultTotal.value = result.data!;
        print(resultTotal.value);
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
