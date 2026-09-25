import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionAmountField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? error;

  const TransactionAmountField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: MyColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: error != null
                  ? MyColors.error
                  : focusNode.hasFocus
                      ? MyColors.primary
                      : MyColors.border,
              width: focusNode.hasFocus ? 1.3 : 1,
            ),
          ),
          child: Row(
            children: [
              const Text(
                'Rp',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: MyColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    hintText: '0',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: MyColors.textMuted,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: MyColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 5),
          Text(
            error!,
            style: const TextStyle(
              fontSize: 10.5,
              color: MyColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
