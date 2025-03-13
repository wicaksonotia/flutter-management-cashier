import 'package:financial_apps/database/database_helper.dart';
import 'package:financial_apps/models/transaction_model.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionSqliteController extends GetxController {
  TextEditingController amountController = TextEditingController();
  var tipeContoller = dropDownKategori.first.obs;
  var kategoriController = 'STMJ'.obs;
  var kategoriSearch = dropDownKategoriSearch.first.obs;
  var resultData = <TransactionModel>[].obs;
  RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  var selectedDate = DateTime.now().obs;
  var selectedTabDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    DateTime date = DateTime(selectedTabDate.value.year,
        selectedTabDate.value.month, selectedTabDate.value.day);
    var convertedDateBackToInt = date.millisecondsSinceEpoch;
    getData(kategoriSearch.value, convertedDateBackToInt);
  }

  insertTransaction() async {
    DateTime date = DateTime(selectedDate.value.year, selectedDate.value.month,
        selectedDate.value.day);
    var convertedDateBackToInt = date.millisecondsSinceEpoch;
    final model = TransactionModel(
      id: resultData.length,
      type: tipeContoller.value,
      categoryName: kategoriController.value,
      transactionDate: convertedDateBackToInt,
      amount: int.parse(amountController.text),
    );
    DatabaseHelper().insertTransactions(model);
    amountController.clear();
    // selectedTabDate.value =
    //     DateTime.fromMillisecondsSinceEpoch(convertedDateBackToInt);
    // print(selectedTabDate.value);
    DateTime now = new DateTime.now();
    DateTime dateNow = new DateTime(now.year, now.month, now.day);
    getData(kategoriSearch.value, dateNow.millisecondsSinceEpoch);
    // Get.back();
  }

  void getData(String kategori, int convertedDateBackToInt) async {
    try {
      isLoading(true);
      resultData.clear();
      DatabaseHelper.instance
          .fetchTransactions(kategori, convertedDateBackToInt)
          .then((value) {
        for (var element in value) {
          // var dt = DateTime.fromMillisecondsSinceEpoch(element.transactionDate);
          resultData.add(
            TransactionModel(
              id: element.id,
              type: element.type,
              categoryName: element.categoryName,
              // categoryName:
              //     "${element.categoryName} / ${DateFormat('dd MMMM yyyy hh:mm:ss', 'id_ID').format(dt).toString()}",
              transactionDate: element.transactionDate,
              amount: element.amount,
            ),
          );
        }
      });
    } catch (error) {
      Get.snackbar('Error', "Silakan cek koneksi internet anda.",
          icon: const Icon(Icons.error), snackPosition: SnackPosition.BOTTOM);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  void deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransactions(id);
    resultData.removeWhere((element) => element.id == id);
  }

  void updateTransaction(int id) async {
    // await DatabaseHelper.instance.deleteTransactions(id);
    // resultData.removeWhere((element) => element.id == id);
  }

  bool disableDate(DateTime day) {
    if (day.isBefore(DateTime.now().add(const Duration(days: 0)))) {
      return true;
    }
    return false;
  }

  chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: selectedDate.value,
        firstDate: DateTime(2025),
        lastDate: DateTime(2030),
        //initialEntryMode: DatePickerEntryMode.input,
        // initialDatePickerMode: DatePickerMode.year,
        helpText: 'Transaction Date',
        cancelText: 'Close',
        confirmText: 'Confirm',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter valid date range',
        fieldLabelText: 'Transaction Date',
        fieldHintText: 'Month/Date/Year',
        selectableDayPredicate: disableDate);
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }
}
