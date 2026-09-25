import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class ActiveBrandField extends StatelessWidget {
  final String name;

  const ActiveBrandField({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = name.trim().isEmpty ? 'Brand aktif' : name;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: MyColors.primaryLight,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: MyColors.selectedBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: MyColors.primary,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              size: 19,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Brand yang digunakan',
                  style: TextStyle(
                    fontSize: 10,
                    color: MyColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: MyColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.lock_outline_rounded,
            size: 17,
            color: MyColors.textMuted,
          ),
        ],
      ),
    );
  }
}
