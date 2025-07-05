import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/pages/history/confirm_delete.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  final HistoryController historyController = Get.find<HistoryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      historyController.getHistoriesByFilter();
      historyController.getDataListCategoryPemasukan();
      historyController.getDataListCategoryPengeluaran();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (historyController.isLoadingHistory.value) {
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
        Map<String, List<dynamic>> resultDataMap = {};
        for (var item in historyController.resultData) {
          String formattedDate = DateFormat('dd MMMM yyyy')
              .format(DateTime.parse(item.transactionDate!));
          if (!resultDataMap.containsKey(formattedDate)) {
            resultDataMap[formattedDate] = [];
          }
          resultDataMap[formattedDate]!.add(item);
        }

        return GroupListView(
          sectionsCount: resultDataMap.keys.toList().length,
          countOfItemInSection: (int section) {
            return resultDataMap.values.toList()[section].length;
          },
          itemBuilder: (BuildContext context, IndexPath index) {
            var items =
                resultDataMap.values.toList()[index.section][index.index];
            String kategori = items.transactionType ?? "PENGELUARAN";
            Color warna = kategori == "PENGELUARAN" ? Colors.red : Colors.green;
            String plusminus = kategori == "PENGELUARAN" ? "-" : "";
            int dataPrice = items.amount ?? 0;
            return Container(
              color: Colors.white,
              child: kategori == "PEMASUKAN"
                  ? ListTileHistories(
                      warna: warna,
                      items: items,
                      plusminus: plusminus,
                      dataPrice: dataPrice)
                  : Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Get.back();
                              showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    ConfirmDelete(id: items.id!),
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                          SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: const Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                        ],
                      ),
                      child: ListTileHistories(
                          warna: warna,
                          items: items,
                          plusminus: plusminus,
                          dataPrice: dataPrice)),
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
                        DateFormat('EEEE', 'id_ID').format(
                          DateFormat('dd MMMM yyyy')
                              .parse(resultDataMap.keys.toList()[section]),
                        ),
                        style: const TextStyle(
                          fontSize: MySizes.fontSizeMd,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMMM yyyy', 'id_ID').format(
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
                      color: historyController.resultData
                                  .where((element) =>
                                      DateFormat('dd MMMM yyyy').format(
                                          DateTime.parse(
                                              element.transactionDate!)) ==
                                      resultDataMap.keys.toList()[section])
                                  .fold<int>(
                                    0,
                                    (sum, element) =>
                                        sum +
                                        (element.transactionType ==
                                                "PENGELUARAN"
                                            ? -element.amount!
                                            : element.amount!),
                                  ) <
                              0
                          ? const Color.fromARGB(255, 241, 97, 97)
                          : MyColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      CurrencyFormat.convertToIdr(
                        historyController.resultData
                            .where((element) =>
                                DateFormat('dd MMMM yyyy').format(
                                    DateTime.parse(element.transactionDate!)) ==
                                resultDataMap.keys.toList()[section])
                            .fold<int>(
                              0,
                              (sum, element) =>
                                  sum +
                                  (element.transactionType == "PENGELUARAN"
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
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 2),
          sectionSeparatorBuilder: (context, section) =>
              const SizedBox(height: 20),
        );
      }
    });
  }
}

class ListTileHistories extends StatelessWidget {
  const ListTileHistories({
    super.key,
    required this.warna,
    required this.items,
    required this.plusminus,
    required this.dataPrice,
  });

  final Color warna;
  final dynamic items;
  final String plusminus;
  final int dataPrice;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: warna,
        ),
        padding: const EdgeInsets.all(3),
        child: Icon(
          Icons.arrow_downward,
          color: Colors.white,
        ),
      ),
      title: Text('${items.cabang} - ${items.transactionName!}',
          style: const TextStyle(fontSize: MySizes.fontSizeMd)),
      subtitle: Text(
        items.note ?? "",
        style:
            const TextStyle(color: MyColors.grey, fontSize: MySizes.fontSizeSm),
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
                DateTime.parse(items.transactionDate!),
              ),
              style: const TextStyle(
                color: MyColors.grey,
                fontSize: MySizes.fontSizeSm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
