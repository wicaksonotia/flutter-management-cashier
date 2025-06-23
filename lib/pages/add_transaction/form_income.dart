import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/add_transaction/calculator.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/routes.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormIncome extends StatefulWidget {
  const FormIncome({super.key});

  @override
  State<FormIncome> createState() => _FormIncomeState();
}

class _FormIncomeState extends State<FormIncome> {
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
          InkWell(
            onTap: () {
              Get.toNamed(RouterClass.income);
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
                              .dataCategoryIncomeName.value.isNotEmpty
                          ? _transactionController.dataCategoryIncomeName.value
                          : 'Income Category',
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
              labelText: 'Amount',
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
                      _transactionController.showDialogDatePickerIncome();
                    },
                    controller: TextEditingController(
                      text: DateFormat('dd MMMM yyyy').format(
                        _transactionController
                            .selectTransactionIncomeDate.value,
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
                      _transactionController.showDialogTimePickerIncome();
                    },
                    controller: TextEditingController(
                      text: DateFormat('HH:mm').format(
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          _transactionController
                              .selectTransactionIncomeTime.value.hour,
                          _transactionController
                              .selectTransactionIncomeTime.value.minute,
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
                _transactionController.saveTransactionIncome();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary, // Button color
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
