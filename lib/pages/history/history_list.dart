import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/currency.dart';
import 'package:financial_apps/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
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
          itemCount: historyController.resultData.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[200],
            thickness: 1,
            height: 1,
          ),
          itemBuilder: (context, index) {
            warna = historyController.resultData[index].categoryType ==
                    "PENGELUARAN"
                ? MyColors.red
                : MyColors.green;
            String kategori = historyController.resultData[index].categoryType!;
            int dataPrice = historyController.resultData[index].amount ?? 0;
            String transactionDate =
                historyController.resultData[index].transactionDate!;
            return ListTile(
              title: Text(historyController.resultData[index].categoryName!),
              subtitle: Text(
                historyController.resultData[index].note ?? '',
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
