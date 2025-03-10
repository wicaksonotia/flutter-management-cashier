import 'package:financial_apps/controllers/transaction_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerticalList extends StatefulWidget {
  const VerticalList({super.key});

  @override
  State<VerticalList> createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  final TransactionController transactionController =
      Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => transactionController.isLoading.value
          ? Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .3,
                child: ListView.builder(
                    padding: const EdgeInsets.only(top: 5),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: transactionController.resultData.length,
                    itemBuilder: (context, int index) {
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        child: ListTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: MyColors.primary,
                                onPressed: () => (),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: MyColors.red,
                                onPressed: () => transactionController
                                    .deleteTransaction(transactionController
                                        .resultData[index].id),
                              ),
                            ],
                          ),
                          leading:
                              transactionController.resultData[index].type ==
                                      "PEMASUKAN"
                                  ? const Icon(
                                      Icons.download,
                                      color: MyColors.green,
                                    )
                                  : const Icon(
                                      Icons.upload,
                                      color: MyColors.red,
                                    ),
                          title: Text(
                            CurrencyFormat.convertToIdr(
                                transactionController.resultData[index].amount,
                                0),
                            style: const TextStyle(color: MyColors.primary),
                          ),
                          subtitle: Text(transactionController
                              .resultData[index].categoryName
                              .toString()),
                        ),
                      );
                    }),
              ),
            ),
    );
  }
}
