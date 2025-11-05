import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashier_management/models/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryController extends GetxController {
  var resultData = <DataHistory>[].obs;
  RxBool isLoadingHistory = false.obs;
  var resultDataSingleDate = <DataHistory>[].obs;
  RxBool isLoadingSingleDate = false.obs;
  RxBool isLoadingCategoryPemasukan = false.obs;
  RxBool isLoadingCategoryPengeluaran = false.obs;
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;
  RxInt totalBalance = 0.obs;
  var tagCategory = [].obs;
  var tagCabangKios = [].obs;
  RxList<Map<String, dynamic>> listCategoryPemasukan =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listCategoryPengeluaran =
      <Map<String, dynamic>>[].obs;
  var singleDate = DateTime.now().obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var selectedDate = DateTime.now().obs;
  RxString filterBy = 'bulan'.obs;
  late RxString monthYear;
  var idKios = 0.obs;
  var namaKios = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    idKios.value = prefs.getInt('id_kios')!;
    namaKios.value = prefs.getString('kios')!;
    monthYear = "${singleDate.value.month}-${singleDate.value.year}".obs;
    getHistoriesBySingleDate();
  }

  void changeBranchOutlet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idKios.value = prefs.getInt('id_kios')!;
    namaKios.value = prefs.getString('kios')!;
    getHistoriesBySingleDate();
    getHistoriesByFilter();
    getDataListCategoryPemasukan();
    getDataListCategoryPengeluaran();
  }

  void getDataListCategoryPemasukan() async {
    try {
      isLoadingCategoryPemasukan(true);
      var rawFormat = {'id_kios': idKios.value};
      final result = await RemoteDataSource.getListCabangKios(rawFormat);
      if (result != null) {
        listCategoryPemasukan.assignAll(result.map((category) => {
              'value': category.id,
              'nama': category.cabang!,
            }));
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoadingCategoryPemasukan(false);
    } finally {
      isLoadingCategoryPemasukan(false);
    }
  }

  void getDataListCategoryPengeluaran() async {
    try {
      isLoadingCategoryPengeluaran(true);
      final result = await RemoteDataSource.listCategories(['PENGELUARAN'], '');
      if (result != null) {
        listCategoryPengeluaran.assignAll(result.map((category) => {
              'value': category.id,
              'nama': category.categoryName!,
            }));
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoadingCategoryPengeluaran(false);
    } finally {
      isLoadingCategoryPengeluaran(false);
    }
  }

  void getHistoriesBySingleDate() async {
    try {
      isLoadingSingleDate(true);
      var rawFormat = {
        'startDate': selectedDate.value.toString(),
        'endDate': selectedDate.value.toString(),
        'monthYear': monthYear.value,
        'filter_by_date_or_month': 'tanggal',
        'id_kios': idKios.value,
        'kategori': [],
        'cabang_kios': []
      };
      final result = await RemoteDataSource.histories(rawFormat);
      if (result != null && result.data != null) {
        resultDataSingleDate.assignAll(result.data!);
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoadingSingleDate(false);
    } finally {
      isLoadingSingleDate(false);
    }
  }

  void getHistoriesByFilter() async {
    try {
      isLoadingHistory(true);
      var rawFormat = {
        'startDate': startDate.value.toString(),
        'endDate': endDate.value.toString(),
        'monthYear': monthYear.value,
        'filter_by_date_or_month': filterBy.value,
        'id_kios': idKios.value,
        'kategori': tagCategory,
        'cabang_kios': tagCabangKios
      };
      final result = await RemoteDataSource.histories(rawFormat);
      if (result != null && result.data != null) {
        resultData.assignAll(result.data!);
        totalIncome.value = resultData
            .where((history) => history.transactionType == 'PEMASUKAN')
            .fold(0, (sum, history) => sum + (history.amount ?? 0));
        totalExpense.value = resultData
            .where((history) => history.transactionType == 'PENGELUARAN')
            .fold(0, (sum, history) => sum + (history.amount ?? 0));
        totalBalance.value = totalIncome.value - totalExpense.value;
      }
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
      isLoadingHistory(false);
    } finally {
      isLoadingHistory(false);
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
    getHistoriesByFilter();
  }

  void goToPreviousMonth() {
    singleDate.value =
        DateTime(singleDate.value.year, singleDate.value.month - 1);
    monthYear.value =
        "${singleDate.value.month.toString()}-${singleDate.value.year.toString()}";
    getHistoriesByFilter();
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
      getHistoriesByFilter();
    }
  }

  void delete(int id) async {
    var resultUpdate = await RemoteDataSource.deleteHistory(id);
    if (resultUpdate) {
      Get.snackbar('Notification', 'Data deleted successfully',
          icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
      getHistoriesByFilter();
    } else {
      Get.snackbar('Notification', 'Failed to delete data',
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    }
  }
}
