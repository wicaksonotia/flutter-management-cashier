import 'dart:convert';

import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionController extends CategoryController {
  late final HistoryController _historyController;
  late final TotalPerTypeController _totalPerTypeController;

  final TextEditingController amountController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final Rx<DateTime> selectTransactionExpenseDate = DateTime.now().obs;

  final Rx<TimeOfDay> selectTransactionExpenseTime = TimeOfDay.now().obs;

  final Rx<DateTime> selectTransactionIncomeDate = DateTime.now().obs;

  final Rx<TimeOfDay> selectTransactionIncomeTime = TimeOfDay.now().obs;

  final RxInt dataCategoryIncomeId = 0.obs;

  final RxString dataCategoryIncomeName = ''.obs;

  final RxBool isLoadingSaveTransaction = false.obs;

  final RxBool isIncome = false.obs;

  final RxBool isCentralized = true.obs;

  /// Brand aktif yang dipilih melalui Drawer.
  final RxInt activeKiosId = 0.obs;

  final RxString namaKios = ''.obs;

  /// Kategori transaksi yang sedang aktif.
  List<String> kategori = [];

  @override
  void onInit() {
    super.onInit();

    _historyController = Get.find<HistoryController>();
    _totalPerTypeController = Get.find<TotalPerTypeController>();

    _loadActiveBrand();

    setKategori();
  }

  // ===========================================================
  // ACTIVE BRAND
  // ===========================================================

  Future<void> _loadActiveBrand() async {
    final prefs = await SharedPreferences.getInstance();

    activeKiosId.value = prefs.getInt('id_kios') ?? 0;

    namaKios.value = prefs.getString('kios') ?? '';

    /// BaseController tetap disinkronkan juga.
    if (activeKiosId.value > 0) {
      idKios.value = activeKiosId.value;
    }
  }

  Future<void> refreshActiveBrand() async {
    await _loadActiveBrand();
  }

  // ===========================================================
  // TRANSACTION TYPE
  // ===========================================================

  void setKategori() {
    kategori = [
      isIncome.value ? 'PEMASUKAN' : 'PENGELUARAN',
    ];
  }

  Future<void> changeTransactionType(
    bool income,
  ) async {
    if (isIncome.value == income &&
        resultDataCategoryWithoutPagination.isNotEmpty) {
      return;
    }

    isIncome.value = income;

    setKategori();

    clearSelectedCategory();

    await fetchAllCategory(
      income ? ['PEMASUKAN'] : ['PENGELUARAN'],
    );
  }

  // ===========================================================
  // DATE
  // ===========================================================

  bool disableDate(DateTime day) {
    final today = DateTime.now();

    final selectedDay = DateTime(
      day.year,
      day.month,
      day.day,
    );

    final currentDay = DateTime(
      today.year,
      today.month,
      today.day,
    );

    return selectedDay.isAfter(currentDay);
  }

  Future<void> showDialogDatePicker() async {
    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectTransactionExpenseDate.value,
      firstDate: DateTime(
        DateTime.now().year - 1,
      ),
      lastDate: DateTime.now(),
      helpText: 'Tanggal transaksi',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      errorFormatText: 'Masukkan tanggal yang valid',
      errorInvalidText: 'Tanggal tidak valid',
      fieldLabelText: 'Tanggal transaksi',
      fieldHintText: 'Tanggal/Bulan/Tahun',
      selectableDayPredicate: disableDate,
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) {
      return;
    }

    selectTransactionExpenseDate.value = pickedDate;

    selectTransactionIncomeDate.value = pickedDate;
  }

  // ===========================================================
  // TIME
  // ===========================================================

  Future<void> showDialogTimePicker() async {
    final pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: selectTransactionExpenseTime.value,
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              tertiary: MyColors.primary,
              onSurfaceVariant: Colors.black,
              onTertiary: Colors.white,
              onPrimaryContainer: Colors.white,
              outline: Colors.grey,
              surface: Colors.white,
              surfaceContainerHigh: Colors.white,
              surfaceContainerHighest: Color(0xFFF5F5F5),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) {
      return;
    }

    selectTransactionExpenseTime.value = pickedTime;

    selectTransactionIncomeTime.value = pickedTime;
  }

  // ===========================================================
  // FORMATTED VALUE
  // ===========================================================

  String get formattedTransactionDate {
    return DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(
      selectTransactionExpenseDate.value,
    );
  }

  String get formattedTransactionTime {
    final time = selectTransactionExpenseTime.value;

    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  // ===========================================================
  // ACTIVE OUTLET
  // ===========================================================

  int get activeCabangId {
    if (isCentralized.value) {
      return 0;
    }

    return idCabang.value;
  }

  // ===========================================================
  // AMOUNT
  // ===========================================================

  int get amountValue {
    final cleanAmount = amountController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    return int.tryParse(cleanAmount) ?? 0;
  }

  // ===========================================================
  // VALIDATION
  // ===========================================================

  bool validateTransaction() {
    if (activeKiosId.value <= 0) {
      return false;
    }

    if (amountValue <= 0) {
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      return false;
    }

    if (idCategoryTransaction.value <= 0) {
      return false;
    }

    if (!isCentralized.value && idCabang.value <= 0) {
      return false;
    }

    return true;
  }

  // ===========================================================
  // REQUEST PAYLOAD
  // ===========================================================

  String get transactionDateValue {
    return selectTransactionExpenseDate.value.toIso8601String();
  }

  String get transactionTimeValue {
    final time = selectTransactionExpenseTime.value;

    final dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      time.hour,
      time.minute,
    );

    return DateFormat(
      'HH:mm:ss',
    ).format(dateTime);
  }

  Map<String, dynamic> buildRequestPayload() {
    return {
      'id_kios': activeKiosId.value,
      'id_cabang': activeCabangId,
      'id_kategori_transaksi': idCategoryTransaction.value,
      'amount': amountValue,
      'description': descriptionController.text.trim(),
      'transaction_type': isIncome.value ? 'PEMASUKAN' : 'PENGELUARAN',
      'transaction_date': transactionDateValue,
      'transaction_time': transactionTimeValue,
    };
  }

  // ===========================================================
  // SAVE
  // ===========================================================

  Future<bool> saveTransaction() async {
    if (isLoadingSaveTransaction.value) {
      return false;
    }

    if (!validateTransaction()) {
      return false;
    }

    try {
      isLoadingSaveTransaction.value = true;

      /// Pastikan Brand masih mengikuti Drawer.
      await refreshActiveBrand();

      if (activeKiosId.value <= 0) {
        return false;
      }

      final rawFormat = buildRequestPayload();

      debugPrint(
        jsonEncode(rawFormat),
      );

      final response = await RemoteDataSource.saveTransaction(
        rawFormat,
      );

      if (!response) {
        return false;
      }

      clearForm();

      await _refreshAfterSave();

      return true;
    } catch (e) {
      debugPrint(
        'saveTransaction error: $e',
      );

      return false;
    } finally {
      isLoadingSaveTransaction.value = false;
    }
  }

  // ===========================================================
  // REFRESH AFTER SAVE
  // ===========================================================

  Future<void> _refreshAfterSave() async {
    await _historyController.getHistoriesByFilter();

    await _historyController.getHistoriesBySingleDate();

    await _totalPerTypeController.getTotalSaldo();

    await _totalPerTypeController.getTotalBranchSaldo();

    await _totalPerTypeController.getTotalPerMonth();
  }

  // ===========================================================
  // CLEAR FORM
  // ===========================================================

  void clearSelectedCategory() {
    idCategoryTransaction.value = 0;

    selectedCategoryTransaction.value = 'Category';

    dataCategoryIncomeId.value = 0;

    dataCategoryIncomeName.value = '';
  }

  void resetForm() {
    amountController.clear();
    descriptionController.clear();

    clearSelectedCategory();

    isIncome.value = false;
    isCentralized.value = true;

    setKategori();

    final now = DateTime.now();

    selectTransactionExpenseDate.value = now;

    selectTransactionExpenseTime.value = TimeOfDay.fromDateTime(now);

    selectTransactionIncomeDate.value = now;

    selectTransactionIncomeTime.value = TimeOfDay.fromDateTime(now);

    /// Jangan lupa brand aktif dari Drawer.
    _loadActiveBrand();
  }

  void clearForm() {
    amountController.clear();
    descriptionController.clear();

    clearSelectedCategory();

    isIncome.value = false;

    setKategori();

    final now = DateTime.now();

    selectTransactionExpenseDate.value = now;

    selectTransactionExpenseTime.value = TimeOfDay.fromDateTime(now);

    selectTransactionIncomeDate.value = now;

    selectTransactionIncomeTime.value = TimeOfDay.fromDateTime(now);
  }

  // ===========================================================
  // DISPOSE
  // ===========================================================

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();

    super.onClose();
  }
}
