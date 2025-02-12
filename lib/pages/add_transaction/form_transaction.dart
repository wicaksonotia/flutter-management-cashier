import 'package:financial_apps/controllers/category_controller.dart';
import 'package:financial_apps/controllers/transaction_controller.dart';
import 'package:financial_apps/utils/loading_button.dart';
import 'package:financial_apps/utils/app_bar_header.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppbarHeader(
            header: 'Add Transaction',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputDecorator(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Type",
                    contentPadding: EdgeInsets.fromLTRB(10, 3, 3, 3)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: transactionController.tipeContoller.value,
                    items: dropDownKategori.map(
                      (String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      transactionController.tipeContoller.value = value!;
                      categoryController.getData(value);
                      transactionController.kategoriController.value =
                          value == "Pemasukan" ? "STMJ" : "SUSU";
                    },
                    isExpanded: true,
                    style: const TextStyle(
                        fontSize: 17, color: MyColors.darkTextColor),
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     Switch(
              //       value: transactionController.isExpense.value,
              //       onChanged: (value) => (() {
              //         transactionController.isExpense.value = value;
              //       }),
              //       inactiveTrackColor: Colors.green[200],
              //       inactiveThumbColor: Colors.green,
              //       activeColor: MyColors.red,
              //     ),
              //     Text(transactionController.isExpense.value
              //         ? 'Pengeluaran'
              //         : 'Pemasukan'),
              //   ],
              // ),
              const Gap(10),
              InputDecorator(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Category",
                    contentPadding: EdgeInsets.fromLTRB(10, 3, 3, 3)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: transactionController.kategoriController.value,
                    items: categoryController.resultData.map(
                      (val) {
                        return DropdownMenuItem(
                          value: val.name,
                          child: Text(val.name),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      transactionController.kategoriController.value = value!;
                    },
                    isExpanded: true,
                    style: const TextStyle(
                        fontSize: 17, color: MyColors.darkTextColor),
                  ),
                ),
              ),
              const Gap(10),
              TextFormField(
                controller: transactionController.amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // border: UnderlineInputBorder(),
                  labelText: "Amount",
                ),
              ),
              const Gap(30),
              // const Text(
              //   'Category',
              //   style: TextStyle(fontSize: 16),
              // ),
              // DropdownButton(
              //   value: transactionController.tipeContoller.value,
              //   items: dropDownTransactionCategories.map(
              //     (String value) {
              //       return DropdownMenuItem(
              //         value: value,
              //         child: Text(value),
              //       );
              //     },
              //   ).toList(),
              //   onChanged: (value) {
              //     transactionController.tipeContoller.value = value!;
              //   },
              //   isExpanded: true,
              //   style: const TextStyle(
              //       fontSize: 17, color: MyColors.darkTextColor),
              // ),
              const Gap(20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: DateFormat('dd MMMM yyyy', 'id_ID')
                            .format(transactionController.selectedDate.value)
                            .toString(),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: MyColors.primary,
                    ),
                    child: IconButton(
                      onPressed: () {
                        transactionController.chooseDate();
                      },
                      icon: const Icon(Icons.date_range_rounded),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Gap(30),
              // if (transactionController.isLoading.value) {
              //   return LoadingButton(
              //     onClick: () async {},
              //     color: MyColors.primary,
              //     childWidget: const Center(
              //       child: CircularProgressIndicator(
              //         backgroundColor: Colors.white,
              //       ),
              //     ),
              //   );
              // } else {
              //   return
              LoadingButton(
                onClick: () {
                  transactionController.insertTransaction();
                },
                color: MyColors.primary,
                childWidget: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // }
            ],
          ),
        ),
      ),
    );
  }
}
