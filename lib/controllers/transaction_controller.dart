import 'dart:convert';

import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/database/api_request.dart';
import 'package:cashier_management/models/history_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionController extends CategoryController {
  // ============================================================
  // DEPENDENCIES
  // ============================================================

  late final HistoryController _historyController;
  late final TotalPerTypeController _totalPerTypeController;

  // ============================================================
  // FORM CONTROLLER
  // ============================================================

  final TextEditingController amountController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  // ============================================================
  // TRANSACTION DATE & TIME
  // ============================================================

  final Rx<DateTime> selectTransactionExpenseDate = DateTime.now().obs;

  final Rx<TimeOfDay> selectTransactionExpenseTime = TimeOfDay.now().obs;

  final Rx<DateTime> selectTransactionIncomeDate = DateTime.now().obs;

  final Rx<TimeOfDay> selectTransactionIncomeTime = TimeOfDay.now().obs;

  // ============================================================
  // TRANSACTION CATEGORY
  // ============================================================

  final RxInt dataCategoryIncomeId = 0.obs;

  final RxString dataCategoryIncomeName = ''.obs;

  // ============================================================
  // STATE
  // ============================================================

  final RxBool isLoadingSaveTransaction = false.obs;

  /// true  = pemasukan
  /// false = pengeluaran
  final RxBool isIncome = false.obs;

  /// true  = transaksi terpusat
  /// false = transaksi menggunakan cabang
  final RxBool isCentralized = true.obs;

  /// true  = mode edit
  /// false = mode tambah
  final RxBool isEdit = false.obs;

  /// ID transaksi yang sedang diedit
  final RxInt editingId = 0.obs;

  // ============================================================
  // CATEGORY TYPE
  // ============================================================

  List<String> kategori = [];

  // ============================================================
  // FORMATTED DATE
  // ============================================================

  String get formattedTransactionDate {
    return DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(
      selectTransactionExpenseDate.value,
    );
  }

  // ============================================================
  // FORMATTED TIME
  // ============================================================

  String get formattedTransactionTime {
    final time = selectTransactionExpenseTime.value;

    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    _historyController = Get.find<HistoryController>();

    _totalPerTypeController = Get.find<TotalPerTypeController>();

    setKategori();
  }

  // ============================================================
  // CATEGORY TYPE
  // ============================================================

  void setKategori() {
    kategori = [
      isIncome.value ? 'PEMASUKAN' : 'PENGELUARAN',
    ];
  }

  // ============================================================
  // CURRENT CATEGORY TYPE
  // ============================================================

  List<String> get currentTransactionKategori {
    return [
      isIncome.value ? 'PEMASUKAN' : 'PENGELUARAN',
    ];
  }

  // ============================================================
  // LOAD TRANSACTION CATEGORY
  // ============================================================

  Future<void> refreshTransactionCategories() async {
    await fetchAllCategory(
      currentTransactionKategori,
    );
  }

  // ============================================================
  // CHANGE TRANSACTION TYPE
  // ============================================================

  Future<void> changeTransactionType(
    bool income,
  ) async {
    // ==========================================================
    // SET TYPE
    // ==========================================================

    isIncome.value = income;

    // ==========================================================
    // UPDATE CATEGORY TYPE
    // ==========================================================

    setKategori();

    // ==========================================================
    // CLEAR SELECTED CATEGORY
    // ==========================================================

    idCategoryTransaction.value = 0;

    selectedCategoryTransaction.value = 'Category';

    // ==========================================================
    // FETCH CATEGORY TERBARU
    // ==========================================================

    await refreshTransactionCategories();
  }

  // ============================================================
  // DATE
  // ============================================================

  bool disableDate(DateTime day) {
    final today = DateTime.now();

    final currentDay = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final selectedDay = DateTime(
      day.year,
      day.month,
      day.day,
    );

    return selectedDay.isAfter(currentDay);
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> showDialogDatePicker() async {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final firstAllowedDate = DateTime(
      now.year - 1,
      now.month,
      now.day,
    );

    final selectedDate = selectTransactionExpenseDate.value;

    DateTime initialDate = selectedDate;

    if (initialDate.isBefore(firstAllowedDate)) {
      initialDate = firstAllowedDate;
    }

    if (initialDate.isAfter(today)) {
      initialDate = today;
    }

    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstAllowedDate,
      lastDate: today,
      helpText: 'Pilih tanggal transaksi',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      errorFormatText: 'Masukkan tanggal yang valid',
      errorInvalidText: 'Tanggal tidak valid',
      fieldLabelText: 'Tanggal transaksi',
      fieldHintText: 'Tanggal/Bulan/Tahun',
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              surface: MyColors.surface,
              onSurface: MyColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: MyColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: MyColors.surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              headerBackgroundColor: MyColors.primary,
              headerForegroundColor: Colors.white,
              weekdayStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              dayStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              todayBackgroundColor: const WidgetStatePropertyAll(
                MyColors.primaryLight,
              ),
              todayForegroundColor: const WidgetStatePropertyAll(
                MyColors.primary,
              ),
              todayBorder: BorderSide(
                color: MyColors.primary,
                width: 1,
              ),
              yearStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: MyColors.textSecondary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: MyColors.primary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
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

  // ============================================================
  // TIME PICKER
  // ============================================================

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

  // ============================================================
  // BRAND / OUTLET
  // ============================================================

  int get activeKiosId {
    return idKios.value;
  }

  int get activeCabangId {
    if (isCentralized.value) {
      return 0;
    }

    return idCabang.value;
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool validateTransaction() {
    final amountText = amountController.text.trim();

    final description = descriptionController.text.trim();

    if (amountText.isEmpty) {
      return false;
    }

    if (description.isEmpty) {
      return false;
    }

    if (idCategoryTransaction.value <= 0) {
      return false;
    }

    if (activeKiosId <= 0) {
      return false;
    }

    if (!isCentralized.value && activeCabangId <= 0) {
      return false;
    }

    if (isEdit.value && editingId.value <= 0) {
      return false;
    }

    return true;
  }

  // ============================================================
  // AMOUNT
  // ============================================================

  int get amountValue {
    final cleanAmount = amountController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    return int.tryParse(cleanAmount) ?? 0;
  }

  // ============================================================
  // TRANSACTION DATE
  // ============================================================

  String get transactionDateValue {
    return DateFormat(
      'yyyy-MM-dd',
    ).format(
      selectTransactionExpenseDate.value,
    );
  }

  // ============================================================
  // TRANSACTION TIME
  // ============================================================

  String get transactionTimeValue {
    final time = selectTransactionExpenseTime.value;

    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:00';
  }

  // ============================================================
  // REQUEST PAYLOAD
  // ============================================================

  Map<String, dynamic> buildRequestPayload() {
    return {
      'id_kios': activeKiosId,
      'id_cabang': activeCabangId,
      'id_kategori_transaksi': idCategoryTransaction.value,
      'amount': amountValue,
      'description': descriptionController.text.trim(),
      'transaction_type': isIncome.value ? 'PEMASUKAN' : 'PENGELUARAN',
      'transaction_date': transactionDateValue,
      'transaction_time': transactionTimeValue,
    };
  }

  // ============================================================
  // SAVE / UPDATE
  // ============================================================

  Future<bool> saveTransaction() async {
    if (isLoadingSaveTransaction.value) {
      return false;
    }

    if (!validateTransaction()) {
      return false;
    }

    try {
      isLoadingSaveTransaction.value = true;

      final rawFormat = buildRequestPayload();

      debugPrint(
        '======================================',
      );

      debugPrint(
        isEdit.value
            ? 'UPDATE FINANCIAL TRANSACTION'
            : 'SAVE FINANCIAL TRANSACTION',
      );

      debugPrint(
        jsonEncode({
          if (isEdit.value) 'id': editingId.value,
          ...rawFormat,
        }),
      );

      debugPrint(
        '======================================',
      );

      bool response;

      // ========================================================
      // EDIT
      // ========================================================

      if (isEdit.value) {
        response = await RemoteDataSource.updateTransaction(
          id: editingId.value,
          rawFormat: rawFormat,
        );
      }

      // ========================================================
      // TAMBAH
      // ========================================================

      else {
        response = await RemoteDataSource.saveTransaction(
          rawFormat,
        );
      }

      if (!response) {
        return false;
      }

      // ========================================================
      // REFRESH HISTORY
      // ========================================================

      await _historyController.getHistoriesByFilter();

      await _historyController.getHistoriesBySingleDate();

      // ========================================================
      // REFRESH DASHBOARD
      // ========================================================

      await _totalPerTypeController.getTotalSaldo();

      await _totalPerTypeController.getTotalBranchSaldo();

      await _totalPerTypeController.getTotalPerMonth();

      // ========================================================
      // RESET
      // ========================================================

      resetForm();

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'saveTransaction error: $e',
      );

      debugPrint(
        '$stackTrace',
      );

      return false;
    } finally {
      isLoadingSaveTransaction.value = false;
    }
  }

  // ============================================================
  // RESET FORM
  // ============================================================

  void resetForm() {
    amountController.clear();

    descriptionController.clear();

    idCategoryTransaction.value = 0;

    selectedCategoryTransaction.value = 'Category';

    dataCategoryIncomeId.value = 0;

    dataCategoryIncomeName.value = '';

    isIncome.value = false;

    isCentralized.value = true;

    isEdit.value = false;

    editingId.value = 0;

    idCabang.value = 0;

    selectedCabang.value = 'Outlet';

    setKategori();

    final now = DateTime.now();

    selectTransactionExpenseDate.value = now;

    selectTransactionExpenseTime.value = TimeOfDay.fromDateTime(now);

    selectTransactionIncomeDate.value = now;

    selectTransactionIncomeTime.value = TimeOfDay.fromDateTime(now);
  }

  // ============================================================
  // EDIT TRANSACTION
  // ============================================================

  Future<void> setEditTransaction(
    DataHistory data,
  ) async {
    // ==========================================================
    // MODE EDIT
    // ==========================================================

    isEdit.value = true;

    editingId.value = data.id ?? 0;

    // ==========================================================
    // JENIS TRANSAKSI
    // ==========================================================

    final transactionType = (data.transactionType ?? '').trim().toUpperCase();

    final income = transactionType == 'PEMASUKAN';

    isIncome.value = income;

    setKategori();

    // ==========================================================
    // BRAND / KIOS
    // ==========================================================

    if (data.idKios != null && data.idKios! > 0) {
      idKios.value = data.idKios!;
    }

    // ==========================================================
    // NOMINAL
    // ==========================================================

    amountController.text = NumberFormat(
      '#,###',
      'id_ID',
    ).format(
      data.amount ?? 0,
    );

    // ==========================================================
    // KETERANGAN
    // ==========================================================

    descriptionController.text = data.note ?? '';

    // ==========================================================
    // TERPUSAT / CABANG
    // ==========================================================

    final cabangId = data.idCabang ?? 0;

    isCentralized.value = cabangId <= 0;

    if (!isCentralized.value) {
      idCabang.value = cabangId;

      selectedCabang.value =
          data.cabang?.isNotEmpty == true ? data.cabang! : 'Outlet';
    } else {
      idCabang.value = 0;

      selectedCabang.value = 'Outlet';
    }

    // ==========================================================
    // TANGGAL + WAKTU
    // ==========================================================

    if (data.transactionDate != null &&
        data.transactionDate!.trim().isNotEmpty) {
      final parsedDate = DateTime.tryParse(
        data.transactionDate!.trim(),
      );

      if (parsedDate != null) {
        selectTransactionExpenseDate.value = parsedDate;

        selectTransactionIncomeDate.value = parsedDate;

        final time = TimeOfDay(
          hour: parsedDate.hour,
          minute: parsedDate.minute,
        );

        selectTransactionExpenseTime.value = time;

        selectTransactionIncomeTime.value = time;
      }
    }

    // ==========================================================
    // LOAD CATEGORY
    // ==========================================================

    await refreshTransactionCategories();

    // ==========================================================
    // RESTORE CATEGORY TERPILIH
    // ==========================================================

    idCategoryTransaction.value = data.transactionCategoryId ?? 0;

    selectedCategoryTransaction.value = data.transactionName?.isNotEmpty == true
        ? data.transactionName!
        : 'Category';
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    amountController.dispose();

    descriptionController.dispose();

    super.onClose();
  }
}
