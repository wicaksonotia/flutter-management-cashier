import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/models/history_model.dart';
import 'package:cashier_management/pages/history/transaction_form.dart';
import 'package:cashier_management/pages/history/widgets/finance_empty_state.dart';
import 'package:cashier_management/pages/history/widgets/finance_filter_bar.dart';
import 'package:cashier_management/pages/history/widgets/finance_header.dart';
import 'package:cashier_management/pages/history/widgets/finance_loading_state.dart';
import 'package:cashier_management/pages/history/widgets/finance_segmented.dart';
import 'package:cashier_management/pages/history/widgets/finance_summary_card.dart';
import 'package:cashier_management/pages/history/widgets/finance_transaction_card.dart';
import 'package:cashier_management/pages/history/widgets/transaction_filter/transaction_category_filter_page.dart';
import 'package:cashier_management/pages/history/widgets/transaction_filter/transaction_filter_sheet.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({
    super.key,
  });

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final HistoryController historyController;
  late final TransactionController transactionController;

  int selectedType = 0;

  @override
  void initState() {
    super.initState();

    historyController = Get.find<HistoryController>();
    transactionController = Get.find<TransactionController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  // ================================================================
  // LOAD DATA
  // ================================================================

  Future<void> _loadData() async {
    await historyController.getHistoriesByFilter();

    await Future.wait([
      historyController.getDataListCategoryPemasukan(),
      historyController.getDataListCategoryPengeluaran(),
    ]);
  }

  Future<void> _refresh() async {
    await historyController.getHistoriesByFilter();

    await Future.wait([
      historyController.getDataListCategoryPemasukan(),
      historyController.getDataListCategoryPengeluaran(),
    ]);
  }

  // ================================================================
  // FILTER TRANSACTION TYPE
  // ================================================================

  List<DataHistory> _filteredTransactions() {
    final data = historyController.resultData.toList();

    if (selectedType == 1) {
      return data
          .where(
            (item) => item.transactionType == 'PEMASUKAN',
          )
          .toList();
    }

    if (selectedType == 2) {
      return data
          .where(
            (item) => item.transactionType == 'PENGELUARAN',
          )
          .toList();
    }

    return data;
  }

  // ================================================================
  // PERIOD LABEL
  // ================================================================

  String _periodLabel() {
    if (historyController.filterBy.value == 'tanggal') {
      final start = historyController.startDate.value;
      final end = historyController.endDate.value;

      final formatter = DateFormat(
        'dd MMM yyyy',
        'id_ID',
      );

      if (DateUtils.isSameDay(start, end)) {
        return formatter.format(start);
      }

      return '${formatter.format(start)} - '
          '${formatter.format(end)}';
    }

    final date = historyController.singleDate.value;

    return DateFormat(
      'MMMM yyyy',
      'id_ID',
    ).format(date);
  }

  // ================================================================
  // SEGMENTED
  // ================================================================

  void _changeType(int index) {
    setState(() {
      selectedType = index;
    });
  }

  // ================================================================
  // ADD TRANSACTION
  // ================================================================

  Future<void> _openAddTransaction() async {
    transactionController.resetForm();

    await transactionController.changeTransactionType(false);

    if (!Get.isRegistered<CabangController>()) {
      Get.put(CabangController());
    }

    if (!mounted) return;

    final result = await Get.to(
      () => TransactionForm(),
    );

    if (result == true) {
      await _loadData();
    }
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.background,
      drawer: const custom_drawer.NavigationDrawer(),

      // ============================================================
      // ADD TRANSACTION
      // ============================================================

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MyColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: _openAddTransaction,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: Obx(
        () {
          final transactions = _filteredTransactions();

          return CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ======================================================
              // HEADER + SUMMARY
              // ======================================================

              FinanceBackground(
                brandName: historyController.namaKios.value,
                isLoading: historyController.isLoadingHistory.value,
                onMenu: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                onReload: _refresh,
                child: FinanceSummaryCard(
                  income: historyController.totalIncome.value,
                  expense: historyController.totalExpense.value,
                  balance: historyController.totalBalance.value,
                ),
              ),

              // ======================================================
              // SPACE
              // ======================================================

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 22,
                ),
              ),

              // ======================================================
              // SEGMENTED
              // ======================================================

              SliverToBoxAdapter(
                child: FinanceSegmented(
                  selectedIndex: selectedType,
                  onChanged: _changeType,
                ),
              ),

              // ======================================================
              // FILTER
              // ======================================================

              SliverToBoxAdapter(
                child: FinanceFilterBar(
                  periodLabel: _periodLabel(),
                  filterBy: historyController.filterBy.value,
                  onPeriodTap: _showPeriodMenu,
                  onFilterTap: _showFilterInfo,
                ),
              ),

              // ======================================================
              // LOADING
              // ======================================================

              if (historyController.isLoadingHistory.value)
                const SliverToBoxAdapter(
                  child: FinanceLoadingState(),
                )

              // ======================================================
              // EMPTY
              // ======================================================

              else if (transactions.isEmpty)
                const SliverToBoxAdapter(
                  child: FinanceEmptyState(),
                )

              // ======================================================
              // TRANSACTION LIST
              // ======================================================

              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    4,
                    16,
                    110,
                  ),
                  sliver: SliverList.builder(
                    itemCount: transactions.length,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final item = transactions[index];

                      final currentDate = _transactionDateKey(item);

                      final previousDate = index > 0
                          ? _transactionDateKey(
                              transactions[index - 1],
                            )
                          : null;

                      final showDateHeader =
                          index == 0 || currentDate != previousDate;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDateHeader)
                            _FinanceDateDivider(
                              label: _transactionDateLabel(
                                item,
                              ),
                            ),
                          FinanceTransactionCard(
                            data: item,
                            onEdit: item.id == null
                                ? null
                                : () => _editTransaction(item),
                            onDelete: item.id == null
                                ? null
                                : () => _confirmDelete(item.id!),
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ================================================================
  // PERIOD MENU
  // ================================================================

  void _showPeriodMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Obx(
            () {
              final selectedFilter = historyController.filterBy.value;

              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: MyColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Periode laporan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: MyColors.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ==================================================
                    // BULAN
                    // ==================================================

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: MyColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: MyColors.primary,
                        ),
                      ),
                      title: const Text(
                        'Bulan',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: MyColors.textPrimary,
                        ),
                      ),
                      subtitle: const Text(
                        'Tampilkan transaksi berdasarkan bulan',
                        style: TextStyle(
                          fontSize: 12,
                          color: MyColors.textSecondary,
                        ),
                      ),
                      trailing: selectedFilter == 'bulan'
                          ? Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: MyColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: MyColors.primary,
                              ),
                            )
                          : null,
                      onTap: () async {
                        Get.back();

                        historyController.filterBy.value = 'bulan';

                        historyController.monthYear.value =
                            '${historyController.singleDate.value.month}'
                            '-'
                            '${historyController.singleDate.value.year}';

                        await historyController.getHistoriesByFilter();
                      },
                    ),

                    const SizedBox(height: 4),

                    // ==================================================
                    // RENTANG TANGGAL
                    // ==================================================

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: MyColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.date_range_rounded,
                          color: MyColors.primary,
                        ),
                      ),
                      title: const Text(
                        'Rentang tanggal',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: MyColors.textPrimary,
                        ),
                      ),
                      subtitle: const Text(
                        'Pilih tanggal awal dan akhir',
                        style: TextStyle(
                          fontSize: 12,
                          color: MyColors.textSecondary,
                        ),
                      ),
                      trailing: selectedFilter == 'tanggal'
                          ? Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: MyColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: MyColors.primary,
                              ),
                            )
                          : null,
                      onTap: () async {
                        Get.back();

                        historyController.filterBy.value = 'tanggal';

                        await historyController.showDialogDateRangePicker();
                      },
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ================================================================
  // FILTER INFO
  // ================================================================

  void _showFilterInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) {
        return TransactionFilterSheet(
          selectedType: selectedType,
        );
      },
    );
  }

  // ================================================================
  // DELETE
  // ================================================================

  Future<void> _confirmDelete(int id) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Hapus transaksi?',
      message: 'Transaksi yang dihapus tidak akan tampil lagi pada laporan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      icon: Icons.delete_outline_rounded,
      type: AppConfirmType.danger,
    );

    if (!confirmed) return;

    await historyController.delete(id);
  }

  // ================================================================
  // TRANSACTION DATE KEY
  // ================================================================

  String _transactionDateKey(
    DataHistory item,
  ) {
    if (item.transactionDate == null || item.transactionDate!.trim().isEmpty) {
      return 'Tanpa tanggal';
    }

    try {
      final date = DateTime.parse(
        item.transactionDate!,
      );

      return DateFormat(
        'yyyy-MM-dd',
      ).format(date);
    } catch (_) {
      return 'Tanpa tanggal';
    }
  }

  // ================================================================
  // TRANSACTION DATE LABEL
  // ================================================================

  String _transactionDateLabel(
    DataHistory item,
  ) {
    if (item.transactionDate == null || item.transactionDate!.trim().isEmpty) {
      return 'Tanpa tanggal';
    }

    try {
      final date = DateTime.parse(
        item.transactionDate!,
      );

      return DateFormat(
        'EEEE, dd MMMM yyyy',
        'id_ID',
      ).format(date);
    } catch (_) {
      return item.transactionDate!;
    }
  }

  // ================================================================
  // EDIT
  // ================================================================

  void _editTransaction(
    DataHistory data,
  ) {
    debugPrint(
      'Edit transaksi id: ${data.id}',
    );
  }
}

// ==================================================================
// DATE DIVIDER
// ==================================================================

class _FinanceDateDivider extends StatelessWidget {
  final String label;

  const _FinanceDateDivider({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        2,
        14,
        2,
        8,
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: MyColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: MyColors.textPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: MyColors.divider,
            ),
          ),
        ],
      ),
    );
  }
}
