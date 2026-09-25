import 'package:cashier_management/utils/app_popup_menu.dart';
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
    return AppPopupMenu(
      items: [
        const AppPopupMenuItem(
          value: 'edit',
          label: 'Edit Brand',
          icon: Icons.edit_outlined,
        ),
        AppPopupMenuItem(
          value: 'status',
          label: isActive ? 'Nonaktifkan' : 'Aktifkan',
          icon: isActive
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded,
        ),
        const AppPopupMenuItem(
          value: 'outlet',
          label: 'Kelola Outlet',
          icon: Icons.storefront_outlined,
        ),
        AppPopupMenuItem(
          value: 'delete',
          label: 'Hapus Brand',
          icon: Icons.delete_outline_rounded,
          color: MyColors.error,
          enabled: canDelete,
        ),
      ],
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
    );
  }
}
