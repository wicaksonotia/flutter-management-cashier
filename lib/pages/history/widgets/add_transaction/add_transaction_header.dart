import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class AddTransactionHeader extends StatelessWidget {
  const AddTransactionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: MyColors.primaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: MyColors.primary,
            size: 23,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah transaksi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: MyColors.textPrimary,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Catat pemasukan atau pengeluaran',
                style: TextStyle(
                  fontSize: 12,
                  color: MyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
