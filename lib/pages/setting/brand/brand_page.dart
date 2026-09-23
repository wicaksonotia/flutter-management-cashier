import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/database/api_endpoints.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:cashier_management/utils/management_header.dart';
import 'package:cashier_management/utils/management_status_badge.dart';
import 'package:cashier_management/pages/navigation_drawer.dart'
    as custom_drawer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  late final KiosController kiosController;
  late final CabangController cabangController;

  @override
  void initState() {
    super.initState();

    kiosController = Get.isRegistered<KiosController>()
        ? Get.find<KiosController>()
        : Get.put(KiosController());

    cabangController = Get.isRegistered<CabangController>()
        ? Get.find<CabangController>()
        : Get.put(CabangController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      kiosController.fetchDataListKiosFinancial();
    });
  }

  Future<void> _refresh() async {
    await kiosController.fetchDataListKiosFinancial();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const custom_drawer.NavigationDrawer(),
      backgroundColor: MyColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ManagementHeader(
              title: 'Management Brand',
              subtitle: 'Kelola brand, outlet, dan informasi keuangan',
              addLabel: 'Tambah Brand',
              onAddTap: _addBrand,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (kiosController.isLoadingFinancialKios.value) {
                  return const _BrandLoadingState();
                }

                return RefreshIndicator(
                  color: MyColors.primary,
                  backgroundColor: MyColors.surface,
                  onRefresh: _refresh,
                  child: _buildContent(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // CONTENT
  // ==========================================================================

  Widget _buildContent() {
    final data = kiosController.resultDataKios;

    if (data.isEmpty) {
      return const _EmptyBrandState();
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        24,
      ),
      children: [
        _buildSummary(data),
        const SizedBox(height: 18),
        _buildSectionHeader(data.length),
        const SizedBox(height: 10),
        ...List.generate(
          data.length,
          (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == data.length - 1 ? 0 : 12,
              ),
              child: BrandCard(
                quotation: data[index],
                controller: kiosController,
                cabangController: cabangController,
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // SUMMARY
  // ==========================================================================

  Widget _buildSummary(List<KiosModel> data) {
    final activeCount = data
        .where(
          (item) => item.isActive == true,
        )
        .length;

    final totalBranch = data.fold<int>(
      0,
      (sum, item) => sum + (item.totalCabang ?? 0),
    );

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.storefront_outlined,
            label: 'Total Brand',
            value: '${data.length}',
            iconColor: MyColors.primary,
            backgroundColor: MyColors.primaryLight,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            icon: Icons.check_circle_outline_rounded,
            label: 'Aktif',
            value: '$activeCount',
            iconColor: MyColors.success,
            backgroundColor: MyColors.successBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            icon: Icons.account_tree_outlined,
            label: 'Outlet',
            value: '$totalBranch',
            iconColor: MyColors.info,
            backgroundColor: MyColors.infoBg,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SECTION HEADER
  // ==========================================================================

  Widget _buildSectionHeader(int total) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Daftar Brand',
            style: TextStyle(
              color: MyColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: MyColors.surfaceSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$total brand',
            style: const TextStyle(
              color: MyColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // ADD BRAND
  // ==========================================================================

  void _addBrand() {
    kiosController.clearOutletController();

    Navigator.of(context).pushNamed(
      RouterClass.addoutlet,
    );
  }
}

// ============================================================================
// BRAND CARD
// ============================================================================

class BrandCard extends StatelessWidget {
  final KiosModel quotation;
  final KiosController controller;
  final CabangController cabangController;

  const BrandCard({
    super.key,
    required this.quotation,
    required this.controller,
    required this.cabangController,
  });

  bool get isActive => quotation.isActive ?? false;

  bool get hasBranch => (quotation.totalCabang ?? 0) > 0;

  bool get hasFinancialRecord {
    return (quotation.totalIncome ?? 0) != 0 ||
        (quotation.totalExpense ?? 0) != 0 ||
        (quotation.totalBalance ?? 0) != 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MyColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.textPrimary.withValues(alpha: .025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () => _editBrand(context),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIdentity(context),
                const SizedBox(height: 14),
                _buildFinanceSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // IDENTITY
  // ==========================================================================

  Widget _buildIdentity(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BrandLogo(
          logo: quotation.logo,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      quotation.kios ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MyColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  _buildMenu(context),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                quotation.keterangan?.trim().isNotEmpty == true
                    ? quotation.keterangan!
                    : 'Tidak ada keterangan brand',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: MyColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 9),
              _buildMetaRow(context),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // META
  // ==========================================================================

  Widget _buildMetaRow(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 6,
      children: [
        ManagementStatusBadge(
          active: isActive,
          activeLabel: 'Aktif',
          inactiveLabel: 'Nonaktif',
        ),
        _MetaBadge(
          icon: Icons.account_tree_outlined,
          label: '${quotation.totalCabang ?? 0} Outlet',
          color: MyColors.info,
          background: MyColors.infoBg,
          onTap: () => _openBranch(context),
        ),
      ],
    );
  }

  // ==========================================================================
  // MENU
  // ==========================================================================

  Widget _buildMenu(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Aksi',
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _editBrand(context);
            break;
          case 'status':
            _changeStatus(context);
            break;
          case 'branch':
            _addBranch(context);
            break;
          case 'delete':
            _deleteBrand(context);
            break;
        }
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 170,
      ),
      icon: const Icon(
        Icons.more_horiz_rounded,
        size: 21,
        color: MyColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: MyColors.surface,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: _PopupMenuItemContent(
            icon: Icons.edit_outlined,
            label: 'Edit Brand',
          ),
        ),
        PopupMenuItem(
          value: 'status',
          child: _PopupMenuItemContent(
            icon: isActive
                ? Icons.pause_circle_outline_rounded
                : Icons.play_circle_outline_rounded,
            label: isActive ? 'Nonaktifkan' : 'Aktifkan',
          ),
        ),
        const PopupMenuItem(
          value: 'branch',
          child: _PopupMenuItemContent(
            icon: Icons.add_business_outlined,
            label: 'Tambah Outlet',
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          enabled: !hasBranch && !hasFinancialRecord,
          child: _PopupMenuItemContent(
            icon: Icons.delete_outline_rounded,
            label: 'Hapus Brand',
            color: !hasBranch && !hasFinancialRecord
                ? MyColors.error
                : MyColors.disabledText,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // FINANCE
  // ==========================================================================

  Widget _buildFinanceSection() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: MyColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: MyColors.divider,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FinancialInfo(
              icon: Icons.arrow_downward_rounded,
              label: 'Pemasukan',
              value: quotation.totalIncome ?? 0,
              iconColor: MyColors.success,
              backgroundColor: MyColors.successBg,
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _FinancialInfo(
              icon: Icons.arrow_upward_rounded,
              label: 'Pengeluaran',
              value: quotation.totalExpense ?? 0,
              iconColor: MyColors.error,
              backgroundColor: MyColors.errorBg,
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _FinancialInfo(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Saldo',
              value: quotation.totalBalance ?? 0,
              iconColor: MyColors.primary,
              backgroundColor: MyColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: MyColors.divider,
    );
  }

  // ==========================================================================
  // ACTIONS
  // ==========================================================================

  void _editBrand(BuildContext context) {
    controller.editKios(quotation);

    Navigator.of(context).pushNamed(
      RouterClass.addoutlet,
    );
  }

  void _openBranch(BuildContext context) {
    final idKios = quotation.idKios ?? 0;

    if (idKios <= 0) return;

    cabangController.kiosId.value = idKios;
    cabangController.headerNamaKios.value = quotation.kios ?? '';

    cabangController.fetchDataListCabangFinancial();

    Navigator.of(context).pushNamed(
      RouterClass.branch,
    );
  }

  void _addBranch(BuildContext context) {
    final idKios = quotation.idKios ?? 0;

    if (idKios <= 0) return;

    cabangController.kiosId.value = idKios;
    cabangController.headerNamaKios.value = quotation.kios ?? '';
    cabangController.branchId.value = 0;

    Navigator.of(context).pushNamed(
      RouterClass.addbranch,
    );
  }

  Future<void> _changeStatus(BuildContext context) async {
    final newStatus = !isActive;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: newStatus ? 'Aktifkan Brand' : 'Nonaktifkan Brand',
      message: newStatus
          ? 'Brand "${quotation.kios ?? '-'}" akan diaktifkan.'
          : 'Brand "${quotation.kios ?? '-'}" akan dinonaktifkan.',
      confirmText: newStatus ? 'Aktifkan' : 'Nonaktifkan',
      cancelText: 'Batal',
      icon:
          newStatus ? Icons.check_circle_outline_rounded : Icons.block_outlined,
      type: newStatus ? AppConfirmType.success : AppConfirmType.warning,
    );

    if (!confirmed) return;

    final idKios = quotation.idKios ?? 0;

    if (idKios <= 0) return;

    await controller.updateStatusOutlet(
      idKios,
      newStatus,
    );
  }

  Future<void> _deleteBrand(BuildContext context) async {
    if (hasBranch) {
      _showMessage(
        context,
        'Brand tidak dapat dihapus karena masih memiliki outlet.',
        isError: true,
      );
      return;
    }

    if (hasFinancialRecord) {
      _showMessage(
        context,
        'Brand tidak dapat dihapus karena masih memiliki data keuangan.',
        isError: true,
      );
      return;
    }

    final idKios = quotation.idKios ?? 0;

    if (idKios <= 0) return;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Hapus Brand',
      message: 'Brand "${quotation.kios ?? '-'}" akan dihapus. '
          'Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      icon: Icons.delete_outline_rounded,
      type: AppConfirmType.danger,
    );

    if (!confirmed) return;

    await controller.deleteOutlet(idKios);
  }

  void _showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? MyColors.error : MyColors.primary,
      ),
    );
  }
}

// ============================================================================
// BRAND LOGO
// ============================================================================

class _BrandLogo extends StatelessWidget {
  final String? logo;

  const _BrandLogo({
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: logo != null && logo!.trim().isNotEmpty
          ? Image.network(
              '${ApiEndPoints.ipPublic}images/logo/$logo',
              fit: BoxFit.contain,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return const _LogoPlaceholder();
              },
            )
          : const _LogoPlaceholder(),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.storefront_outlined,
        size: 29,
        color: MyColors.textMuted,
      ),
    );
  }
}

// ============================================================================
// META BADGE
// ============================================================================

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color background;
  final VoidCallback? onTap;

  const _MetaBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: color,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// FINANCIAL INFO
// ============================================================================

class _FinancialInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color iconColor;
  final Color backgroundColor;

  const _FinancialInfo({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icon,
                size: 12,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: MyColors.textMuted,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          CurrencyFormat.convertToIdr(
            value,
            0,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: MyColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SUMMARY CARD
// ============================================================================

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color backgroundColor;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 17,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColors.textMuted,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// POPUP MENU ITEM
// ============================================================================

class _PopupMenuItemContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _PopupMenuItemContent({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? MyColors.textPrimary;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: itemColor,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: itemColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// LOADING STATE
// ============================================================================

class _BrandLoadingState extends StatelessWidget {
  const _BrandLoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        24,
      ),
      children: [
        Row(
          children: const [
            Expanded(
              child: _ShimmerBox(
                width: double.infinity,
                height: 62,
                borderRadius: 14,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ShimmerBox(
                width: double.infinity,
                height: 62,
                borderRadius: 14,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ShimmerBox(
                width: double.infinity,
                height: 62,
                borderRadius: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: const [
            _ShimmerBox(
              width: 90,
              height: 13,
              borderRadius: 6,
            ),
            Spacer(),
            _ShimmerBox(
              width: 48,
              height: 22,
              borderRadius: 8,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const _BrandCardShimmer(),
        SizedBox(height: 12),
        const _BrandCardShimmer(),
        SizedBox(height: 12),
        const _BrandCardShimmer(),
      ],
    );
  }
}

class _BrandCardShimmer extends StatelessWidget {
  const _BrandCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.surfaceSoft,
      highlightColor: MyColors.surface,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 145,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 55,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            width: 70,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyColors.surfaceSoft,
      highlightColor: MyColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: MyColors.surfaceSoft,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class _EmptyBrandState extends StatelessWidget {
  const _EmptyBrandState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .28,
        ),
        Container(
          width: 68,
          height: 68,
          margin: const EdgeInsets.symmetric(
            horizontal: 80,
          ),
          decoration: BoxDecoration(
            color: MyColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.storefront_outlined,
            size: 32,
            color: MyColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Belum ada brand',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tambahkan brand untuk mulai mengelola outlet dan keuangan.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.textSecondary,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
