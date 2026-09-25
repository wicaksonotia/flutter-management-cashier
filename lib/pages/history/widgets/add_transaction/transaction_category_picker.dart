import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionCategoryPicker extends StatelessWidget {
  final TransactionController controller;
  final VoidCallback? onSelected;

  const TransactionCategoryPicker({
    super.key,
    required this.controller,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * .62,
        decoration: const BoxDecoration(
          color: MyColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: MyColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: const Icon(
                      Icons.category_outlined,
                      color: MyColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 11),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih kategori',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: MyColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tentukan kategori transaksi',
                          style: TextStyle(
                            fontSize: 11,
                            color: MyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoadingWithoutPagination.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primary,
                      ),
                    );
                  }

                  final categories =
                      controller.resultDataCategoryWithoutPagination;

                  if (categories.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada kategori',
                        style: TextStyle(
                          fontSize: 12,
                          color: MyColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      20,
                    ),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 8,
                    ),
                    itemBuilder: (_, index) {
                      final item = categories[index];

                      final selected = controller.idCategoryTransaction.value ==
                          (item.id ?? 0);

                      return InkWell(
                        borderRadius: BorderRadius.circular(
                          14,
                        ),
                        onTap: () {
                          controller.selectTransactionCategory(
                            item,
                          );

                          onSelected?.call();

                          Navigator.pop(
                            context,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(
                            14,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? MyColors.primaryLight
                                : MyColors.surface,
                            borderRadius: BorderRadius.circular(
                              14,
                            ),
                            border: Border.all(
                              color: selected
                                  ? MyColors.selectedBorder
                                  : MyColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? MyColors.primary
                                      : MyColors.surfaceSoft,
                                  borderRadius: BorderRadius.circular(
                                    11,
                                  ),
                                ),
                                child: Icon(
                                  Icons.category_outlined,
                                  size: 19,
                                  color: selected
                                      ? Colors.white
                                      : MyColors.textSecondary,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Text(
                                  item.categoryName ?? '-',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: MyColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 20,
                                  color: MyColors.primary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
