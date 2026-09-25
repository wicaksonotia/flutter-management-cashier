import 'dart:convert';

import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/database/api_request.dart';
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

  // Tetap dipertahankan karena sudah digunakan oleh
  // struktur controller sebelumnya.
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

  final RxBool isIncome = false.obs;

  /// true  = transaksi terpusat
  /// false = transaksi menggunakan cabang aktif
  final RxBool isCentralized = true.obs;

  // ============================================================
  // CATEGORY TYPE
  // ============================================================

  List<String> kategori = [];

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
  // CATEGORY
  // ============================================================

  void setKategori() {
    kategori = [
      isIncome.value ? 'PEMASUKAN' : 'PENGELUARAN',
    ];
  }

  /// Dipanggil ketika user mengganti:
  /// Pemasukan <-> Pengeluaran
  Future<void> changeTransactionType(
    bool income,
  ) async {
    isIncome.value = income;

    setKategori();

    // Reset kategori lama karena kategori pemasukan
    // dan pengeluaran berbeda.
    idCategoryTransaction.value = 0;

    selectedCategoryTransaction.value = 'Category';

    await fetchAllCategory(
      isIncome.value ? ['PEMASUKAN'] : ['PENGELUARAN'],
    );
  }

  // ============================================================
  // DATE
  // ============================================================

  bool disableDate(DateTime day) {
    return day.isBefore(
      DateTime.now(),
    );
  }

  Future<void> showDialogDatePicker() async {
    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectTransactionExpenseDate.value,
      firstDate: DateTime(
        DateTime.now().year - 1,
      ),
      lastDate: DateTime(
        DateTime.now().year + 1,
      ),
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

    // Sinkronkan juga state income.
    selectTransactionIncomeDate.value = pickedDate;
  }

  // ============================================================
  // TIME
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

    // Sinkronkan juga state income.
    selectTransactionIncomeTime.value = pickedTime;
  }

  // ============================================================
  // BRAND / OUTLET
  // ============================================================

  /// Brand (`idKios`) selalu mengikuti Brand aktif
  /// yang sudah dipilih melalui Drawer.
  ///
  /// Tidak ada perubahan Brand dari form transaksi.
  int get activeKiosId {
    return idKios.value;
  }

  /// Jika transaksi terpusat:
  ///     id_cabang = 0
  ///
  /// Jika tidak:
  ///     gunakan cabang aktif dari BaseController.
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
  // TRANSACTION DATE FORMAT
  // ============================================================

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
  // SAVE TRANSACTION
  // ============================================================

  /// Return:
  ///
  /// true  = berhasil
  /// false = gagal / validation gagal
  ///
  /// Controller tidak melakukan:
  /// - Get.back()
  /// - Get.snackbar()
  ///
  /// UI yang menentukan bagaimana menampilkan hasil.
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
        jsonEncode(rawFormat),
      );

      final response = await RemoteDataSource.saveTransaction(
        rawFormat,
      );

      if (!response) {
        return false;
      }

      // ========================================================
      // CLEAR FORM
      // ========================================================

      clearForm();

      // ========================================================
      // REFRESH HISTORY
      // ========================================================

      await _historyController.getHistoriesByFilter();

      _historyController.getHistoriesBySingleDate();

      // ========================================================
      // REFRESH DASHBOARD FINANCIAL
      // ========================================================

      _totalPerTypeController.getTotalSaldo();

      _totalPerTypeController.getTotalBranchSaldo();

      _totalPerTypeController.getTotalPerMonth();

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

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void clearForm() {
    amountController.clear();
    descriptionController.clear();

    idCategoryTransaction.value = 0;

    selectedCategoryTransaction.value = 'Category';

    dataCategoryIncomeId.value = 0;
    dataCategoryIncomeName.value = '';

    isIncome.value = false;

    setKategori();

    final now = DateTime.now();

    selectTransactionExpenseDate.value = now;

    selectTransactionExpenseTime.value = TimeOfDay.fromDateTime(now);

    selectTransactionIncomeDate.value = now;

    selectTransactionIncomeTime.value = TimeOfDay.fromDateTime(now);
  }

  // ============================================================
  // RESET FORM WITHOUT RESETTING OUTLET / BRAND
  // ============================================================

  void resetForm() {
    amountController.clear();
    descriptionController.clear();

    idCategoryTransaction.value = 0;
    selectedCategoryTransaction.value = 'Category';

    dataCategoryIncomeId.value = 0;
    dataCategoryIncomeName.value = '';

    isIncome.value = false;

    // Default transaksi baru = terpusat.
    isCentralized.value = true;

    setKategori();

    final now = DateTime.now();

    selectTransactionExpenseDate.value = now;
    selectTransactionExpenseTime.value = TimeOfDay.fromDateTime(now);

    selectTransactionIncomeDate.value = now;
    selectTransactionIncomeTime.value = TimeOfDay.fromDateTime(now);
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
