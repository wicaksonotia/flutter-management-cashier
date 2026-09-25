import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/models/employee_model.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/app_popup_menu.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/management_status_badge.dart';
import 'package:flutter/material.dart';

class EmployeeItem extends StatelessWidget {
  final DataEmployee model;
  final EmployeeController controller;

  const EmployeeItem({
    super.key,
    required this.model,
    required this.controller,
  });

  bool get isActive => model.statusKasir ?? false;
  bool get hasTransaction => model.statusTransaksi ?? false;
  bool get canDelete => !hasTransaction;

  int get employeeId => model.idKasir ?? 0;

  List<int> get branchIds => model.idCabang ?? [];

  String get employeeName => model.namaKasir ?? '-';
  String get username => model.usernameKasir ?? '-';
  String get phone => model.phoneKasir ?? '-';
  String get defaultOutlet => model.defaultOutletName ?? '-';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _editEmployee(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildIdentity(),
                    ),
                    const SizedBox(width: 8),
                    _buildMenu(context),
                  ],
                ),
                const SizedBox(height: 13),
                _buildDetailRow(
                  icon: Icons.person_outline_rounded,
                  label: username,
                ),
                const SizedBox(height: 7),
                _buildDetailRow(
                  icon: Icons.phone_outlined,
                  label: phone,
                ),
                const SizedBox(height: 7),
                _buildDetailRow(
                  icon: Icons.storefront_outlined,
                  label: defaultOutlet,
                ),
                const SizedBox(height: 12),
                _buildBranchSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: MyColors.primaryLight,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: MyColors.border,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/clerk.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: isActive ? MyColors.success : MyColors.error,
              shape: BoxShape.circle,
              border: Border.all(
                color: MyColors.surface,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIdentity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          employeeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: MyColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        ManagementStatusBadge(
          active: isActive,
          activeLabel: 'Aktif',
          inactiveLabel: 'Nonaktif',
        ),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return AppPopupMenu(
      items: [
        const AppPopupMenuItem(
          value: 'edit',
          label: 'Edit Karyawan',
          icon: Icons.edit_outlined,
        ),
        AppPopupMenuItem(
          value: 'status',
          label: isActive ? 'Nonaktifkan' : 'Aktifkan',
          icon: isActive
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded,
          color: isActive ? MyColors.warning : MyColors.success,
        ),
        const AppPopupMenuItem(
          value: 'reset',
          label: 'Reset Password',
          icon: Icons.lock_reset_outlined,
        ),
        AppPopupMenuItem(
          value: 'delete',
          label: 'Hapus Karyawan',
          icon: Icons.delete_outline_rounded,
          color: MyColors.error,
          enabled: canDelete,
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _editEmployee(context);
            break;

          case 'status':
            _changeStatus(context);
            break;

          case 'reset':
            _resetPassword(context);
            break;

          case 'delete':
            _deleteEmployee(context);
            break;
        }
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: MyColors.textMuted,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: MyColors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchSection(BuildContext context) {
    final branches = controller.listCabang;

    if (branches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Outlet',
          style: TextStyle(
            color: MyColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: branches.map<Widget>((cabang) {
            final int cabangValue = cabang['value'];
            final String cabangNama = cabang['nama'];

            final bool isSelected = branchIds.contains(cabangValue);

            return _BranchChip(
              label: cabangNama,
              selected: isSelected,
              onTap: () => _processBranch(
                context,
                cabangValue,
                cabangNama,
                isSelected,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _editEmployee(BuildContext context) {
    controller.editEmployee(model);

    Navigator.of(context).pushNamed(
      RouterClass.addemployee,
    );
  }

  Future<void> _changeStatus(BuildContext context) async {
    final newStatus = !isActive;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: newStatus ? 'Aktifkan Karyawan' : 'Nonaktifkan Karyawan',
      message: newStatus
          ? 'Karyawan "$employeeName" akan diaktifkan.'
          : 'Karyawan "$employeeName" akan dinonaktifkan.',
      confirmText: newStatus ? 'Aktifkan' : 'Nonaktifkan',
      cancelText: 'Batal',
      icon:
          newStatus ? Icons.check_circle_outline_rounded : Icons.block_outlined,
      type: newStatus ? AppConfirmType.success : AppConfirmType.warning,
    );

    if (!confirmed) return;
    if (employeeId <= 0) return;

    await controller.updateEmployeeStatus(
      employeeId,
      newStatus,
    );
  }

  Future<void> _deleteEmployee(BuildContext context) async {
    if (!canDelete) return;
    if (employeeId <= 0) return;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Hapus Karyawan',
      message: 'Karyawan "$employeeName" akan dihapus. '
          'Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      icon: Icons.delete_outline_rounded,
      type: AppConfirmType.danger,
    );

    if (!confirmed) return;

    final success = await controller.deleteEmployee(
      employeeId,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Karyawan berhasil dihapus' : 'Gagal menghapus karyawan',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    if (employeeId <= 0) return;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Reset Password',
      message: 'Password karyawan "$employeeName" '
          'akan direset. Lanjutkan?',
      confirmText: 'Reset',
      cancelText: 'Batal',
      icon: Icons.lock_reset_outlined,
      type: AppConfirmType.warning,
    );

    if (!confirmed) return;

    await controller.resetPassword(
      employeeId,
    );
  }

  Future<void> _processBranch(
    BuildContext context,
    int cabangValue,
    String cabangNama,
    bool isSelected,
  ) async {
    if (employeeId <= 0) return;

    if (isSelected) {
      if (branchIds.length == 1) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Karyawan harus memiliki minimal satu outlet.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );

        return;
      }

      final confirmed = await AppConfirmDialog.show(
        context,
        title: 'Hapus Akses Outlet',
        message: 'Karyawan "$employeeName" akan dihapus '
            'aksesnya dari outlet "$cabangNama".',
        confirmText: 'Hapus Akses',
        cancelText: 'Batal',
        icon: Icons.remove_circle_outline_rounded,
        type: AppConfirmType.warning,
      );

      if (!confirmed) return;

      await controller.processKasirCabang(
        employeeId,
        cabangValue,
        'remove',
      );

      return;
    }

    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Tambah Akses Outlet',
      message: 'Karyawan "$employeeName" akan diberikan '
          'akses ke outlet "$cabangNama".',
      confirmText: 'Tambah',
      cancelText: 'Batal',
      icon: Icons.add_business_outlined,
      type: AppConfirmType.success,
    );

    if (!confirmed) return;

    await controller.processKasirCabang(
      employeeId,
      cabangValue,
      'add',
    );
  }
}

class _BranchChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BranchChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? MyColors.primaryLight : MyColors.surfaceSoft,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? MyColors.primary.withValues(alpha: .20)
                  : MyColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.add_circle_outline_rounded,
                size: 12,
                color: selected ? MyColors.primary : MyColors.textMuted,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color:
                      selected ? MyColors.primaryDark : MyColors.textSecondary,
                  fontSize: 9.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
