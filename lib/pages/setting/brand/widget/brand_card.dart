import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/controllers/kios_controller.dart';
import 'package:cashier_management/models/kios_model.dart';
import 'package:cashier_management/pages/setting/brand/widget/brand_financial_info.dart';
import 'package:cashier_management/pages/setting/brand/widget/brand_logo.dart';
import 'package:cashier_management/pages/setting/brand/widget/brand_popup_menu.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/management_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
                const Gap(14),
                BrandFinancialInfo(
                  quotation: quotation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentity(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrandLogo(logo: quotation.logo),
        const Gap(12),
        Expanded(
          child: Stack(
            children: [
              // Konten kanan
              SizedBox(
                height: 68, // tinggi sama dengan logo
                child: Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quotation.kios ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MyColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        quotation.keterangan?.trim().isNotEmpty == true
                            ? quotation.keterangan!
                            : 'Tidak ada keterangan brand',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MyColors.textSecondary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                      const Spacer(),
                      _buildMetaRow(context),
                    ],
                  ),
                ),
              ),

              // Popup tetap pojok kanan atas
              Positioned(
                top: -6,
                right: -8,
                child: BrandPopupMenu(
                  isActive: isActive,
                  canDelete: !hasBranch && !hasFinancialRecord,
                  onEdit: () => _editBrand(context),
                  onStatus: () => _changeStatus(context),
                  onManageOutlet: () => _manageOutlet(context),
                  onDelete: () => _deleteBrand(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
          onTap: () => _manageOutlet(context),
        ),
      ],
    );
  }

  void _editBrand(BuildContext context) {
    controller.editKios(quotation);

    Navigator.of(context).pushNamed(
      RouterClass.addoutlet,
    );
  }

  void _manageOutlet(BuildContext context) {
    final idKios = quotation.idKios ?? 0;

    if (idKios <= 0) return;

    cabangController.kiosId.value = idKios;
    cabangController.headerNamaKios.value = quotation.kios ?? '';

    cabangController.fetchDataListCabangFinancial();

    Navigator.of(context).pushNamed(
      RouterClass.branch,
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
              const Gap(5),
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
