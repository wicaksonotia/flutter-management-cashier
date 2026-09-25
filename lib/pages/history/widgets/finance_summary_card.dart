import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinanceSummaryCard extends StatelessWidget {
  final int income;
  final int expense;
  final int balance;

  const FinanceSummaryCard({
    super.key,
    required this.income,
    required this.expense,
    required this.balance,
  });

  String _currency(int value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = balance >= 0;

    return Transform.translate(
      offset: const Offset(0, -12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: MyColors.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: MyColors.shadow,
              blurRadius: 18,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo bersih',
              style: TextStyle(
                fontSize: 12,
                color: MyColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _currency(balance),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: isPositive ? MyColors.textPrimary : MyColors.error,
                letterSpacing: -.5,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: 1,
              color: MyColors.divider,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.arrow_downward_rounded,
                    iconBackground: MyColors.successBg,
                    iconColor: MyColors.success,
                    label: 'Pemasukan',
                    value: _currency(income),
                  ),
                ),
                Container(
                  width: 1,
                  height: 42,
                  color: MyColors.divider,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _SummaryItem(
                      icon: Icons.arrow_upward_rounded,
                      iconBackground: MyColors.errorBg,
                      iconColor: MyColors.error,
                      label: 'Pengeluaran',
                      value: _currency(expense),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 17,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: MyColors.textSecondary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: MyColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
