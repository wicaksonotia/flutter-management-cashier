import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class FinanceFilterBar extends StatelessWidget {
  final String periodLabel;
  final String filterBy;
  final VoidCallback onPeriodTap;
  final VoidCallback onFilterTap;

  const FinanceFilterBar({
    super.key,
    required this.periodLabel,
    required this.filterBy,
    required this.onPeriodTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onPeriodTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: MyColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: MyColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 17,
                      color: MyColors.primary,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Periode',
                            style: TextStyle(
                              fontSize: 10,
                              color: MyColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            periodLabel,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: MyColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 19,
                      color: MyColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onFilterTap,
            child: Container(
              width: 50,
              height: 52,
              decoration: BoxDecoration(
                color: MyColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: MyColors.border,
                ),
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 20,
                color: MyColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
