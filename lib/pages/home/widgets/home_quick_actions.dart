import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickAction(
            icon: Icons.point_of_sale_rounded,
            label: 'Kasir',
            accent: true,
          ),
          _QuickAction(
            icon: Icons.receipt_long_rounded,
            label: 'Riwayat',
          ),
          _QuickAction(
            icon: Icons.inventory_2_rounded,
            label: 'Produk',
          ),
          _QuickAction(
            icon: Icons.storefront_rounded,
            label: 'Outlet',
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool accent;

  const _QuickAction({
    required this.icon,
    required this.label,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color background =
        accent ? MyColors.dashboardAccentSoft : MyColors.primaryLight;

    final Color foreground = accent ? MyColors.accent : MyColors.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 3,
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 20,
                color: foreground,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: MyColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
