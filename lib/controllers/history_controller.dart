import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/history_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryController extends GetxController {
  // ============================================================
  // HISTORY - FILTER
  // ============================================================

  final RxList<DataHistory> resultData = <DataHistory>[].obs;

  final RxBool isLoadingHistory = false.obs;

  // ============================================================
  // HISTORY - SINGLE DATE / TODAY
  // ============================================================

  final RxList<DataHistory> resultDataSingleDate = <DataHistory>[].obs;

  final RxBool isLoadingSingleDate = false.obs;

  // ============================================================
  // HISTORY - YESTERDAY
  // ============================================================

  final RxList<DataHistory> resultDataYesterday = <DataHistory>[].obs;

  final RxBool isLoadingYesterday = false.obs;

  // ============================================================
  // CATEGORY LOADING
  // ============================================================

  final RxBool isLoadingCategoryPemasukan = false.obs;

  final RxBool isLoadingCategoryPengeluaran = false.obs;

  // ============================================================
  // SUMMARY - FILTER
  // ============================================================

  final RxInt totalIncome = 0.obs;

  final RxInt totalExpense = 0.obs;

  final RxInt totalBalance = 0.obs;

  // ============================================================
  // HOME SUMMARY - TODAY
  // ============================================================

  int get todayTransactionCount {
    return _validTransactions(
      resultDataSingleDate,
    ).length;
  }

  int get todayIncome {
    return _calculateIncome(
      resultDataSingleDate,
    );
  }

  int get todayExpense {
    return _calculateExpense(
      resultDataSingleDate,
    );
  }

  int get todayBalance {
    return todayIncome - todayExpense;
  }

  int get todayAverageTransaction {
    final count = todayTransactionCount;

    if (count <= 0) {
      return 0;
    }

    final total = _calculateTransactionValue(
      resultDataSingleDate,
    );

    return (total / count).round();
  }

  // ============================================================
  // HOME SUMMARY - YESTERDAY
  // ============================================================

  int get yesterdayTransactionCount {
    return _validTransactions(
      resultDataYesterday,
    ).length;
  }

  int get yesterdayIncome {
    return _calculateIncome(
      resultDataYesterday,
    );
  }

  int get yesterdayExpense {
    return _calculateExpense(
      resultDataYesterday,
    );
  }

  int get yesterdayBalance {
    return yesterdayIncome - yesterdayExpense;
  }

  // ============================================================
  // HOME GROWTH
  // ============================================================

  double get incomeGrowth {
    return _calculateGrowth(
      todayIncome,
      yesterdayIncome,
    );
  }

  double get expenseGrowth {
    return _calculateGrowth(
      todayExpense,
      yesterdayExpense,
    );
  }

  double get balanceGrowth {
    return _calculateGrowth(
      todayBalance,
      yesterdayBalance,
    );
  }

  // ============================================================
  // HOME - RECENT TRANSACTIONS
  // ============================================================

  List<DataHistory> get recentTransactions {
    final data = _validTransactions(
      resultDataSingleDate,
    );

    final sorted = List<DataHistory>.from(
      data,
    );

    sorted.sort(
      (a, b) {
        final dateA = _parseDateTime(
          a.transactionDate,
        );

        final dateB = _parseDateTime(
          b.transactionDate,
        );

        return dateB.compareTo(dateA);
      },
    );

    return sorted.take(5).toList();
  }

  // ============================================================
  // HOME - TODAY INCOME TRANSACTIONS
  // ============================================================

  List<DataHistory> get todayIncomeTransactions {
    return _validTransactions(
      resultDataSingleDate,
    )
        .where(
          (item) => (item.transactionType ?? '').toUpperCase() == 'PEMASUKAN',
        )
        .toList();
  }

  // ============================================================
  // HOME - TODAY EXPENSE TRANSACTIONS
  // ============================================================

  List<DataHistory> get todayExpenseTransactions {
    return _validTransactions(
      resultDataSingleDate,
    )
        .where(
          (item) => (item.transactionType ?? '').toUpperCase() == 'PENGELUARAN',
        )
        .toList();
  }

  // ============================================================
  // APPLIED FILTER
  // ============================================================

  final RxList<dynamic> tagCategory = <dynamic>[].obs;

  final RxList<dynamic> tagCabangKios = <dynamic>[].obs;

  // ============================================================
  // TEMPORARY FILTER
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

  /// Source of truth untuk periode BULAN.
  final Rx<DateTime> singleDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;

  /// Source of truth untuk mode RENTANG TANGGAL.
  final Rx<DateTime> startDate = DateTime.now().obs;

  final Rx<DateTime> endDate = DateTime.now().obs;

  /// Source of truth untuk data HOME hari ini.
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  /// Mode filter aktif.
  ///
  /// bulan   = berdasarkan bulan
  /// tanggal = berdasarkan rentang tanggal
  final RxString filterBy = 'bulan'.obs;

  /// Format yang dikirim ke API:
  ///
  /// 10-2026
  final RxString monthYear =
      '${DateTime.now().month}-${DateTime.now().year}'.obs;

  // ============================================================
  // ACTIVE BRAND
  // ============================================================

  final RxInt idKios = 0.obs;

  final RxString namaKios = ''.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() async {
    super.onInit();

    final prefs = await SharedPreferences.getInstance();

    idKios.value = prefs.getInt('id_kios') ?? 0;

    namaKios.value = prefs.getString('kios') ?? '';

    _syncMonthYear();

    await Future.wait([
      getHistoriesBySingleDate(),
      getHistoriesYesterday(),
    ]);
  }

  // ============================================================
  // MONTH YEAR
  // ============================================================

  void _syncMonthYear() {
    monthYear.value = '${singleDate.value.month}-${singleDate.value.year}';
  }

  Future<void> selectMonth(DateTime date) async {
    final selectedMonth = DateTime(
      date.year,
      date.month,
      1,
    );

    singleDate.value = selectedMonth;

    monthYear.value = '${selectedMonth.month}-${selectedMonth.year}';

    filterBy.value = 'bulan';

    // Sekalian sinkronkan range tanggal.
    // Jadi kalau nanti pindah dari Bulan -> Rentang Tanggal,
    // range awalnya mengikuti bulan yang dipilih.
    final firstDay = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      1,
    );

    final lastDay = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
    );

    final today = DateTime.now();

    startDate.value = firstDay;

    endDate.value = lastDay.isAfter(today)
        ? DateTime(
            today.year,
            today.month,
            today.day,
          )
        : lastDay;

    await getHistoriesByFilter();
  }

  // ============================================================
  // CHANGE MONTH
  // ============================================================

  Future<void> changeMonth({
    required int year,
    required int month,
  }) async {
    singleDate.value = DateTime(
      year,
      month,
      1,
    );

    _syncMonthYear();

    filterBy.value = 'bulan';

    await getHistoriesByFilter();
  }

  // ============================================================
  // NEXT MONTH
  // ============================================================

  Future<void> goToNextMonth() async {
    final current = singleDate.value;

    final nextMonth = DateTime(
      current.year,
      current.month + 1,
      1,
    );

    final now = DateTime.now();

    // Jangan boleh memilih bulan masa depan.
    if (nextMonth.year > now.year ||
        (nextMonth.year == now.year && nextMonth.month > now.month)) {
      return;
    }

    await selectMonth(nextMonth);
  }

  // ============================================================
  // PREVIOUS MONTH
  // ============================================================

  Future<void> goToPreviousMonth() async {
    final current = singleDate.value;

    final previousMonth = DateTime(
      current.year,
      current.month - 1,
      1,
    );

    await selectMonth(previousMonth);
  }

  // ============================================================
  // REFRESH HOME DATA
  // ============================================================

  Future<void> refreshHomeData() async {
    await Future.wait([
      getHistoriesBySingleDate(),
      getHistoriesYesterday(),
    ]);
  }

  // ============================================================
  // CHANGE OUTLET
  // ============================================================

  Future<void> changeOutlet() async {
    final prefs = await SharedPreferences.getInstance();

    idKios.value = prefs.getInt('id_kios') ?? 0;

    namaKios.value = prefs.getString('kios') ?? '';

    resetTransactionFilter();

    await Future.wait([
      getHistoriesBySingleDate(),
      getHistoriesYesterday(),
      getHistoriesByFilter(),
      getDataListCategoryPemasukan(),
      getDataListCategoryPengeluaran(),
    ]);
  }

  // ============================================================
  // CATEGORY PEMASUKAN
  // ============================================================

  Future<void> getDataListCategoryPemasukan() async {
    try {
      isLoadingCategoryPemasukan(true);

      final rawFormat = {
        'status': 'TRUE',
        'id_kios': idKios.value,
        'kategori': [
          'PEMASUKAN',
        ],
        'textSearch': '',
        'page': 1,
        'limit': 999999,
        'sort': 'ASC',
      };

      final result = await RemoteDataSource.listCategories(
        rawFormat,
      );

      if (result?.data != null) {
        listCategoryPemasukan.assignAll(
          result!.data!
              .map(
                (e) => {
                  'value': e.id,
                  'nama': e.categoryName,
                },
              )
              .toList(),
        );
      } else {
        listCategoryPemasukan.clear();
      }
    } catch (error, stackTrace) {
      debugPrint(
        'getDataListCategoryPemasukan ERROR: $error',
      );

      debugPrint(
        '$stackTrace',
      );

      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(
          Icons.error,
        ),
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
        'status': 'TRUE',
        'id_kios': idKios.value,
        'kategori': [
          'PENGELUARAN',
        ],
        'textSearch': '',
        'page': 1,
        'limit': 999999,
        'sort': 'ASC',
      };

      final result = await RemoteDataSource.listCategories(
        rawFormat,
      );

      if (result?.data != null) {
        listCategoryPengeluaran.assignAll(
          result!.data!
              .map(
                (e) => {
                  'value': e.id,
                  'nama': e.categoryName,
                },
              )
              .toList(),
        );
      } else {
        listCategoryPengeluaran.clear();
      }
    } catch (error, stackTrace) {
      debugPrint(
        'getDataListCategoryPengeluaran ERROR: $error',
      );

      debugPrint(
        '$stackTrace',
      );

      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(
          Icons.error,
        ),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingCategoryPengeluaran(false);
    }
  }

  // ============================================================
  // HISTORY - TODAY / SELECTED DATE
  // ============================================================

  Future<void> getHistoriesBySingleDate() async {
    try {
      isLoadingSingleDate(true);

      final rawFormat = {
        'startDate': selectedDate.value.toString(),
        'endDate': selectedDate.value.toString(),
        'monthYear': '${selectedDate.value.month}-${selectedDate.value.year}',
        'filter_by_date_or_month': 'tanggal',
        'id_kios': idKios.value,
        'kategori': [],
        'cabang_kios': [],
      };

      final result = await RemoteDataSource.histories(
        rawFormat,
      );

      if (result != null && result.data != null) {
        resultDataSingleDate.assignAll(
          result.data!,
        );
      } else {
        resultDataSingleDate.clear();
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(
          Icons.error,
        ),
        snackPosition: SnackPosition.TOP,
      );

      resultDataSingleDate.clear();
    } finally {
      isLoadingSingleDate(false);
    }
  }

  // ============================================================
  // HISTORY - YESTERDAY
  // ============================================================

  Future<void> getHistoriesYesterday() async {
    try {
      isLoadingYesterday(true);

      final yesterday = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day - 1,
      );

      final rawFormat = {
        'startDate': yesterday.toString(),
        'endDate': yesterday.toString(),
        'monthYear': '${yesterday.month}-${yesterday.year}',
        'filter_by_date_or_month': 'tanggal',
        'id_kios': idKios.value,
        'kategori': [],
        'cabang_kios': [],
      };

      final result = await RemoteDataSource.histories(
        rawFormat,
      );

      if (result != null && result.data != null) {
        resultDataYesterday.assignAll(
          result.data!,
        );
      } else {
        resultDataYesterday.clear();
      }
    } catch (error) {
      debugPrint(
        'getHistoriesYesterday ERROR: $error',
      );

      resultDataYesterday.clear();
    } finally {
      isLoadingYesterday(false);
    }
  }

  // ============================================================
  // HISTORY - FILTER
  // ============================================================

  Future<void> getHistoriesByFilter() async {
    try {
      isLoadingHistory(true);

      final Map<String, dynamic> rawFormat;

      if (filterBy.value == 'tanggal') {
        // ========================================================
        // RENTANG TANGGAL
        // ========================================================

        rawFormat = {
          'startDate': startDate.value.toString(),
          'endDate': endDate.value.toString(),
          'monthYear': '${startDate.value.month}-${startDate.value.year}',
          'filter_by_date_or_month': 'tanggal',
          'id_kios': idKios.value,
          'kategori': tagCategory.toList(),
          'cabang_kios': tagCabangKios.toList(),
        };
      } else {
        // ========================================================
        // BULAN
        // ========================================================

        _syncMonthYear();

        rawFormat = {
          'startDate': singleDate.value.toString(),
          'endDate': singleDate.value.toString(),
          'monthYear': monthYear.value,
          'filter_by_date_or_month': 'bulan',
          'id_kios': idKios.value,
          'kategori': tagCategory.toList(),
          'cabang_kios': tagCabangKios.toList(),
        };
      }

      debugPrint(
        '>>> HISTORY FILTER: $rawFormat',
      );

      final result = await RemoteDataSource.histories(
        rawFormat,
      );

      if (result != null && result.data != null) {
        resultData.assignAll(
          result.data!,
        );

        _calculateSummary();
      } else {
        resultData.clear();

        totalIncome.value = 0;
        totalExpense.value = 0;
        totalBalance.value = 0;
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        icon: const Icon(
          Icons.error,
        ),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoadingHistory(false);
    }
  }

  // ============================================================
  // SUMMARY - FILTER
  // ============================================================

  void _calculateSummary() {
    totalIncome.value = _calculateIncome(
      resultData,
    );

    totalExpense.value = _calculateExpense(
      resultData,
    );

    totalBalance.value = totalIncome.value - totalExpense.value;
  }

  // ============================================================
  // TRANSACTION FILTER
  // ============================================================

  void prepareTransactionFilter() {
    tempTagCabangKios.assignAll(
      tagCabangKios.toList(),
    );

    tempTagCategory.assignAll(
      tagCategory.toList(),
    );
  }

  Future<void> applyTransactionFilter({
    required int selectedType,
  }) async {
    tagCabangKios.assignAll(
      tempTagCabangKios.toList(),
    );

    tagCategory.assignAll(
      tempTagCategory.toList(),
    );

    await getHistoriesByFilter();
  }

  void resetTemporaryTransactionFilter() {
    tempTagCabangKios.clear();
    tempTagCategory.clear();
  }

  Future<void> resetTransactionFilter() async {
    tagCabangKios.clear();
    tagCategory.clear();

    tempTagCabangKios.clear();
    tempTagCategory.clear();

    await getHistoriesByFilter();
  }

  bool isOutletSelected(
    dynamic value,
  ) {
    return tempTagCabangKios.contains(
      value,
    );
  }

  bool isCategorySelected(
    dynamic value,
  ) {
    return tempTagCategory.contains(
      value,
    );
  }

  void toggleOutlet(
    dynamic value,
  ) {
    if (tempTagCabangKios.contains(
      value,
    )) {
      tempTagCabangKios.remove(
        value,
      );
    } else {
      tempTagCabangKios.add(
        value,
      );
    }
  }

  void toggleCategory(
    dynamic value,
  ) {
    if (tempTagCategory.contains(
      value,
    )) {
      tempTagCategory.remove(
        value,
      );
    } else {
      tempTagCategory.add(
        value,
      );
    }
  }

  void selectAllOutlet() {
    tempTagCabangKios.clear();
  }

  void selectAllCategory() {
    tempTagCategory.clear();
  }

  // ============================================================
  // DATE RANGE PICKER
  // ============================================================

  Future<void> showDialogDateRangePicker() async {
    final pickedDate = await showDateRangePicker(
      context: Get.context!,
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
      firstDate: DateTime.now().subtract(
        const Duration(
          days: 365,
        ),
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

  Future<void> delete(
    int id,
  ) async {
    final resultUpdate = await RemoteDataSource.deleteHistory(
      id,
    );

    if (resultUpdate) {
      Get.snackbar(
        'Notification',
        'Data deleted successfully',
        icon: const Icon(
          Icons.check,
        ),
        snackPosition: SnackPosition.TOP,
      );

      await Future.wait([
        getHistoriesByFilter(),
        getHistoriesBySingleDate(),
        getHistoriesYesterday(),
      ]);
    } else {
      Get.snackbar(
        'Notification',
        'Failed to delete data',
        icon: const Icon(
          Icons.error,
        ),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // ============================================================
  // PRIVATE HELPER
  // ============================================================

  List<DataHistory> _validTransactions(
    RxList<DataHistory> source,
  ) {
    return source
        .where(
          (item) => item.deleteStatus != true,
        )
        .toList();
  }

  int _calculateIncome(
    RxList<DataHistory> source,
  ) {
    return _validTransactions(source)
        .where(
          (history) =>
              (history.transactionType ?? '').toUpperCase() == 'PEMASUKAN',
        )
        .fold(
          0,
          (
            sum,
            history,
          ) =>
              sum + (history.amount ?? 0),
        );
  }

  int _calculateExpense(
    RxList<DataHistory> source,
  ) {
    return _validTransactions(source)
        .where(
          (history) =>
              (history.transactionType ?? '').toUpperCase() == 'PENGELUARAN',
        )
        .fold(
          0,
          (
            sum,
            history,
          ) =>
              sum + (history.amount ?? 0),
        );
  }

  int _calculateTransactionValue(
    RxList<DataHistory> source,
  ) {
    return _validTransactions(source).fold(
      0,
      (
        sum,
        history,
      ) =>
          sum + (history.amount ?? 0),
    );
  }

  double _calculateGrowth(
    int current,
    int previous,
  ) {
    if (previous == 0) {
      if (current > 0) {
        return 100;
      }

      return 0;
    }

    return ((current - previous) / previous) * 100;
  }

  DateTime _parseDateTime(
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(
        0,
      );
    }

    return DateTime.tryParse(
          value,
        ) ??
        DateTime.fromMillisecondsSinceEpoch(
          0,
        );
  }

  String formatRupiah(
    int value,
  ) {
    if (value.abs() >= 1000000) {
      final juta = value / 1000000;

      if (juta == juta.roundToDouble()) {
        return 'Rp ${juta.toInt()} jt';
      }

      return 'Rp ${juta.toStringAsFixed(1)} jt';
    }

    if (value.abs() >= 1000) {
      final ribu = value / 1000;

      if (ribu == ribu.roundToDouble()) {
        return 'Rp ${ribu.toInt()}K';
      }

      return 'Rp ${ribu.toStringAsFixed(1)}K';
    }

    return 'Rp $value';
  }

  String formatGrowth(
    double value,
  ) {
    final prefix = value > 0 ? '+' : '';

    return '$prefix${value.toStringAsFixed(1)}%';
  }
}
