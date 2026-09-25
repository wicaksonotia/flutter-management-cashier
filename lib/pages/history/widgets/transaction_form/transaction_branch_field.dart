import 'package:cashier_management/controllers/cabang_controller.dart';
import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/select_table_list_page.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionBranchField extends StatelessWidget {
  final TransactionController transactionController;

  TransactionBranchField({
    super.key,
    required this.transactionController,
  });

  final CabangController cabangController = Get.find<CabangController>();

  Future<void> _loadBranches() async {
    // ==========================================================
    // PASTIKAN BRAND AKTIF SUDAH TERPASANG
    // ==========================================================

    final activeKiosId = transactionController.idKios.value;

    if (activeKiosId <= 0) {
      cabangController.resultItem.clear();
      return;
    }

    // ==========================================================
    // SINKRONKAN BRAND
    // ==========================================================

    if (cabangController.kiosId.value != activeKiosId) {
      cabangController.kiosId.value = activeKiosId;

      // Kalau nama brand tersedia dari BaseController
      cabangController.headerNamaKios.value =
          transactionController.selectedKios.value;
    }

    // ==========================================================
    // LOAD DATA CABANG
    // ==========================================================

    await cabangController.fetchDataListCabangFinancial();
  }

  Future<void> _openPicker() async {
    await _loadBranches();

    if (cabangController.kiosId.value <= 0) {
      Get.snackbar(
        'Brand belum dipilih',
        'Silakan pilih brand terlebih dahulu.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    await Get.to(
      () => SelectTableListPage(
        title: 'Pilih Outlet',
        isLoading: cabangController.isLoadingList,
        items: cabangController.resultItem,
        enableSearch: true,
        searchHint: 'Cari outlet...',
        titleBuilder: (item) {
          return item.cabang ?? '-';
        },
        subtitleBuilder: (item) {
          final kode = item.kode ?? '';
          final alamat = item.alamat ?? '';

          if (kode.isEmpty && alamat.isEmpty) {
            return '';
          }

          if (kode.isEmpty) {
            return alamat;
          }

          if (alamat.isEmpty) {
            return kode;
          }

          return '$kode • $alamat';
        },
        isSelected: (item) {
          return transactionController.idCabang.value == (item.id ?? 0);
        },
        onItemTap: (item) async {
          final id = item.id ?? 0;

          if (id <= 0) {
            return;
          }

          transactionController.idCabang.value = id;
          transactionController.selectedCabang.value = item.cabang ?? '';
        },
        onRefresh: () async {
          await cabangController.fetchDataListCabangFinancial();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final selectedId = transactionController.idCabang.value;

        final selectedName = transactionController.selectedCabang.value;

        final selected = selectedId > 0;

        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: _openPicker,
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: MyColors.surface,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected ? MyColors.selectedBorder : MyColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: selected ? MyColors.primary : MyColors.primaryLight,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.storefront_outlined,
                    size: 19,
                    color: selected ? Colors.white : MyColors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Outlet / Cabang',
                        style: TextStyle(
                          fontSize: 10,
                          color: MyColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        selected ? selectedName : 'Pilih outlet',
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
