import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TransactionFormSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const TransactionFormSectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: MyColors.textPrimary,
          ),
        ),
        const Gap(3),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: MyColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
