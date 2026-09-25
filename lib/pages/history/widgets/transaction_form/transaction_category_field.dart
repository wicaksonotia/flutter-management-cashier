import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionCategoryField extends StatelessWidget {
  final TransactionController controller;

  const TransactionCategoryField({
    super.key,
    required this.controller,
  });

  Future<void> _openPicker() async {
    await Get.to(
      () => SelectTableListPage(
        title: 'Pilih Kategori',
        isLoading: controller.isLoadingWithoutPagination,
        items: controller.resultDataCategoryWithoutPagination,
        enableSearch: true,
        searchHint: 'Cari kategori...',
        titleBuilder: (item) {
          return item.categoryName ?? '-';
        },
        isSelected: (item) {
          return controller.idCategoryTransaction.value == (item.id ?? 0);
        },
        onItemTap: (item) async {
          controller.selectTransactionCategory(item);

          // JANGAN Get.back() di sini.
          //
          // SelectTableListPage sudah menangani
          // navigasi setelah item dipilih.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final selected = controller.idCategoryTransaction.value > 0;

        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: _openPicker,
          child: Container(
            padding: const EdgeInsets.all(13),
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
                    color: MyColors.primaryLight,
                    borderRadius: BorderRadius.circular(11),
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
        );
      },
    );
  }
}
