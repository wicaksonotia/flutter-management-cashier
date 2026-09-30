import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/pages/monitoring_outlet/monitoring_summary.dart';
import 'package:cashier_management/pages/monitoring_outlet/monitoring_transaction_card.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final MonitoringOutletController controller =
      Get.find<MonitoringOutletController>();

  Future<void> _refresh() async {
    await controller.getDataByFilter();
  }

  // ============================================================
  // OUTLET SELECTOR
  // ============================================================

  void _showOutletSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return _OutletSelector(
          controller: controller,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: MyColors.primary,
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverToBoxAdapter(
              child: MonitoringSummary(
                controller: controller,
              ),
            ),
            SliverToBoxAdapter(
              child: _buildTransactionHeader(),
            ),
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SliverToBoxAdapter(
                    child: _LoadingTransactions(),
                  );
                }

                if (controller.resultData.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: _EmptyTransaction(),
                  );
                }

                return MonitoringTransactionCard(
                  transactions: controller.resultData,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: MyColors.textPrimary,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      titleSpacing: 0,
      title: const Text(
        'Riwayat Transaksi Per Outlet',
        style: TextStyle(
          fontSize: MySizes.fontSizeHeader,
          fontWeight: FontWeight.w700,
          color: MyColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Muat ulang',
          icon: const Icon(
            Icons.refresh_rounded,
            color: MyColors.textPrimary,
          ),
          onPressed: _refresh,
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        16,
      ),
      child: Column(
        children: [
          // ======================================================
          // OUTLET AKTIF
          // ======================================================

          GestureDetector(
            onTap: _showOutletSelector,
            child: Obx(
              () {
                final selectedOutlet = controller.listOutlet
                    .where(
                      (element) =>
                          element['value'] == controller.idCabangKios.value,
                    )
                    .toList();

                final outletName = selectedOutlet.isNotEmpty
                    ? selectedOutlet.first['nama'] ?? '-'
                    : 'Pilih outlet';

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: MyColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: MyColors.primary.withOpacity(.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          color: MyColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'OUTLET AKTIF',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: MyColors.textMuted,
                                letterSpacing: .7,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              outletName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: MyColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: MyColors.primary,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // ======================================================
          // FILTER BULAN / TANGGAL
          // ======================================================

          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _FilterButton(
                    label: 'Bulan',
                    selected: controller.filterBy.value == 'bulan',
                    onTap: () {
                      controller.setFilter('bulan');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FilterButton(
                    label: 'Tanggal',
                    selected: controller.filterBy.value == 'tanggal',
                    onTap: () {
                      controller.setFilter('tanggal');
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ======================================================
          // PERIODE
          // ======================================================

          Obx(
            () => controller.filterBy.value == 'bulan'
                ? _MonthSelector(
                    controller: controller,
                  )
                : _DateRangeSelector(
                    controller: controller,
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRANSACTION HEADER
  // ============================================================

  Widget _buildTransactionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        20,
        16,
        10,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaksi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Riwayat transaksi outlet',
                  style: TextStyle(
                    fontSize: 12,
                    color: MyColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${controller.resultData.length} transaksi',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: MyColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// FILTER BUTTON
// ================================================================

class _FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? MyColors.primary : MyColors.background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 11,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? MyColors.primary : MyColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : MyColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// MONTH SELECTOR
// ================================================================

class _MonthSelector extends StatelessWidget {
  final MonitoringOutletController controller;

  const _MonthSelector({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 46,
        decoration: BoxDecoration(
          color: MyColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: controller.goToPreviousMonth,
              icon: const Icon(
                Icons.chevron_left_rounded,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  DateFormat(
                    'MMMM yyyy',
                    'id_ID',
                  ).format(
                    controller.monthDate.value,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: controller.goToNextMonth,
              icon: const Icon(
                Icons.chevron_right_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// DATE RANGE SELECTOR
// ================================================================

class _DateRangeSelector extends StatelessWidget {
  final MonitoringOutletController controller;

  const _DateRangeSelector({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: controller.showDialogDateRangePicker,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: MyColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColors.border,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.date_range_rounded,
                size: 19,
                color: MyColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${DateFormat(
                    'dd MMM yyyy',
                    'id_ID',
                  ).format(controller.startDate.value)}'
                  '  -  '
                  '${DateFormat(
                    'dd MMM yyyy',
                    'id_ID',
                  ).format(controller.endDate.value)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: MyColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: MyColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// OUTLET SELECTOR
// ================================================================

class _OutletSelector extends StatelessWidget {
  final MonitoringOutletController controller;

  const _OutletSelector({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20,
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==================================================
              // HANDLE
              // ==================================================

              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: MyColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // TITLE
              // ==================================================

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilih Outlet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lihat transaksi berdasarkan outlet',
                  style: TextStyle(
                    fontSize: 12,
                    color: MyColors.textMuted,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // OUTLET LIST
              // ==================================================

              ...controller.listOutlet.map(
                (outlet) {
                  final int outletId = outlet['value'] as int;

                  final bool selected =
                      controller.idCabangKios.value == outletId;

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        // Jangan gunakan Get.back().
                        // Hanya tutup bottom sheet setelah
                        // proses pergantian outlet selesai.
                        await controller.selectOutlet(
                          outletId,
                        );

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: selected
                              ? MyColors.primaryLight
                              : MyColors.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                selected ? MyColors.primary : MyColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                Icons.storefront_rounded,
                                color: selected
                                    ? MyColors.primary
                                    : MyColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                outlet['nama']?.toString() ?? '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? MyColors.primary
                                      : MyColors.textPrimary,
                                ),
                              ),
                            ),
                            if (selected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: MyColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// LOADING
// ================================================================

class _LoadingTransactions extends StatelessWidget {
  const _LoadingTransactions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        30,
      ),
      child: Column(
        children: List.generate(
          5,
          (index) => Container(
            height: 116,
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// EMPTY STATE
// ================================================================

class _EmptyTransaction extends StatelessWidget {
  const _EmptyTransaction();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        30,
        50,
        30,
        50,
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 34,
              color: MyColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Belum Ada Transaksi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: MyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Belum ada transaksi pada periode yang dipilih.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: MyColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
