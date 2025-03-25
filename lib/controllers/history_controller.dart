import 'package:financial_apps/database/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financial_apps/models/history_model.dart';
import 'package:intl/intl.dart';

class HistoryController extends GetxController {
  var resultData = <DataHistory>[].obs;
  var resultDataSingleDate = <DataHistory>[].obs;
  RxBool isLoading = false.obs;
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;
  RxInt totalBalance = 0.obs;
  RxList<dynamic> tagCategory = ["PEMASUKAN", "PENGELUARAN"].obs;
  RxList<dynamic> tagSubCategory = [].obs;
  RxList<Map<String, String>> listSubCategory = <Map<String, String>>[].obs;
  var singleDate = DateTime.now().obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  // var textSingleDate = ''.obs;
  var textStartDate = DateFormat('dd MMMM yyyy').format(DateTime.now()).obs;
  var textEndDate = DateFormat('dd MMMM yyyy').format(DateTime.now()).obs;
  RxString filterBy = 'bulan'.obs;
  late RxString monthYear;

  @override
  void onInit() {
    super.onInit();
    monthYear = "${singleDate.value.month}-${singleDate.value.year}".obs;
    getDataByFilter();
    getDataListSubCategory();
  }

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

  void getDataListSubCategory() async {
    if (tagCategory.isEmpty) {
      [
        {"value": "PEMASUKAN", "nama": "Incomes"},
        {"value": "PENGELUARAN", "nama": "Expenses"},
      ];
    }
    try {
      isLoading(true);
      final result = await RemoteDataSource.listCategories(tagCategory);
      if (result != null) {
        listSubCategory.assignAll(result.map((category) => {
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

  void getDataSingleDate(selectedDate) async {
    try {
      isLoading(true);
      final result = await RemoteDataSource.historyByDateRange(
          startDate.value, endDate.value, ["PEMASUKAN", "PENGELUARAN"], []);
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

  void getDataByFilter() async {
    try {
      isLoading(true);
      FinancialHistoryModel? result;
      if (filterBy.value == 'bulan') {
        result = await RemoteDataSource.historyByMonth(
          monthYear.value,
          tagCategory,
          tagSubCategory,
        );
      } else {
        result = await RemoteDataSource.historyByDateRange(
          startDate.value,
          endDate.value,
          tagCategory,
          tagSubCategory,
        );
      }

      if (result != null && result.data != null) {
        totalIncome.value = result.income ?? 0;
        totalExpense.value = result.expense ?? 0;
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
  /// FILTER DATE
  /// ===================================
  // bool disableDate(DateTime day) {
  //   if ((day.isBefore(DateTime.now().add(const Duration(days: 0))))) {
  //     return true;
  //   }
  //   return false;
  // }

  // chooseDate(singleOrstartOrend) async {
  //   var initialDate = DateTime.now();
  //   if (singleOrstartOrend == 'single') {
  //     initialDate = singleDate.value;
  //   } else if (singleOrstartOrend == 'start') {
  //     initialDate = startDate.value;
  //   } else {
  //     initialDate = endDate.value;
  //   }
  //   DateTime? pickedDate = await showDatePicker(
  //     context: Get.context!,
  //     initialDate: initialDate,
  //     firstDate: DateTime(DateTime.now().year - 1),
  //     lastDate: DateTime(DateTime.now().year + 1),
  //     cancelText: 'Close',
  //     confirmText: 'Confirm',
  //     errorFormatText: 'Enter valid date',
  //     errorInvalidText: 'Enter valid date range',
  //     fieldHintText: 'Month/Date/Year',
  //     selectableDayPredicate: disableDate,
  //   );
  //   if (pickedDate != null) {
  //     if (singleOrstartOrend == 'single') {
  //       if (pickedDate != singleDate.value) {
  //         singleDate.value = pickedDate;
  //         textSingleDate.value =
  //             DateFormat('dd MMMM yyyy').format(singleDate.value);
  //       }
  //     } else if (singleOrstartOrend == 'start') {
  //       if (pickedDate != startDate.value) {
  //         startDate.value = pickedDate;
  //         textStartDate.value =
  //             DateFormat('dd MMMM yyyy').format(startDate.value);
  //       }
  //     } else {
  //       if (pickedDate != endDate.value) {
  //         endDate.value = pickedDate;
  //         textEndDate.value = DateFormat('dd MMMM yyyy').format(endDate.value);
  //       }
  //     }
  //   }
  // }
}
