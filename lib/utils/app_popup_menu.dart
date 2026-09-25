import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class AppPopupMenuItem {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;
  final bool enabled;

  const AppPopupMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.color,
    this.enabled = true,
  });
}

class AppPopupMenu extends StatelessWidget {
  final List<AppPopupMenuItem> items;
  final ValueChanged<String> onSelected;

  const AppPopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Aksi',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 180,
      ),
      color: MyColors.surface,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      icon: const Icon(
        Icons.more_horiz_rounded,
        size: 21,
        color: MyColors.textSecondary,
      ),
      onSelected: onSelected,
      itemBuilder: (_) {
        return items
            .map(
              (e) => PopupMenuItem<String>(
                value: e.value,
                enabled: e.enabled,
                child: _PopupMenuItemContent(
                  icon: e.icon,
                  label: e.label,
                  color: e.enabled
                      ? (e.color ?? MyColors.textPrimary)
                      : MyColors.disabledText,
                ),
              ),
            )
            .toList();
      },
    );
  }
}

class _PopupMenuItemContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _PopupMenuItemContent({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: color,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
