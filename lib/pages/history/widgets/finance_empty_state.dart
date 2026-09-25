import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class FinanceEmptyState extends StatelessWidget {
  const FinanceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 120),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: const BoxDecoration(
              color: MyColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 36,
              color: MyColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Belum ada transaksi',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: MyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Belum ada transaksi pada periode yang dipilih.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: MyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
