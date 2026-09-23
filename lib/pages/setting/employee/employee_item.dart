import 'package:cashier_management/controllers/employee_controller.dart';
import 'package:cashier_management/models/employee_model.dart';
import 'package:cashier_management/routes.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/management_action_button.dart';
import 'package:cashier_management/utils/management_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeItem extends StatelessWidget {
  final DataEmployee model;
  final EmployeeController controller;

  const EmployeeItem({
    super.key,
    required this.model,
    required this.controller,
  });

  // ==============================================================
  // GETTER
  // ==============================================================

  bool get isActive => model.statusKasir ?? false;

  bool get hasTransaction => model.statusTransaksi ?? false;

  bool get canDelete => !hasTransaction;

  int get employeeId => model.idKasir ?? 0;

  List<int> get branchIds => model.idCabang ?? [];

  String get employeeName => model.namaKasir ?? '-';

  String get username => model.usernameKasir ?? '-';

  String get phone => model.phoneKasir ?? '-';

  String get defaultOutlet => model.defaultOutletName ?? '-';

  // ==============================================================
  // BUILD
  // ==============================================================

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
          onTap: () => _editEmployee(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // HEADER
                // ==================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildIdentity(),
                    ),
                    const SizedBox(width: 8),
                    _buildTopActions(),
                  ],
                ),

                const SizedBox(height: 13),

                // ==================================================
                // DETAILS
                // ==================================================

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

                // ==================================================
                // BRANCHES
                // ==================================================

                _buildBranchSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // AVATAR
  // ==============================================================

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

  // ==============================================================
  // IDENTITY
  // ==============================================================

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

  // ==============================================================
  // TOP ACTIONS
  // ==============================================================

  Widget _buildTopActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ManagementActionButton(
          icon: Icons.edit_outlined,
          background: MyColors.primaryLight,
          foreground: MyColors.primaryDark,
          onTap: _editEmployee,
          height: 30,
          iconSize: 14,
        ),
        const SizedBox(width: 5),
        ManagementActionButton(
          icon: isActive
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded,
          background:
              isActive ? MyColors.dashboardAccentBorder : MyColors.successBg,
          foreground: isActive ? MyColors.accent : MyColors.success,
          onTap: _changeStatus,
          height: 30,
          iconSize: 14,
        ),
        const SizedBox(width: 5),
        ManagementActionButton(
          icon: Icons.lock_reset_outlined,
          background: MyColors.primaryLight,
          foreground: MyColors.primaryDark,
          onTap: _resetPassword,
          height: 30,
          iconSize: 14,
        ),
        const SizedBox(width: 5),
        ManagementActionButton(
          icon: Icons.delete_outline_rounded,
          background: canDelete ? MyColors.errorBg : MyColors.surfaceSoft,
          foreground: canDelete ? MyColors.error : MyColors.textMuted,
          onTap: canDelete ? _deleteEmployee : null,
          height: 30,
          iconSize: 14,
        ),
      ],
    );
  }

  // ==============================================================
  // DETAIL ROW
  // ==============================================================

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

  // ==============================================================
  // BRANCH SECTION
  // ==============================================================

  Widget _buildBranchSection() {
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

  // ==============================================================
  // EDIT
  // ==============================================================

  void _editEmployee() {
    controller.editEmployee(model);

    Get.toNamed(
      RouterClass.addemployee,
    );
  }

  // ==============================================================
  // STATUS
  // ==============================================================

  Future<void> _changeStatus() async {
    final newStatus = !isActive;

    final confirmed = await AppConfirmDialog.show(
      Get.context!,
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

    if (!confirmed) {
      return;
    }

    if (employeeId <= 0) {
      return;
    }

    await controller.updateEmployeeStatus(
      employeeId,
      newStatus,
    );
  }

  // ==============================================================
  // DELETE
  // ==============================================================

  Future<void> _deleteEmployee() async {
    if (!canDelete) {
      return;
    }

    if (employeeId <= 0) {
      return;
    }

    final confirmed = await AppConfirmDialog.show(
      Get.context!,
      title: 'Hapus Karyawan',
      message: 'Karyawan "$employeeName" akan dihapus. '
          'Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      icon: Icons.delete_outline_rounded,
      type: AppConfirmType.danger,
    );

    if (!confirmed) {
      return;
    }

    await controller.deleteEmployee(
      employeeId,
    );
  }

  // ==============================================================
  // RESET PASSWORD
  // ==============================================================

  Future<void> _resetPassword() async {
    if (employeeId <= 0) {
      return;
    }

    final confirmed = await AppConfirmDialog.show(
      Get.context!,
      title: 'Reset Password',
      message: 'Password karyawan "$employeeName" akan direset. '
          'Lanjutkan?',
      confirmText: 'Reset',
      cancelText: 'Batal',
      icon: Icons.lock_reset_outlined,
      type: AppConfirmType.warning,
    );

    if (!confirmed) {
      return;
    }

    await controller.resetPassword(
      employeeId,
    );
  }

  // ==============================================================
  // PROCESS BRANCH
  // ==============================================================

  Future<void> _processBranch(
    int cabangValue,
    String cabangNama,
    bool isSelected,
  ) async {
    if (employeeId <= 0) {
      return;
    }

    // ------------------------------------------------------------
    // REMOVE
    // ------------------------------------------------------------

    if (isSelected) {
      if (branchIds.length == 1) {
        Get.snackbar(
          'Tidak dapat dihapus',
          'Karyawan harus memiliki minimal satu outlet.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: MyColors.errorBg,
          colorText: MyColors.error,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );

        return;
      }

      final confirmed = await AppConfirmDialog.show(
        Get.context!,
        title: 'Hapus Akses Outlet',
        message: 'Karyawan "$employeeName" akan dihapus '
            'aksesnya dari outlet "$cabangNama".',
        confirmText: 'Hapus Akses',
        cancelText: 'Batal',
        icon: Icons.remove_circle_outline_rounded,
        type: AppConfirmType.warning,
      );

      if (!confirmed) {
        return;
      }

      await controller.processKasirCabang(
        employeeId,
        cabangValue,
        'remove',
      );

      return;
    }

    // ------------------------------------------------------------
    // ADD
    // ------------------------------------------------------------

    final confirmed = await AppConfirmDialog.show(
      Get.context!,
      title: 'Tambah Akses Outlet',
      message: 'Karyawan "$employeeName" akan diberikan akses '
          'ke outlet "$cabangNama".',
      confirmText: 'Tambah',
      cancelText: 'Batal',
      icon: Icons.add_business_outlined,
      type: AppConfirmType.success,
    );

    if (!confirmed) {
      return;
    }

    await controller.processKasirCabang(
      employeeId,
      cabangValue,
      'add',
    );
  }
}

// ==================================================================
// BRANCH CHIP
// ==================================================================

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
