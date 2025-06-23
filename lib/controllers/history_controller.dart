import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_management/models/history_model.dart';

class HistoryController extends GetxController {
  var resultData = <DataHistory>[].obs;
  var resultDataSingleDate = <DataHistory>[].obs;
  RxBool isLoading = false.obs;
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;
  RxInt totalBalance = 0.obs;
  RxList<dynamic> tagCategory = [].obs;
  RxList<dynamic> temporaryTagCategory = [].obs;
  RxList<dynamic> tagSubCategory = [].obs;
  RxList<dynamic> temporaryTagSubCategory = [].obs;
  RxList<Map<String, String>> listCategory = <Map<String, String>>[].obs;
  var singleDate = DateTime.now().obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var selectedDate = DateTime.now().obs;
  RxString filterBy = 'bulan'.obs;
  late RxString monthYear;

  @override
  void onInit() {
    super.onInit();
    monthYear = "${singleDate.value.month}-${singleDate.value.year}".obs;
    // getDataByFilter();
    // getDataListCategory();
    getDataSingleDate();
  }

  void getDataListCategory() async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.listCategories(['PEMASUKAN'], '');
      if (result != null) {
        listCategory.assignAll(result.map((category) => {
              'value': category.id.toString(),
              'nama': category.categoryName!,
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

  void getDataSingleDate() async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.homeHistoryByDate(
          selectedDate.value, selectedDate.value, []);
      if (result != null && result.data != null) {
        resultDataSingleDate.assignAll(result.data!);
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void setDataByFilter() {
    // tagCategory.assignAll(temporaryTagCategory);
    tagSubCategory.assignAll(temporaryTagSubCategory);
    getDataByFilter();
  }

  void getDataByFilter() async {
    try {
      isLoading(true);

      FinancialHistoryModel? result;
      if (filterBy.value == 'bulan') {
        result = await RemoteDataSource.historyByMonth(
          monthYear.value,
          // tagCategory,
          tagSubCategory,
        );
      } else {
        result = await RemoteDataSource.historyByDateRange(
          startDate.value,
          endDate.value,
          // tagCategory,
          tagSubCategory,
        );
      }

      if (result != null && result.data != null) {
        totalIncome.value = 0;
        totalExpense.value = 0;
        totalBalance.value = totalIncome.value - totalExpense.value;
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

  /// ===================================
  /// FILTER DATE, MONTH
  /// ===================================
  void goToNextMonth() {
    singleDate.value =
        DateTime(singleDate.value.year, singleDate.value.month + 1);
    monthYear.value =
        "${singleDate.value.month.toString()}-${singleDate.value.year.toString()}";
    getDataByFilter();
  }

  void goToPreviousMonth() {
    singleDate.value =
        DateTime(singleDate.value.year, singleDate.value.month - 1);
    monthYear.value =
        "${singleDate.value.month.toString()}-${singleDate.value.year.toString()}";
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
              primary: MyColors.primary,
              onPrimary: Colors.white,
              outlineVariant: Colors.grey.shade200,
              // onSurfaceVariant: MyColors.primary,
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

  void delete(int id) async {
    var resultUpdate = await RemoteDataSource.deleteHistory(id);
    if (resultUpdate) {
      Get.back();
      Get.snackbar('Notification', 'Data deleted successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      getDataByFilter();
    } else {
      Get.snackbar('Notification', 'Failed to delete data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }
}
