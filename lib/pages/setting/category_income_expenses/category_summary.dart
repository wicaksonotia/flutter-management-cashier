import 'package:cashier_management/controllers/category_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategorySummary extends StatelessWidget {
  final CategoryController controller;

  const CategorySummary({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.resultDataCategory;

      final total = data.length;

      final pemasukan = data
          .where(
            (item) => item.categoryType == 'PEMASUKAN',
          )
          .length;

      final pengeluaran = data
          .where(
            (item) => item.categoryType == 'PENGELUARAN',
          )
          .length;

      return Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          18,
        ),
        child: Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.layers_outlined,
                label: 'Total',
                value: total.toString(),
                iconBackground: MyColors.primaryLight,
                iconColor: MyColors.primaryDark,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryCard(
                icon: Icons.arrow_downward_rounded,
                label: 'Pemasukan',
                value: pemasukan.toString(),
                iconBackground: MyColors.primaryLight,
                iconColor: MyColors.primaryDark,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryCard(
                icon: Icons.arrow_upward_rounded,
                label: 'Pengeluaran',
                value: pengeluaran.toString(),
                iconBackground: MyColors.errorBg,
                iconColor: MyColors.error,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconBackground;
  final Color iconColor;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBackground,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 17,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: MyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: MyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
