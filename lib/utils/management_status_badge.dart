import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class ManagementStatusBadge extends StatelessWidget {
  final bool active;
  final String? activeLabel;
  final String? inactiveLabel;

  const ManagementStatusBadge({
    super.key,
    required this.active,
    this.activeLabel = 'Aktif',
    this.inactiveLabel = 'Nonaktif',
  });

  @override
  Widget build(BuildContext context) {
    final background = active ? MyColors.successBg : MyColors.errorBg;

    final foreground = active ? MyColors.success : MyColors.error;

    final label = active ? activeLabel : inactiveLabel;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label ?? '',
            style: TextStyle(
              color: foreground,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
