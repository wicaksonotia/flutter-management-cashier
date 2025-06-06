import 'package:financial_apps/database/api_request.dart';
import 'package:financial_apps/models/monitoring_outlet_model.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonitoringOutletController extends GetxController {
  var resultData = <DataTransaction>[].obs;
  RxBool isLoading = false.obs;
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;
  RxInt totalBalance = 0.obs;
  RxList<Map<String, String>> listOutlet = <Map<String, String>>[].obs;
  var monthDate = DateTime.now().obs;
  late RxString monthYear;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var filterBy = 'bulan'.obs;
  var kios = 'STMJ-STG'.obs;

  @override
  void onInit() {
    super.onInit();
    monthYear = "${monthDate.value.month}-${monthDate.value.year}".obs;
    getDataByFilter();
    getDataListOutlet();
  }

  void getDataListOutlet() async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.listOutlet();
      if (result != null) {
        listOutlet.assignAll(result.map((category) => {
              'value': category.username!,
              'nama': category.username!,
            }));
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void getDataByFilter() async {
    try {
      isLoading(true);
      MonitoringOutletModel? result;
      if (filterBy.value == 'bulan') {
        result = await RemoteDataSource.monitoringByMonth(
            monthYear.value, kios.value);
      } else {
        result = await RemoteDataSource.monitoringByDateRange(
            startDate.value, endDate.value, kios.value);
      }

      if (result != null && result.data != null) {
        totalIncome.value = result.income ?? 0;
        totalExpense.value = result.expense ?? 0;
        totalBalance.value = totalIncome.value - totalExpense.value;
        resultData.assignAll(result.data ?? []);
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  /// ===================================
  /// FILTER DATE, MONTH
  /// ===================================
  void goToNextMonth() {
    monthDate.value = DateTime(monthDate.value.year, monthDate.value.month + 1);
    monthYear.value =
        "${monthDate.value.month.toString()}-${monthDate.value.year.toString()}";
    getDataByFilter();
  }

  void goToPreviousMonth() {
    monthDate.value = DateTime(monthDate.value.year, monthDate.value.month - 1);
    monthYear.value =
        "${monthDate.value.month.toString()}-${monthDate.value.year.toString()}";
    getDataByFilter();
  }

  void showDialogDateRangePicker() async {
    var pickedDate = await showDateRangePicker(
      context: Get.context!,
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.green,
              onPrimary: Colors.white,
              outlineVariant: Colors.grey.shade200,
              // onSurfaceVariant: MyColors.green,
              outline: Colors.grey.shade300,
              secondaryContainer: Colors.green.shade50,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      startDate.value = pickedDate.start;
      endDate.value = pickedDate.end;
      getDataByFilter();
    }
  }
}
