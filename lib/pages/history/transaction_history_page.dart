import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/models/history_model.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:cashier_management/pages/history/widgets/add_transaction_sheet.dart';
import 'package:cashier_management/pages/history/widgets/finance_empty_state.dart';
import 'package:cashier_management/pages/history/widgets/finance_filter_bar.dart';
import 'package:cashier_management/pages/history/widgets/finance_header.dart';
import 'package:cashier_management/pages/history/widgets/finance_loading_state.dart';
import 'package:cashier_management/pages/history/widgets/finance_segmented.dart';
import 'package:cashier_management/pages/history/widgets/finance_summary_card.dart';
import 'package:cashier_management/pages/history/widgets/finance_transaction_card.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

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

  Future<void> _loadData() async {
    await historyController.getHistoriesByFilter();

    historyController.getDataListCategoryPemasukan();
    historyController.getDataListCategoryPengeluaran();
  }

  Future<void> _refresh() async {
    await historyController.getHistoriesByFilter();

    historyController.getDataListCategoryPemasukan();
    historyController.getDataListCategoryPengeluaran();
  }

  List<dynamic> _filteredTransactions() {
    final data = historyController.resultData.toList();

    if (selectedType == 1) {
      return data.where((item) => item.transactionType == 'PEMASUKAN').toList();
    }

    if (selectedType == 2) {
      return data
          .where((item) => item.transactionType == 'PENGELUARAN')
          .toList();
    }

    return data;
  }

  String _periodLabel() {
    if (historyController.filterBy.value == 'tanggal') {
      final start = historyController.startDate.value;
      final end = historyController.endDate.value;

      final formatter = DateFormat('dd MMM yyyy', 'id_ID');

      if (DateUtils.isSameDay(start, end)) {
        return formatter.format(start);
      }

      return '${formatter.format(start)} - ${formatter.format(end)}';
    }

    final date = historyController.singleDate.value;

    return DateFormat('MMMM yyyy', 'id_ID').format(date);
  }

  void _changeType(int index) {
    setState(() {
      selectedType = index;
    });
  }

  void _openAddTransaction() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.35),
      builder: (_) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.background,
      drawer: const custom_drawer.NavigationDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MyColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: _openAddTransaction,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(
        () {
          final transactions = _filteredTransactions();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: FinanceHeader(
                  brandName: historyController.namaKios.value,
                  isLoading: historyController.isLoadingHistory.value,
                  onReload: _refresh,
                  onMenu: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: FinanceSummaryCard(
                  income: historyController.totalIncome.value,
                  expense: historyController.totalExpense.value,
                  balance: historyController.totalBalance.value,
                ),
              ),
              SliverToBoxAdapter(
                child: FinanceSegmented(
                  selectedIndex: selectedType,
                  onChanged: _changeType,
                ),
              ),
              SliverToBoxAdapter(
                child: FinanceFilterBar(
                  periodLabel: _periodLabel(),
                  filterBy: historyController.filterBy.value,
                  onPeriodTap: _showPeriodMenu,
                  onFilterTap: _showFilterInfo,
                ),
              ),
              if (historyController.isLoadingHistory.value)
                const SliverToBoxAdapter(
                  child: FinanceLoadingState(),
                )
              else if (transactions.isEmpty)
                const SliverToBoxAdapter(
                  child: FinanceEmptyState(),
                )
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
                    itemBuilder: (context, index) {
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
                              label: _transactionDateLabel(item),
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

                    // BULAN
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

                        // Pastikan kembali ke mode bulan.
                        historyController.filterBy.value = 'bulan';

                        // Sinkronkan monthYear dengan bulan aktif.
                        historyController.monthYear.value =
                            '${historyController.singleDate.value.month}'
                            '-'
                            '${historyController.singleDate.value.year}';

                        await historyController.getHistoriesByFilter();
                      },
                    ),

                    const SizedBox(height: 4),

                    // RENTANG TANGGAL
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

  void _showFilterInfo() {
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
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
                const Icon(
                  Icons.tune_rounded,
                  size: 32,
                  color: MyColors.primary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Filter transaksi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: MyColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Filter kategori dan outlet akan mengikuti '
                  'filter yang sudah tersedia pada laporan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: MyColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

  String _transactionDateKey(dynamic item) {
    if (item.transactionDate == null || item.transactionDate!.trim().isEmpty) {
      return 'Tanpa tanggal';
    }

    try {
      final date = DateTime.parse(item.transactionDate!);

      return DateFormat(
        'yyyy-MM-dd',
      ).format(date);
    } catch (_) {
      return 'Tanpa tanggal';
    }
  }

  String _transactionDateLabel(dynamic item) {
    if (item.transactionDate == null || item.transactionDate!.trim().isEmpty) {
      return 'Tanpa tanggal';
    }

    try {
      final date = DateTime.parse(item.transactionDate!);

      return DateFormat(
        'EEEE, dd MMMM yyyy',
        'id_ID',
      ).format(date);
    } catch (_) {
      return item.transactionDate!;
    }
  }

  void _editTransaction(DataHistory data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.35),
      builder: (_) => const AddTransactionSheet(),
    );
  }
}

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
