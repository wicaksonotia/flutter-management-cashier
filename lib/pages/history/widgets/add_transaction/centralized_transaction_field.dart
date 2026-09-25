import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class CentralizedTransactionField extends StatelessWidget {
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const CentralizedTransactionField({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: value ? MyColors.primaryLight : MyColors.surfaceSoft,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.hub_outlined,
              size: 19,
              color: value ? MyColors.primary : MyColors.textSecondary,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaksi terpusat',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tidak terkait outlet tertentu',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: MyColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: MyColors.primary,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
