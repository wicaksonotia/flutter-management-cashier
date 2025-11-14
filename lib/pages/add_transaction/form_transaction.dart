import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/add_transaction/calculator.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormTransaction extends StatefulWidget {
  const FormTransaction({super.key});

  @override
  State<FormTransaction> createState() => _FormTransactionState();
}

class _FormTransactionState extends State<FormTransaction> {
  final TransactionController _transactionController =
      Get.put(TransactionController());

  @override
  void initState() {
    super.initState();
    _transactionController.fetchDataListKios(
      onAfterSuccess: () => _transactionController.fetchDataListCabang(),
    );
    _transactionController.getData(["PENGELUARAN"], "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade50, // Set your desired background color here
        child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: BackgroundForm(
              headerTitle: 'Transaction Form',
              container: containerPage(),
            )),
      ),
    );
  }

  Container containerPage() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 120, 20, 0),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(
                () => SelectTableListPage(
                  title: 'Outlet',
                  isLoading: _transactionController.isLoadingKios,
                  items: _transactionController.resultDataKios,
                  titleBuilder: (data) => data.kios!,
                  subtitleBuilder: (data) => data.keterangan ?? '',
                  isSelected: (data) =>
                      data.idKios == _transactionController.idKios.value,
                  onItemTap: (data) async {
                    _transactionController.idKios.value = data.idKios!;
                    _transactionController.selectedKios.value = data.kios!;
                    await _transactionController.fetchDataListCabang();
                    Get.back();
                  },
                  onRefresh: () async {
                    await _transactionController
                        .fetchDataListKios(); // API fetch
                  },
                ),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      _transactionController.selectedKios.value.isNotEmpty
                          ? _transactionController.selectedKios.value
                          : 'Outlet',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: MyColors.primary),
                ],
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              Get.to(
                () => SelectTableListPage(
                  title: 'Outlet',
                  isLoading: _transactionController.isLoadingCabang,
                  items: _transactionController.resultDataCabang,
                  titleBuilder: (data) => data.cabang!,
                  subtitleBuilder: (data) => data.alamat ?? '',
                  isSelected: (data) =>
                      data.id == _transactionController.idCabang.value,
                  onItemTap: (data) async {
                    _transactionController.idCabang.value = data.id!;
                    _transactionController.selectedCabang.value = data.cabang!;
                    Get.back();
                  },
                  onRefresh: () async {
                    await _transactionController
                        .fetchDataListCabang(); // API fetch
                  },
                ),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      _transactionController.selectedCabang.value.isNotEmpty
                          ? _transactionController.selectedCabang.value
                          : 'Outlet',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: MyColors.primary),
                ],
              ),
            ),
          ),
          const Gap(10),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction Type',
                ),
                Row(
                  children: [
                    Text(_transactionController.isIncome.value
                        ? "Income"
                        : "Expense"),
                    const SizedBox(width: 8),
                    Switch(
                      activeColor: MyColors.primary,
                      value: !_transactionController
                          .isIncome.value, // false = expense, true = income
                      onChanged: (value) {
                        _transactionController.idCategoryTransaction.value = 0;
                        _transactionController
                            .selectedCategoryTransaction.value = 'Category';
                        _transactionController.isIncome.value = !value;
                        var type = _transactionController.isIncome.value
                            ? "PEMASUKAN"
                            : "PENGELUARAN";
                        _transactionController.getData([type], "");
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
          const Gap(10),
          InkWell(
            onTap: () {
              Get.to(
                () => SelectTableListPage(
                  title: 'Category',
                  isLoading: _transactionController.isLoading,
                  items: _transactionController.resultData,
                  titleBuilder: (data) => data.categoryName!,
                  subtitleBuilder: (data) => '',
                  isSelected: (data) =>
                      data.id ==
                      _transactionController.idCategoryTransaction.value,
                  onItemTap: (data) async {
                    _transactionController.idCategoryTransaction.value =
                        data.id!;
                    _transactionController.selectedCategoryTransaction.value =
                        data.categoryName!;
                    Get.back();
                  },
                  onRefresh: () async {
                    var type = _transactionController.isIncome.value
                        ? "PEMASUKAN"
                        : "PENGELUARAN";
                    await _transactionController
                        .getData([type], ""); // API fetch
                  },
                ),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      _transactionController
                              .selectedCategoryTransaction.value.isNotEmpty
                          ? _transactionController
                              .selectedCategoryTransaction.value
                          : 'Category',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: MyColors.primary),
                ],
              ),
            ),
          ),
          const Gap(10),
          TextFormField(
            controller: _transactionController.amountController,
            inputFormatters: [
              CurrencyTextInputFormatter.currency(
                locale: 'id',
                decimalDigits: 0,
                symbol: 'Rp.',
              )
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Cost',
              floatingLabelStyle: const TextStyle(
                color: MyColors.primary,
              ),
              hintText: 'Rp.0',
              hintStyle: TextStyle(
                color: Colors.grey.shade300,
              ),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calculate),
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const CalculatorPage());
                      });
                },
              ),
            ),
          ),
          const Gap(10),
          TextFormField(
            controller: _transactionController.descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              floatingLabelStyle: const TextStyle(
                color: MyColors.primary,
              ),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Description',
              hintStyle: TextStyle(
                color: Colors.grey.shade300,
              ),
            ),
          ),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .55,
                child: Obx(
                  () => TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today,
                          color: Colors.black54),
                    ),
                    onTap: () {
                      _transactionController.showDialogDatePicker();
                    },
                    controller: TextEditingController(
                      text: DateFormat('dd MMMM yyyy', 'id_ID').format(
                        _transactionController
                            .selectTransactionExpenseDate.value,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .25,
                child: Obx(
                  () => TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      suffixIcon:
                          const Icon(Icons.access_time, color: Colors.black54),
                    ),
                    onTap: () {
                      _transactionController.showDialogTimePicker();
                    },
                    controller: TextEditingController(
                      text: DateFormat('HH:mm').format(
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          _transactionController
                              .selectTransactionExpenseTime.value.hour,
                          _transactionController
                              .selectTransactionExpenseTime.value.minute,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _transactionController.saveTransaction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: MySizes.fontSizeMd,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
