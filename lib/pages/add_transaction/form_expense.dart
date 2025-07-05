import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/add_transaction/calculator.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormExpense extends StatefulWidget {
  const FormExpense({super.key});

  @override
  State<FormExpense> createState() => _FormExpenseState();
}

class _FormExpenseState extends State<FormExpense> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Column(
        children: [
          Obx(
            () => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Text(
                _transactionController.namaKios.value,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ),
          const Gap(10),
          InkWell(
            onTap: () {
              Get.toNamed(RouterClass.expensefrom);
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
                      _transactionController.cabang.value.isNotEmpty
                          ? _transactionController.cabang.value
                          : 'Cabang Kios',
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
              Get.toNamed(RouterClass.expense);
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
                      _transactionController.namaKategori.value.isNotEmpty
                          ? _transactionController.namaKategori.value
                          : 'Kategori',
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
              labelText: 'Total Belanja',
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
              labelText: 'Deskripsi',
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
                      _transactionController.showDialogDatePickerExpense();
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
                width: MediaQuery.of(context).size.width * .3,
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
                      _transactionController.showDialogTimePickerExpense();
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
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _transactionController.saveTransactionExpense();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.red, // Button color
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
