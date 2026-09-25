import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:cashier_management/pages/setting/branch/widget/branch_financial_info.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/app_popup_menu.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/management_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BranchCard extends StatelessWidget {
  final DataListOutletBranch quotation;
  final CabangController controller;

  const BranchCard({
    super.key,
    required this.quotation,
    required this.controller,
  });

  bool get isActive => quotation.status ?? false;

  bool get hasFinancialRecord {
    final details = quotation.details;

    if (details == null) return false;

    return (details.income ?? 0) != 0 ||
        (details.expense ?? 0) != 0 ||
        (details.balance ?? 0) != 0;
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
          onTap: () => _editOutlet(),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIdentity(context),
                const SizedBox(height: 14),
                BranchFinancialInfo(
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
        Expanded(
          child: SizedBox(
            height: 58,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quotation.cabang ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quotation.alamat?.trim().isNotEmpty == true
                      ? quotation.alamat!
                      : 'Tidak ada alamat outlet',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MyColors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
                const Spacer(),
                ManagementStatusBadge(
                  active: isActive,
                  activeLabel: 'Aktif',
                  inactiveLabel: 'Nonaktif',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildMenu(context),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return AppPopupMenu(
      items: [
        const AppPopupMenuItem(
          value: 'edit',
          label: 'Edit Outlet',
          icon: Icons.edit_outlined,
        ),
        AppPopupMenuItem(
          value: 'status',
          label: isActive ? 'Nonaktifkan' : 'Aktifkan',
          icon: isActive
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded,
        ),
        AppPopupMenuItem(
          value: 'delete',
          label: 'Hapus Outlet',
          icon: Icons.delete_outline_rounded,
          color: MyColors.error,
          enabled: !hasFinancialRecord,
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _editOutlet();
            break;
          case 'status':
            _changeStatus(context);
            break;
          case 'delete':
            _deleteOutlet(context);
            break;
        }
      },
    );
  }

  void _editOutlet() {
    controller.editBranch(quotation);

    Get.toNamed(
      RouterClass.addbranch,
    );
  }

  Future<void> _changeStatus(BuildContext context) async {
    final newStatus = !isActive;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: newStatus ? 'Aktifkan Outlet' : 'Nonaktifkan Outlet',
      message: newStatus
          ? 'Outlet "${quotation.cabang ?? '-'}" akan diaktifkan.'
          : 'Outlet "${quotation.cabang ?? '-'}" akan dinonaktifkan.',
      confirmText: newStatus ? 'Aktifkan' : 'Nonaktifkan',
      cancelText: 'Batal',
      icon:
          newStatus ? Icons.check_circle_outline_rounded : Icons.block_outlined,
      type: newStatus ? AppConfirmType.success : AppConfirmType.warning,
    );

    if (!confirmed) return;

    final id = quotation.id ?? 0;

    if (id <= 0) return;

    await controller.updateStatusBranch(
      id,
      newStatus,
    );
  }

  Future<void> _deleteOutlet(BuildContext context) async {
    if (hasFinancialRecord) {
      _showMessage(
        context,
        'Outlet tidak dapat dihapus karena masih memiliki data keuangan.',
        isError: true,
      );
      return;
    }

    final id = quotation.id ?? 0;

    if (id <= 0) return;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Hapus Outlet',
      message: 'Outlet "${quotation.cabang ?? '-'}" akan dihapus. '
          'Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      icon: Icons.delete_outline_rounded,
      type: AppConfirmType.danger,
    );

    if (!confirmed) return;

    await controller.deleteBranch(id);
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
