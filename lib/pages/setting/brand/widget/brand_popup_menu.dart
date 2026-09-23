import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class BrandPopupMenu extends StatelessWidget {
  final bool isActive;
  final bool canDelete;
  final VoidCallback onEdit;
  final VoidCallback onStatus;
  final VoidCallback onManageOutlet;
  final VoidCallback onDelete;

  const BrandPopupMenu({
    super.key,
    required this.isActive,
    required this.canDelete,
    required this.onEdit,
    required this.onStatus,
    required this.onManageOutlet,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Aksi',
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;

          case 'status':
            onStatus();
            break;

          case 'outlet':
            onManageOutlet();
            break;

          case 'delete':
            onDelete();
            break;
        }
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 180,
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
      elevation: 6,
      itemBuilder: (context) {
        return [
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
            value: 'outlet',
            child: _PopupMenuItemContent(
              icon: Icons.storefront_outlined,
              label: 'Kelola Outlet',
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            enabled: canDelete,
            child: _PopupMenuItemContent(
              icon: Icons.delete_outline_rounded,
              label: 'Hapus Brand',
              color: canDelete ? MyColors.error : MyColors.disabledText,
            ),
          ),
        ];
      },
    );
  }
}

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
