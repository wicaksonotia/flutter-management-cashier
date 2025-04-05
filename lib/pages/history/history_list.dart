import 'package:financial_apps/controllers/history_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/currency.dart';
import 'package:financial_apps/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (historyController.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                        ),
                        const Gap(8),
                        Container(
                          width: double.infinity,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return GroupedListView<dynamic, String>(
          elements: historyController.resultData,
          groupBy: (element) => DateFormat('dd MMMM yyyy')
              .format(DateTime.parse(element.transactionDate!)),
          groupComparator: (value1, value2) => value2.compareTo(value1),
          groupSeparatorBuilder: (String groupByValue) => Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.only(left: 16, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[100]!, width: 1),
                bottom: BorderSide(color: Colors.grey[100]!, width: 1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd').format(
                    DateFormat('dd MMMM yyyy').parse(groupByValue),
                  ),
                  style: const TextStyle(
                      fontSize: 33, fontWeight: FontWeight.bold),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE').format(
                        DateFormat('dd MMMM yyyy').parse(groupByValue),
                      ),
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeMd,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(
                        DateFormat('dd MMMM yyyy').parse(groupByValue),
                      ),
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        color: MyColors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: historyController.resultData
                                .where((element) =>
                                    DateFormat('dd MMMM yyyy').format(
                                        DateTime.parse(
                                            element.transactionDate!)) ==
                                    groupByValue)
                                .fold<int>(
                                  0,
                                  (sum, element) =>
                                      sum +
                                      (element.categoryType == "PENGELUARAN"
                                          ? -element.amount!
                                          : element.amount!),
                                ) <
                            0
                        ? const Color.fromARGB(255, 241, 97, 97)
                        : MyColors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    CurrencyFormat.convertToIdr(
                      historyController.resultData
                          .where((element) =>
                              DateFormat('dd MMMM yyyy').format(
                                  DateTime.parse(element.transactionDate!)) ==
                              groupByValue)
                          .fold<int>(
                            0,
                            (sum, element) =>
                                sum +
                                (element.categoryType == "PENGELUARAN"
                                    ? -element.amount!
                                    : element.amount!),
                          ),
                      0,
                    ),
                    style: const TextStyle(
                      fontSize: MySizes.fontSizeLg,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          itemBuilder: (context, dynamic element) {
            String kategori = element.categoryType!;
            Color warna = kategori == "PENGELUARAN" ? Colors.red : Colors.green;
            String plusminus = kategori == "PENGELUARAN" ? "-" : "+";
            int dataPrice = element.amount ?? 0;
            return Container(
              color: Colors.white,
              margin: EdgeInsets.only(
                bottom: historyController.resultData
                            .where((element2) =>
                                DateFormat('dd MMMM yyyy').format(
                                    DateTime.parse(
                                        element2.transactionDate!)) ==
                                DateFormat('dd MMMM yyyy').format(
                                    DateTime.parse(element.transactionDate!)))
                            .last ==
                        element
                    ? 20
                    : 0,
              ),
              child: ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        spreadRadius: 0.5,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/${element.imageIcon.toLowerCase()}',
                      height: 25,
                      width: 25,
                    ),
                  ),
                ),
                title: Text(
                    kategori == "PENGELUARAN"
                        ? '[${element.expenseFromCategoryName}] ${element.categoryName!}'
                        : element.categoryName!,
                    style: const TextStyle(fontSize: MySizes.fontSizeMd)),
                subtitle: Text(
                  element.note ?? '',
                  style: const TextStyle(
                      color: MyColors.grey, fontSize: MySizes.fontSizeSm),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        plusminus + CurrencyFormat.convertToIdr(dataPrice, 0),
                        style: TextStyle(
                          color: warna,
                          fontSize: MySizes.fontSizeMd,
                        ),
                      ),
                      Text(
                        DateFormat('HH:mm').format(
                          DateTime.parse(element.transactionDate!),
                        ),
                        style: const TextStyle(
                          color: MyColors.grey,
                          fontSize: MySizes.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separator: Divider(
            color: Colors.grey[200],
            thickness: 1,
            height: 1,
          ),
          useStickyGroupSeparators: true,
          floatingHeader: true,
        );
      }
    });
  }
}
