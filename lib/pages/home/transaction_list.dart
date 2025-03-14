import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/currency.dart';
import 'package:financial_apps/utils/sizes.dart';
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
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: historyController.resultDataSingleDate.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[200],
            thickness: 1,
            height: 1,
          ),
          itemBuilder: (context, index) {
            warna =
                historyController.resultDataSingleDate[index].categoryType ==
                        "PENGELUARAN"
                    ? MyColors.red
                    : MyColors.green;
            String kategori =
                historyController.resultDataSingleDate[index].categoryType!;
            int dataPrice =
                historyController.resultDataSingleDate[index].amount ?? 0;
            String transactionDate =
                historyController.resultDataSingleDate[index].transactionDate!;
            return ListTile(
              title: Text(
                  historyController.resultDataSingleDate[index].categoryName!),
              subtitle: Text(
                historyController.resultDataSingleDate[index].note ?? '',
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
                        text: kategori == "PEMASUKAN" ? '+ ' : '- ',
                        style: TextStyle(
                          color: kategori == "PEMASUKAN"
                              ? MyColors.green
                              : MyColors.red,
                          fontSize: MySizes.fontSizeLg,
                        ),
                        children: [
                          TextSpan(
                            text: 'Rp',
                            style: TextStyle(
                              color: warna,
                              fontSize: MySizes.fontSizeSm,
                            ),
                          ),
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
