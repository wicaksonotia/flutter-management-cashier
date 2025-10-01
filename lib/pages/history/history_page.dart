import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/pages/change_outlet_page.dart';
import 'package:cashier_management/pages/history/filter.dart';
import 'package:cashier_management/pages/history/filter_date_range.dart';
import 'package:cashier_management/pages/history/filter_month.dart';
import 'package:cashier_management/pages/history/history_list.dart';
import 'package:cashier_management/pages/history/total_transaction.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/lists.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final HistoryController _historyController = Get.find<HistoryController>();
  final KiosController _kiosController = Get.find<KiosController>();
  int? groupValue = 1;

  Future<void> _refresh() async {
    _historyController.getHistoriesByFilter();
    _historyController.getDataListCategoryPemasukan();
    _historyController.getDataListCategoryPengeluaran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Belanja',
              style: TextStyle(
                  fontSize: MySizes.fontSizeHeader,
                  fontWeight: FontWeight.bold),
            ),
            Obx(() {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    builder: (context) => const ChangeOutletPage(),
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      _kiosController.namaKios.value,
                      style: const TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const Gap(5),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.black54, size: 15),
                  ],
                ),
              );
            }),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => FilterReport(_historyController),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 0.5,
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.width * .5,
                    height: context.height * .05,
                    child: Row(
                      children: List.generate(
                        filterKategori.length,
                        (index) => Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                groupValue = index;
                              });
                              _historyController.filterBy.value =
                                  filterKategori[index]['value']!;
                              _historyController.getHistoriesByFilter();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    width: 0.5,
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Center(
                                child: Text(
                                  filterKategori[index]['nama']!,
                                  style: TextStyle(
                                    color: groupValue == index
                                        ? MyColors.primary
                                        : Colors.black,
                                    fontWeight: groupValue == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // NEXT AND PREVIOUS MONTH YEAR
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: context.height * 0.05,
                    child: Obx(() =>
                        _historyController.filterBy.value == 'bulan'
                            ? const FilterMonth()
                            : const FilterDateRange()),
                  ),
                ],
              ),
            ),

            const Gap(5),
            // INCOME, EXPENSE, AND BALANCE
            const TotalTransaction(),
            const Gap(5),
            const Expanded(
              child: HistoryList(),
            ),
          ],
        ),
      ),
    );
  }
}
