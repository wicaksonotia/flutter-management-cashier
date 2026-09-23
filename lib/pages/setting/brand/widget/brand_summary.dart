import 'package:cashier_management/models/kios_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class BrandSummary extends StatelessWidget {
  final List<KiosModel> data;

  const BrandSummary({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final activeCount = data.where((item) => item.isActive == true).length;

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
}

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
