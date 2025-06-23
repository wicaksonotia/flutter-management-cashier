import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    Color warna;
    return Obx(() {
      if (historyController.isLoading.value) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: 5, // Placeholder shimmer items
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[200],
            thickness: 1,
            height: 1,
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Container(
                height: 16,
                width: 100,
                color: Colors.grey[300],
              ),
              subtitle: Container(
                height: 14,
                width: 150,
                color: Colors.grey[300],
                margin: const EdgeInsets.only(top: 8),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 16,
                    width: 80,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 14,
                    width: 100,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.only(top: 8),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        if (historyController.resultDataSingleDate.isEmpty) {
          return const Center(
            child: Text(
              'There is no transaction data',
              style: TextStyle(
                fontSize: MySizes.fontSizeLg,
                color: MyColors.grey,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: historyController.resultDataSingleDate.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[200],
            thickness: 1,
            height: 1,
          ),
          itemBuilder: (context, index) {
            String kategori =
                historyController.resultDataSingleDate[index].transactionType!;
            warna = kategori == "PENGELUARAN" ? MyColors.red : Colors.green;

            int dataPrice =
                historyController.resultDataSingleDate[index].amount ?? 0;
            String transactionDate =
                historyController.resultDataSingleDate[index].transactionDate!;
            String transactionName =
                historyController.resultDataSingleDate[index].transactionName!;
            String cabang =
                historyController.resultDataSingleDate[index].cabang!;
            String note = historyController.resultDataSingleDate[index].note ==
                    '-'
                ? cabang
                : '${transactionName} : ${historyController.resultDataSingleDate[index].note!}';
            return ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: warna,
                ),
                padding: const EdgeInsets.all(3),
                child: Icon(
                  kategori == "PENGELUARAN"
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: Colors.white,
                ),
              ),
              title: RichText(
                text: TextSpan(
                  text: kategori,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: MySizes.fontSizeMd,
                  ),
                  children: [
                    TextSpan(
                      text: kategori == "PENGELUARAN" ? ' $cabang' : '',
                      style: const TextStyle(
                        color: MyColors.grey,
                        fontSize: MySizes.fontSizeSm,
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                note,
                style: const TextStyle(
                  color: MyColors.grey,
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: kategori == "PENGELUARAN" ? '- ' : '',
                        style: TextStyle(
                          color: warna,
                          fontSize: MySizes.fontSizeLg,
                        ),
                        children: [
                          TextSpan(
                            text: CurrencyFormat.convertToIdr(dataPrice, 0),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MySizes.fontSizeLg,
                              color: warna,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy')
                          .format(DateTime.parse(transactionDate)),
                      style: const TextStyle(
                        color: MyColors.grey,
                        fontSize: MySizes.fontSizeSm,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }
}
