import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kelola kategori transaksi',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: MyColors.textPrimary,
              letterSpacing: -.7,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Atur kategori pemasukan dan pengeluaran '
            'agar pencatatan keuangan lebih rapi.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: MyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
