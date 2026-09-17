import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeRecentTransactions extends StatelessWidget {
  const HomeRecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: const Column(
        children: [
          _TransactionItem(
            name: 'Order #INV-0248',
            detail: 'STMJ Ayam • 3 item',
            amount: 'Rp 48.000',
            time: '20:21',
          ),
          Divider(
            height: 1,
            indent: 68,
            endIndent: 16,
            color: MyColors.divider,
          ),
          _TransactionItem(
            name: 'Order #INV-0247',
            detail: 'STMJ Bebek • 2 item',
            amount: 'Rp 36.000',
            time: '20:15',
          ),
          Divider(
            height: 1,
            indent: 68,
            endIndent: 16,
            color: MyColors.divider,
          ),
          _TransactionItem(
            name: 'Order #INV-0246',
            detail: 'Susu Madu Jahe • 4 item',
            amount: 'Rp 40.000',
            time: '20:07',
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String name;
  final String detail;
  final String amount;
  final String time;

  const _TransactionItem({
    required this.name,
    required this.detail,
    required this.amount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 18,
              color: MyColors.primary,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 10,
                    color: MyColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: MyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 9,
                  color: MyColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
