import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: MyColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: MyColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
