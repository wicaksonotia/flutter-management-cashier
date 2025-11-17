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
  final HistoryController _historyController = Get.find<HistoryController>();
  final TotalPerTypeController _totalPerTypeController =
      Get.find<TotalPerTypeController>();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var selectTransactionExpenseDate = DateTime.now().obs;
  var selectTransactionExpenseTime = TimeOfDay.now().obs;
  var selectTransactionIncomeDate = DateTime.now().obs;
  var selectTransactionIncomeTime = TimeOfDay.now().obs;
  var dataCategoryIncomeId = 0.obs;
  var dataCategoryIncomeName = ''.obs;
  RxBool isLoadingSaveTransaction = true.obs;
  var kategori = [];
  var isIncome = false.obs;
  var isCentralized = true.obs;

  @override
  void onInit() {
    super.onInit();
    setKategori();
  }

  void setKategori() {
    kategori = [];
    isIncome.value ? kategori.add('PEMASUKAN') : kategori.add('PENGELUARAN');
  }

  bool disableDate(DateTime day) {
    if ((day.isBefore(DateTime.now().add(const Duration(days: 0))))) {
      return true;
    }
    return false;
  }

  void showDialogDatePicker() async {
    var pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectTransactionExpenseDate.value,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      //initialEntryMode: DatePickerEntryMode.input,
      // initialDatePickerMode: DatePickerMode.year,
      helpText: 'Transaction Date',
      cancelText: 'Close',
      confirmText: 'Confirm',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter valid date range',
      fieldLabelText: 'Transaction Date',
      fieldHintText: 'Month/Date/Year',
      selectableDayPredicate: disableDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              outlineVariant: Colors.grey.shade200,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null &&
        pickedDate != selectTransactionExpenseDate.value) {
      selectTransactionExpenseDate.value = pickedDate;
    }
  }

  void showDialogTimePicker() async {
    var pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: selectTransactionExpenseTime.value,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors.primary,
              onPrimary: Colors.white,
              tertiary:
                  MyColors.primary, // Background color for am/pm when selected
              onSurfaceVariant: Colors.black, // Text color for am/pm
              onTertiary: Colors.white, // Text color for am/pm when selected
              onPrimaryContainer: Colors
                  .white, // Text color for hours and minutes when selected
              outline: Colors.grey.shade300, // outline color for am/pm
              surface: Colors.black, // Text color
              // onSurface: Colors.yellow,
              surfaceContainerHigh: Colors.white, // Background color
              surfaceContainerHighest: Colors.grey.shade100, // Background clock
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null &&
        pickedTime != selectTransactionExpenseTime.value) {
      selectTransactionExpenseTime.value = pickedTime;
    }
  }

  void saveTransaction() async {
    try {
      if (amountController.text.isEmpty || descriptionController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill in all fields',
            icon: const Icon(Icons.error),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[800]);
        return;
      }
      if (isCentralized.value) {
        idCabang.value = 0;
      }
      var rawFormat = {
        'id_kios': idKios.value,
        'id_cabang': idCabang.value,
        'id_kategori_transaksi': idCategoryTransaction.value,
        'amount':
            int.parse(amountController.text.replaceAll(RegExp('[^0-9]'), '')),
        'description': descriptionController.text,
        'transaction_type': isIncome.value ? 'PEMASUKAN' : 'PENGELUARAN',
        'transaction_date': selectTransactionExpenseDate.value.toString(),
        'transaction_time': DateFormat('HH:mm:ss').format(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            selectTransactionExpenseTime.value.hour,
            selectTransactionExpenseTime.value.minute,
          ),
        ),
      };
      print(jsonEncode(rawFormat));
      var response = await RemoteDataSource.saveTransaction(rawFormat);
      if (response) {
        Get.snackbar('Success', 'Transaksi berhasil disimpan',
            icon: const Icon(Icons.check), snackPosition: SnackPosition.TOP);
        amountController.clear();
        descriptionController.clear();
        _historyController.getHistoriesByFilter();
        _historyController.getHistoriesBySingleDate();
        _totalPerTypeController.getTotalSaldo();
        _totalPerTypeController.getTotalBranchSaldo();
        _totalPerTypeController.getTotalPerMonth();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          icon: const Icon(Icons.error), snackPosition: SnackPosition.TOP);
    } finally {
      isLoadingSaveTransaction(false);
    }
  }
}
