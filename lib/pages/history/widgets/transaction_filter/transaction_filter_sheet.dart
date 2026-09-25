import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:cashier_management/pages/history/widgets/transaction_filter/transaction_category_filter_page.dart';
import 'package:cashier_management/pages/history/widgets/transaction_filter/transaction_filter_summary.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionFilterSheet extends StatefulWidget {
  final int selectedType;

  const TransactionFilterSheet({
    super.key,
    required this.selectedType,
  });

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  late final HistoryController historyController;
  late final CabangController cabangController;

  @override
  void initState() {
    super.initState();

    historyController = Get.find<HistoryController>();

    if (!Get.isRegistered<CabangController>()) {
      Get.put(CabangController());
    }

    cabangController = Get.find<CabangController>();

    historyController.prepareTransactionFilter();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOutlets();
    });
  }

  @override
  void dispose() {
    historyController.resetTemporaryTransactionFilter();
    super.dispose();
  }

  // ============================================================
  // LOAD OUTLET
  // ============================================================

  Future<void> _loadOutlets() async {
    // Sinkronkan kios dari HistoryController ke CabangController
    if (cabangController.kiosId.value <= 0 &&
        historyController.idKios.value > 0) {
      cabangController.kiosId.value = historyController.idKios.value;

      cabangController.headerNamaKios.value = historyController.namaKios.value;
    }

    if (cabangController.kiosId.value <= 0) {
      return;
    }

    await cabangController.fetchDataListCabangFinancial();
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Future<void> _openCategoryFilter() async {
    final result = await Get.to(
      () => TransactionCategoryFilterPage(
        selectedType: widget.selectedType,
        controller: historyController,
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {});
    }
  }

  // ============================================================
  // OUTLET
  // ============================================================

  Future<void> _openOutletPicker() async {
    await _loadOutlets();

    if (!mounted) return;

    await Get.to(
      () => SelectTableListPage<DataListOutletBranch>(
        title: 'Pilih Outlet',
        isLoading: cabangController.isLoadingList,
        items: cabangController.resultItem.toList(),
        enableSearch: true,
        searchHint: 'Cari outlet...',
        selectionMode: SelectTableSelectionMode.multiple,
        applyLabel: 'Terapkan Outlet',
        showSelectAll: true,
        itemIcon: Icons.storefront_outlined,
        selectedItemIcon: Icons.check_rounded,
        titleBuilder: (item) {
          return item.cabang ?? '-';
        },
        subtitleBuilder: (item) {
          final kode = item.kode ?? '';
          final alamat = item.alamat ?? '';

          if (kode.isEmpty && alamat.isEmpty) {
            return '';
          }

          if (kode.isEmpty) {
            return alamat;
          }

          if (alamat.isEmpty) {
            return kode;
          }

          return '$kode • $alamat';
        },
        isSelected: (item) {
          final id = item.id ?? 0;

          return historyController.tempTagCabangKios.contains(id);
        },
        onItemTap: (item) async {
          final id = item.id ?? 0;

          if (id <= 0) {
            return;
          }

          historyController.toggleOutlet(id);
        },
        selectedCount: historyController.tempTagCabangKios.length,
        onSelectAll: () {
          historyController.selectAllOutlet();
        },
        onApply: () async {
          // Belum request API.
          // Filter diterapkan dari sheet utama.
        },
        onRefresh: () async {
          await cabangController.fetchDataListCabangFinancial();
        },
        emptyTitle: 'Belum ada outlet',
        emptyMessage: 'Belum tersedia data outlet untuk filter transaksi.',
        searchEmptyTitle: 'Outlet tidak ditemukan',
        searchEmptyMessage: 'Tidak ada outlet yang cocok dengan pencarian.',
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .72,
        ),
        decoration: const BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: Obx(
                () {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      16,
                      20,
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TransactionFilterSummary(
                          outletCount:
                              historyController.tempTagCabangKios.length,
                          categoryCount:
                              historyController.tempTagCategory.length,
                          showCategory: true,
                        ),
                        const SizedBox(height: 20),
                        _buildOutletSection(),
                        const SizedBox(height: 20),
                        _buildCategoryNavigation(),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        12,
        14,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: MyColors.divider,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.tune_rounded,
              size: 20,
              color: MyColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Transaksi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: MyColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Atur transaksi yang ingin ditampilkan',
                  style: TextStyle(
                    fontSize: 11,
                    color: MyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: MyColors.surfaceSoft,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(10),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(
                  Icons.close_rounded,
                  size: 19,
                  color: MyColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OUTLET
  // ============================================================

  Widget _buildOutletSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: MyColors.surfaceSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.storefront_outlined,
                size: 18,
                color: MyColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cabang / Outlet',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: MyColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Pilih outlet yang ingin ditampilkan',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: MyColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (historyController.tempTagCabangKios.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: MyColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Text(
                  'Semua',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _buildOutletPicker(),
      ],
    );
  }

  Widget _buildOutletPicker() {
    final count = historyController.tempTagCabangKios.length;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _openOutletPicker,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.storefront_outlined,
              size: 20,
              color: MyColors.primary,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                count == 0 ? 'Semua outlet' : '$count outlet dipilih',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: MyColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: MyColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Widget _buildCategoryNavigation() {
    final count = historyController.tempTagCategory.length;

    final subtitle = count == 0 ? 'Semua kategori' : '$count kategori dipilih';

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: _openCategoryFilter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColors.background,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 20,
                color: MyColors.primary,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kategori Transaksi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: MyColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: MyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: MyColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTION
  // ============================================================

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        16,
      ),
      decoration: const BoxDecoration(
        color: MyColors.surface,
        border: Border(
          top: BorderSide(
            color: MyColors.divider,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _reset,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  46,
                ),
                side: const BorderSide(
                  color: MyColors.border,
                ),
                foregroundColor: MyColors.textSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _apply,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  46,
                ),
                backgroundColor: MyColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Terapkan Filter',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESET
  // ============================================================

  void _reset() {
    historyController.resetTemporaryTransactionFilter();

    setState(() {});
  }

  // ============================================================
  // APPLY
  // ============================================================

  Future<void> _apply() async {
    historyController.tagCabangKios.assignAll(
      historyController.tempTagCabangKios,
    );

    historyController.tagCategory.assignAll(
      historyController.tempTagCategory,
    );

    await historyController.getHistoriesByFilter();

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }
}
