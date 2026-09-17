import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeBranchPerformance extends StatelessWidget {
  const HomeBranchPerformance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: const Column(
        children: [
          _BranchItem(
            name: 'Bangsongan',
            total: 'Rp 1.820.000',
            percentage: 0.82,
          ),
          SizedBox(height: 18),
          _BranchItem(
            name: 'Sumbertugu',
            total: 'Rp 1.430.000',
            percentage: 0.64,
          ),
          SizedBox(height: 18),
          _BranchItem(
            name: 'Nambaan',
            total: 'Rp 1.030.000',
            percentage: 0.46,
          ),
        ],
      ),
    );
  }
}

class _BranchItem extends StatelessWidget {
  final String name;
  final String total;
  final double percentage;

  const _BranchItem({
    required this.name,
    required this.total,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 17,
                color: MyColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: MyColors.textPrimary,
                ),
              ),
            ),
            Text(
              total,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: MyColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: MyColors.surfaceSoft,
            color: MyColors.primary,
          ),
        ),
      ],
    );
  }
}
