import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/pages/history/chips_category_pemasukan.dart';
import 'package:cashier_management/pages/history/chips_category_pengeluaran.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FilterReport extends StatefulWidget {
  final HistoryController historyController;
  const FilterReport(this.historyController, {super.key});

  @override
  State<FilterReport> createState() => _FilterReportState();
}

class _FilterReportState extends State<FilterReport> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .33,
      maxChildSize: 1,
      minChildSize: .2,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTabController(
                  length: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(text: 'Pengeluaran'),
                          Tab(text: 'Pemasukan'),
                        ],
                      ),
                      const Gap(20),
                      SizedBox(
                        height: widget.historyController.listCategoryPengeluaran
                                .length *
                            20,
                        child: TabBarView(
                          children: [
                            ChipsCategoryPengeluaran(widget.historyController),
                            ChipsCategoryPemasukan(widget.historyController),
                          ],
                        ),
                      ),
                      const Gap(10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
