import 'package:financial_apps/controllers/monitoring_outlet_controller.dart';
import 'package:financial_apps/utils/colors.dart';
import 'package:financial_apps/utils/currency.dart';
import 'package:financial_apps/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final MonitoringOutletController _monitoringOutletController =
      Get.find<MonitoringOutletController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_monitoringOutletController.isLoading.value) {
        return Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      } else {
        Map<String, List<dynamic>> resultDataMap = {};
        for (var item in _monitoringOutletController.resultData) {
          String formattedDate = DateFormat('dd MMMM yyyy')
              .format(DateTime.parse(item.transactionDate!));
          if (!resultDataMap.containsKey(formattedDate)) {
            resultDataMap[formattedDate] = [];
          }
          resultDataMap[formattedDate]!.add(item);
        }
        // resultDataMap.forEach((key, value) {
        // print(
        //     'Date: $key, Transactions: ${value.map((item) => item.toJson()).toList()}');
        // });
        return GroupListView(
          sectionsCount: resultDataMap.keys.toList().length,
          countOfItemInSection: (int section) {
            return resultDataMap.values.toList()[section].length;
          },
          itemBuilder: (BuildContext context, IndexPath index) {
            var items =
                resultDataMap.values.toList()[index.section][index.index];
            return Container(
              color: Colors.white,
              child: ExpansionTile(
                leading: const Icon(Icons.receipt),
                title: Text(
                  '${items.kios.toUpperCase()}-${items.numerator.toString().padLeft(4, '0').toUpperCase()}',
                  style: const TextStyle(fontSize: MySizes.fontSizeMd),
                ),
                subtitle: Text(
                    DateFormat('dd MMM yyyy HH:mm')
                        .format(DateTime.parse(items.transactionDate)),
                    style: const TextStyle(
                      color: MyColors.grey,
                      fontSize: MySizes.fontSizeSm,
                    )),
                trailing: Column(
                  children: [
                    Text(
                      CurrencyFormat.convertToIdr(items.grandTotal, 0),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MySizes.fontSizeMd,
                          color: MyColors.green),
                    ),
                    Text(
                      items.deleteStatus! ? 'Deleted' : '',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: MySizes.fontSizeSm,
                      ),
                    ),
                  ],
                ),
                iconColor: MyColors.green,
                children: [
                  ListTile(
                    title: const Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.details!.length,
                          itemBuilder: (context, detailIndex) {
                            return Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                      items.details[detailIndex].productName ??
                                          'Unknown Product'),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                      '${items.details[detailIndex].quantity}'),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  alignment: Alignment.centerRight,
                                  child: Text(CurrencyFormat.convertToIdr(
                                      items.details[detailIndex].totalPrice,
                                      0)),
                                ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          groupHeaderBuilder: (BuildContext context, int section) {
            return Container(
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
                      DateFormat('dd MMMM yyyy')
                          .parse(resultDataMap.keys.toList()[section]),
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
                          DateFormat('dd MMMM yyyy')
                              .parse(resultDataMap.keys.toList()[section]),
                        ),
                        style: const TextStyle(
                          fontSize: MySizes.fontSizeMd,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(
                          DateFormat('dd MMMM yyyy')
                              .parse(resultDataMap.keys.toList()[section]),
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
                      color: MyColors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      CurrencyFormat.convertToIdr(
                        _monitoringOutletController.resultData
                            .where((element) =>
                                DateFormat('dd MMMM yyyy').format(
                                        DateTime.parse(
                                            element.transactionDate!)) ==
                                    resultDataMap.keys.toList()[section] &&
                                !element.deleteStatus!)
                            .fold<int>(
                              0,
                              (sum, element) => sum + element.grandTotal!,
                            ),
                        0,
                      ),
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeLg,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 2),
          sectionSeparatorBuilder: (context, section) => SizedBox(height: 20),
        );
      }
    });
  }
}
