import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/history/widgets/add_transaction/transaction_category_picker.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class TransactionCategoryField extends StatelessWidget {
  final TransactionController controller;
  final String? error;
  final bool enabled;
  final VoidCallback? onSelected;

  const TransactionCategoryField({
    super.key,
    required this.controller,
    required this.error,
    required this.enabled,
    this.onSelected,
  });

  Future<void> _openPicker(
    BuildContext context,
  ) async {
    if (!enabled) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return TransactionCategoryPicker(
          controller: controller,
          onSelected: onSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = controller.selectedCategoryTransaction.value != 'Category';

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => _openPicker(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: MyColors.surface,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: error != null ? MyColors.error : MyColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: MyColors.primaryLight,
                    borderRadius: BorderRadius.circular(
                      11,
                    ),
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    size: 19,
                    color: MyColors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kategori transaksi',
                        style: TextStyle(
                          fontSize: 10,
                          color: MyColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        selected
                            ? controller.selectedCategoryTransaction.value
                            : 'Pilih kategori',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? MyColors.textPrimary
                              : MyColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: MyColors.textMuted,
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
      ),
    );
  }
}
