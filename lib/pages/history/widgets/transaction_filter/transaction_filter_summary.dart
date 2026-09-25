import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class TransactionFilterSummary extends StatelessWidget {
  final int outletCount;
  final int categoryCount;
  final bool showCategory;

  const TransactionFilterSummary({
    super.key,
    required this.outletCount,
    required this.categoryCount,
    required this.showCategory,
  });

  int get totalFilter {
    return outletCount + (showCategory ? categoryCount : 0);
  }

  bool get isFiltered {
    return totalFilter > 0;
  }

  @override
  Widget build(BuildContext context) {
    if (!isFiltered) {
      return _buildEmpty();
    }

    return _buildActive();
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.filter_alt_off_outlined,
            size: 17,
            color: MyColors.textMuted,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Belum ada filter yang dipilih',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: MyColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActive() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: MyColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MyColors.selectedBorder,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.filter_alt_rounded,
            size: 17,
            color: MyColors.primary,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              '$totalFilter filter dipilih',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: MyColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
