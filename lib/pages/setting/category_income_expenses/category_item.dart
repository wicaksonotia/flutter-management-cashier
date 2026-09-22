import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/models/category_model.dart';
import 'package:cashier_management/pages/setting/category_income_expenses/category_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/management_action_button.dart';
import 'package:cashier_management/utils/management_status_badge.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final DataCategory model;
  final CategoryController controller;

  const CategoryItem({
    super.key,
    required this.model,
    required this.controller,
  });

  // ==========================================================
  // CATEGORY TYPE
  // ==========================================================

  bool get isIncome => model.categoryType == 'PEMASUKAN';

  // ==========================================================
  // STATUS
  // ==========================================================

  bool get active => model.status ?? false;

  // ==========================================================
  // TRANSACTION STATUS
  // ==========================================================
  // 0 = belum pernah dipakai transaksi
  // 1 = sudah pernah dipakai transaksi
  //
  // Kategori pengeluaran yang belum pernah digunakan
  // masih boleh dihapus.
  // ==========================================================

  bool get hasTransaction => model.statusTransaksi == 1;

  // bool get canDelete => !isIncome && !hasTransaction;
  bool get canDelete => !hasTransaction;

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final accent = isIncome ? MyColors.primary : MyColors.error;

    final accentBackground =
        isIncome ? MyColors.primaryLight : MyColors.errorBg;

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
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showEditForm(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // ==================================================
                // ICON
                // ==================================================

                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentBackground,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    isIncome
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded,
                    color: accent,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                // ==================================================
                // CONTENT
                // ==================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.categoryName ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: MyColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _TypeBadge(
                        label: isIncome ? 'PEMASUKAN' : 'PENGELUARAN',
                        color: accent,
                        background: accentBackground,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ==================================================
                // ACTIONS
                // ==================================================

                _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ACTION BUTTONS
  // ==========================================================

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ========================================================
        // STATUS
        // ========================================================

        ManagementStatusBadge(
          active: active,
        ),

        const SizedBox(width: 6),

        // ========================================================
        // EDIT
        // ========================================================

        ManagementActionButton(
          icon: Icons.edit_outlined,
          background: MyColors.primaryLight,
          foreground: MyColors.primaryDark,
          onTap: () => _showEditForm(context),
          height: 30,
          iconSize: 14,
        ),

        const SizedBox(width: 5),

        // ========================================================
        // ACTIVE / INACTIVE
        // ========================================================

        ManagementActionButton(
          icon: active
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded,
          background:
              active ? MyColors.dashboardAccentBorder : MyColors.successBg,
          foreground: active ? MyColors.accent : MyColors.success,
          onTap: () => _status(context),
          height: 30,
          iconSize: 14,
        ),

        const SizedBox(width: 5),

        // ========================================================
        // DELETE
        // ========================================================
        //
        // Hanya aktif jika:
        // - kategori pengeluaran
        // - belum pernah dipakai transaksi
        //
        // Jika sudah pernah dipakai transaksi, tombol disabled.
        // ========================================================

        ManagementActionButton(
          icon: Icons.delete_outline_rounded,
          background: canDelete ? MyColors.errorBg : MyColors.surfaceSoft,
          foreground: canDelete ? MyColors.error : MyColors.textMuted,
          onTap: canDelete ? () => _confirmDelete(context) : null,
          height: 30,
          iconSize: 14,
        ),
      ],
    );
  }

  // ==========================================================
  // EDIT
  // ==========================================================

  void _showEditForm(BuildContext context) {
    controller.editCategory(model);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => const _CategoryFormSheet(),
    );
  }

  // ==========================================================
  // DELETE CONFIRMATION
  // ==========================================================

  Future<void> _confirmDelete(BuildContext context) async {
    // Safety check.
    // Walaupun tombol sudah disabled dari UI,
    // tetap validasi lagi sebelum delete.
    if (!canDelete) {
      return;
    }

    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Hapus Kategori',
      message: 'Kategori "${model.categoryName ?? '-'}" akan dihapus. '
          'Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      icon: Icons.delete_outline_rounded,
      type: AppConfirmType.danger,
    );

    if (!confirmed) {
      return;
    }

    final id = model.id;

    if (id == null || id <= 0) {
      return;
    }

    await controller.deleteCategory(id);
  }

  // ==========================================================
  // STATUS
  // ==========================================================

  Future<void> _status(BuildContext context) async {
    final currentStatus = model.status ?? false;
    final newStatus = !currentStatus;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: newStatus ? 'Aktifkan Kategori' : 'Nonaktifkan Kategori',
      message: newStatus
          ? 'Kategori "${model.categoryName}" akan diaktifkan.'
          : 'Kategori "${model.categoryName}" akan dinonaktifkan.',
      confirmText: newStatus ? 'Aktifkan' : 'Nonaktifkan',
      cancelText: 'Batal',
      icon:
          newStatus ? Icons.check_circle_outline_rounded : Icons.block_outlined,
      type: newStatus ? AppConfirmType.success : AppConfirmType.warning,
    );

    if (!confirmed) {
      return;
    }

    final id = model.id;

    if (id == null || id <= 0) {
      return;
    }

    await controller.updateStatusCategory(
      id,
      newStatus,
    );
  }
}

// ============================================================
// TYPE BADGE
// ============================================================

class _TypeBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;

  const _TypeBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w800,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

// ============================================================
// CATEGORY FORM SHEET
// ============================================================

class _CategoryFormSheet extends StatelessWidget {
  const _CategoryFormSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 700,
      ),
      decoration: const BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: MyColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  24,
                ),
                child: CategoryForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
