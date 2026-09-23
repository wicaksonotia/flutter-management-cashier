import 'package:flutter/material.dart';
import 'package:cashier_management/utils/colors.dart';

class BranchEmptyState extends StatelessWidget {
  const BranchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .28,
        ),
        Container(
          width: 68,
          height: 68,
          margin: const EdgeInsets.symmetric(
            horizontal: 80,
          ),
          decoration: BoxDecoration(
            color: MyColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.storefront_outlined,
            size: 32,
            color: MyColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Belum ada outlet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tambahkan outlet untuk mulai mengelola operasional dan keuangan.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.textSecondary,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
