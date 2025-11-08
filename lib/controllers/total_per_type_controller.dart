import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/chart_model.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TotalPerTypeController extends GetxController {
  var resultItem = <DataListOutletBranch>[].obs;
  var resultChartItem = <DataListChart>[].obs;
  var resultTotal = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingChart = false.obs;
  RxInt indexSlider = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getTotalBranchSaldo();
    getTotalSaldo();
    getTotalPerMonth();
  }

  void getTotalBranchSaldo() async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final result =
          await RemoteDataSource.homeTotalBranchSaldo(prefs.getInt('id_kios')!);
      if (result != null && result.data != null) {
        resultItem.assignAll(result.data!);
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void getTotalSaldo() async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.homeTotalSaldo();
      if (result != null) {
        resultTotal.value = result.data!;
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void getTotalPerMonth() async {
    try {
      isLoadingChart(true);
      final result = await RemoteDataSource.homeTotalPerMonth();
      if (result != null && result.data != null) {
        resultChartItem.assignAll(result.data!);
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoadingChart(false);
    } finally {
      isLoadingChart(false);
    }
  }
}
