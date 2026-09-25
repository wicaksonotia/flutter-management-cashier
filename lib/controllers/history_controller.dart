import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/history_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryController extends GetxController {
  // ============================================================
  // HISTORY
  // ============================================================

  final RxList<DataHistory> resultData = <DataHistory>[].obs;

  final RxBool isLoadingHistory = false.obs;

  final RxList<DataHistory> resultDataSingleDate = <DataHistory>[].obs;

  final RxBool isLoadingSingleDate = false.obs;

  // ============================================================
  // CATEGORY LOADING
  // ============================================================

  final RxBool isLoadingCategoryPemasukan = false.obs;

  final RxBool isLoadingCategoryPengeluaran = false.obs;

  // ============================================================
  // SUMMARY
  // ============================================================

  final RxInt totalIncome = 0.obs;

  final RxInt totalExpense = 0.obs;

  final RxInt totalBalance = 0.obs;

  // ============================================================
  // APPLIED FILTER
  //
  // Filter yang benar-benar dikirim ke API.
  // ============================================================

  final RxList<dynamic> tagCategory = <dynamic>[].obs;

  final RxList<dynamic> tagCabangKios = <dynamic>[].obs;

  // ============================================================
  // TEMPORARY FILTER
  //
  // Digunakan ketika bottom sheet filter sedang dibuka.
  // Belum mempengaruhi data sampai user menekan Terapkan.
  // ============================================================

  final RxList<dynamic> tempTagCategory = <dynamic>[].obs;

  final RxList<dynamic> tempTagCabangKios = <dynamic>[].obs;

  // ============================================================
  // MASTER DATA FILTER
  // ============================================================

  final RxList<Map<String, dynamic>> listCategoryPemasukan =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> listCategoryPengeluaran =
      <Map<String, dynamic>>[].obs;

  // ============================================================
  // DATE
  // ============================================================

  final Rx<DateTime> singleDate = DateTime.now().obs;

  final Rx<DateTime> startDate = DateTime.now().obs;

  final Rx<DateTime> endDate = DateTime.now().obs;

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final RxString filterBy = 'bulan'.obs;

  late RxString monthYear;

  // ============================================================
  // ACTIVE OUTLET / BRAND
  // ============================================================

  final RxInt idKios = 0.obs;

  final RxString namaKios = ''.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() async {
    super.onInit();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    idKios.value = prefs.getInt('id_kios') ?? 0;

    namaKios.value = prefs.getString('kios') ?? '';

    monthYear = '${singleDate.value.month}-${singleDate.value.year}'.obs;

    getHistoriesBySingleDate();
  }

  // ============================================================
  // OUTLET
  // ============================================================

  Future<void> changeOutlet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    idKios.value = prefs.getInt('id_kios') ?? 0;

    namaKios.value = prefs.getString('kios') ?? '';

    // Ketika pindah brand/outlet utama,
    // filter cabang sebelumnya tidak lagi relevan.
    resetTransactionFilter();

    await getHistoriesBySingleDate();
    await getHistoriesByFilter();

    await getDataListCategoryPemasukan();
    await getDataListCategoryPengeluaran();
  }

  // ============================================================
  // CATEGORY PEMASUKAN / CABANG OUTLET
  // ============================================================

  Future<void> getDataListCategoryPemasukan() async {
    try {
      isLoadingCategoryPemasukan(true);

      final rawFormat = {
        'id_kios': idKios.value,
      };

      final result = await RemoteDataSource.getListCabangKios(rawFormat);

      if (result != null) {
        listCategoryPemasukan.assignAll(
          result.map(
            (category) => {
              'value': category.id,
              'nama': category.cabang ?? '-',
            },
          ),
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingCategoryPemasukan(false);
    }
  }

  // ============================================================
  // CATEGORY PENGELUARAN
  // ============================================================

  Future<void> getDataListCategoryPengeluaran() async {
    try {
      isLoadingCategoryPengeluaran(true);

      final rawFormat = {
        'kategori': ['PENGELUARAN'],
        'textSearch': '',
        'page': 1,
        'limit': 999999,
        'sort': 'ASC',
      };

      final result = await RemoteDataSource.listCategories(rawFormat);

      if (result != null && result.data != null) {
        listCategoryPengeluaran.assignAll(
          result.data!
              .map(
                (e) => {
                  'value': e.id,
                  'nama': e.categoryName ?? '-',
                },
              )
              .toList(),
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingCategoryPengeluaran(false);
    }
  }

  // ============================================================
  // HISTORY - SINGLE DATE
  // ============================================================

  Future<void> getHistoriesBySingleDate() async {
    try {
      isLoadingSingleDate(true);

      final rawFormat = {
        'startDate': selectedDate.value.toString(),
        'endDate': selectedDate.value.toString(),
        'monthYear': monthYear.value,
        'filter_by_date_or_month': 'tanggal',
        'id_kios': idKios.value,
        'kategori': [],
        'cabang_kios': [],
      };

      final result = await RemoteDataSource.histories(rawFormat);

      if (result != null && result.data != null) {
        resultDataSingleDate.assignAll(result.data!);
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingSingleDate(false);
    }
  }

  // ============================================================
  // HISTORY - FILTER
  // ============================================================

  Future<void> getHistoriesByFilter() async {
    try {
      isLoadingHistory(true);

      final rawFormat = {
        'startDate': startDate.value.toString(),
        'endDate': endDate.value.toString(),
        'monthYear': monthYear.value,
        'filter_by_date_or_month': filterBy.value,
        'id_kios': idKios.value,

        // FILTER YANG SUDAH DITERAPKAN
        'kategori': tagCategory.toList(),
        'cabang_kios': tagCabangKios.toList(),
      };

      final result = await RemoteDataSource.histories(rawFormat);

      if (result != null && result.data != null) {
        resultData.assignAll(result.data!);

        _calculateSummary();
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingHistory(false);
    }
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  void _calculateSummary() {
    totalIncome.value = resultData
        .where(
          (history) => history.transactionType == 'PEMASUKAN',
        )
        .fold(
          0,
          (sum, history) => sum + (history.amount ?? 0),
        );

    totalExpense.value = resultData
        .where(
          (history) => history.transactionType == 'PENGELUARAN',
        )
        .fold(
          0,
          (sum, history) => sum + (history.amount ?? 0),
        );

    totalBalance.value = totalIncome.value - totalExpense.value;
  }

  // ============================================================
  // TRANSACTION FILTER
  // ============================================================

  /// Membuka filter dengan kondisi filter yang
  /// sedang aktif.
  void prepareTransactionFilter() {
    tempTagCabangKios.assignAll(
      tagCabangKios.toList(),
    );

    tempTagCategory.assignAll(
      tagCategory.toList(),
    );
  }

  /// Terapkan filter sementara menjadi filter aktif.
  Future<void> applyTransactionFilter({
    required bool isExpense,
  }) async {
    tagCabangKios.assignAll(
      tempTagCabangKios.toList(),
    );

    // Kategori hanya berlaku untuk pengeluaran.
    if (isExpense) {
      tagCategory.assignAll(
        tempTagCategory.toList(),
      );
    } else {
      tagCategory.clear();
      tempTagCategory.clear();
    }

    await getHistoriesByFilter();
  }

  /// Reset pilihan sementara.
  void resetTemporaryTransactionFilter() {
    tempTagCabangKios.clear();
    tempTagCategory.clear();
  }

  /// Reset filter yang sudah diterapkan.
  Future<void> resetTransactionFilter() async {
    tagCabangKios.clear();
    tagCategory.clear();

    tempTagCabangKios.clear();
    tempTagCategory.clear();

    await getHistoriesByFilter();
  }

  // ============================================================
  // FILTER HELPER
  // ============================================================

  bool isOutletSelected(dynamic value) {
    return tempTagCabangKios.contains(value);
  }

  bool isCategorySelected(dynamic value) {
    return tempTagCategory.contains(value);
  }

  void toggleOutlet(dynamic value) {
    if (tempTagCabangKios.contains(value)) {
      tempTagCabangKios.remove(value);
    } else {
      tempTagCabangKios.add(value);
    }
  }

  void toggleCategory(dynamic value) {
    if (tempTagCategory.contains(value)) {
      tempTagCategory.remove(value);
    } else {
      tempTagCategory.add(value);
    }
  }

  void selectAllOutlet() {
    tempTagCabangKios.clear();
  }

  void selectAllCategory() {
    tempTagCategory.clear();
  }

  // ============================================================
  // FILTER DATE / MONTH
  // ============================================================

  void goToNextMonth() {
    singleDate.value = DateTime(
      singleDate.value.year,
      singleDate.value.month + 1,
    );

    monthYear.value = '${singleDate.value.month}-${singleDate.value.year}';

    getHistoriesByFilter();
  }

  void goToPreviousMonth() {
    singleDate.value = DateTime(
      singleDate.value.year,
      singleDate.value.month - 1,
    );

    monthYear.value = '${singleDate.value.month}-${singleDate.value.year}';

    getHistoriesByFilter();
  }

  Future<void> showDialogDateRangePicker() async {
    final pickedDate = await showDateRangePicker(
      context: Get.context!,
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ),
      lastDate: DateTime.now(),
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              outlineVariant: Colors.grey.shade200,
              outline: Colors.grey.shade300,
              secondaryContainer: Colors.green.shade50,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) {
      return;
    }

    startDate.value = pickedDate.start;
    endDate.value = pickedDate.end;

    filterBy.value = 'tanggal';

    await getHistoriesByFilter();
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> delete(int id) async {
    final resultUpdate = await RemoteDataSource.deleteHistory(id);

    if (resultUpdate) {
      Get.snackbar(
        'Notification',
        'Data deleted successfully',
        icon: const Icon(Icons.check),
        snackPosition: SnackPosition.TOP,
      );

      await getHistoriesByFilter();
    } else {
      Get.snackbar(
        'Notification',
        'Failed to delete data',
        icon: const Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
