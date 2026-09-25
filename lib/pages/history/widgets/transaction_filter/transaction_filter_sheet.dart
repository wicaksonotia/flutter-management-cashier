import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/pages/history/widgets/transaction_filter/transaction_filter_section.dart';
import 'package:cashier_management/pages/history/widgets/transaction_filter/transaction_filter_summary.dart';
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
  late final HistoryController controller;

  bool get isExpense => widget.selectedType == 2;

  @override
  void initState() {
    super.initState();

    debugPrint('>>> TRANSACTION FILTER SHEET INIT');

    controller = Get.find<HistoryController>();

    debugPrint('>>> HISTORY CONTROLLER FOUND');

    controller.prepareTransactionFilter();

    debugPrint('>>> PREPARE FILTER SELESAI');

    _loadFilterData();
  }

  Future<void> _loadFilterData() async {
    debugPrint('>>> LOAD FILTER DATA');

    debugPrint(
      '>>> selectedType: ${widget.selectedType}',
    );

    debugPrint(
      '>>> isExpense: $isExpense',
    );

    if (isExpense && controller.listCategoryPengeluaran.isEmpty) {
      debugPrint('>>> MEMANGGIL CATEGORY PENGELUARAN');

      await controller.getDataListCategoryPengeluaran();

      debugPrint('>>> CATEGORY PENGELUARAN SELESAI');
    }
  }

  @override
  void dispose() {
    controller.resetTemporaryTransactionFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.84,
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
                () => SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
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
                        outletCount: controller.tempTagCabangKios.length,
                        categoryCount: controller.tempTagCategory.length,
                        showCategory: isExpense,
                      ),
                      const SizedBox(height: 24),
                      _buildOutletSection(),
                      if (isExpense) ...[
                        const SizedBox(height: 26),
                        _buildCategorySection(),
                      ],
                    ],
                  ),
                ),
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
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Material(
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
    );
  }

  // ============================================================
  // OUTLET
  // ============================================================

  Widget _buildOutletSection() {
    return TransactionFilterSection(
      title: 'Cabang / Outlet',
      subtitle: 'Pilih outlet yang ingin ditampilkan',
      icon: Icons.storefront_outlined,
      items: controller.listCategoryPemasukan.toList(),
      selectedValues: controller.tempTagCabangKios.toList(),
      isLoading: controller.isLoadingCategoryPemasukan.value,
      emptyText: 'Belum ada data outlet',
      onSelectAll: controller.selectAllOutlet,
      onToggle: controller.toggleOutlet,
    );
  }

  // ============================================================
  // KATEGORI PENGELUARAN
  // ============================================================

  Widget _buildCategorySection() {
    return TransactionFilterSection(
      title: 'Kategori Pengeluaran',
      subtitle: 'Pilih kategori pengeluaran yang ingin ditampilkan',
      icon: Icons.receipt_long_outlined,
      items: controller.listCategoryPengeluaran.toList(),
      selectedValues: controller.tempTagCategory.toList(),
      isLoading: controller.isLoadingCategoryPengeluaran.value,
      emptyText: 'Belum ada kategori pengeluaran',
      onSelectAll: controller.selectAllCategory,
      onToggle: controller.toggleCategory,
    );
  }

  // ============================================================
  // BOTTOM ACTION
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: MyColors.textSecondary,
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
    controller.resetTemporaryTransactionFilter();

    setState(() {});
  }

  // ============================================================
  // APPLY
  // ============================================================

  Future<void> _apply() async {
    Get.back();

    await controller.applyTransactionFilter(
      isExpense: isExpense,
    );
  }
}
