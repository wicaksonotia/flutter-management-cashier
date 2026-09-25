import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class TransactionDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? error;

  const TransactionDescriptionField({
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
          decoration: BoxDecoration(
            color: MyColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: error != null
                  ? MyColors.error
                  : focusNode.hasFocus
                      ? MyColors.primary
                      : MyColors.border,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            minLines: 3,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Contoh: Belanja jahe, susu, madu...',
              hintStyle: TextStyle(
                color: MyColors.textMuted,
                fontSize: 12,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
            ),
            style: const TextStyle(
              fontSize: 13,
              color: MyColors.textPrimary,
            ),
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
