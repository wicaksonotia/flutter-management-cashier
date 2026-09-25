import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/centralized_transaction_field.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/transaction_amount_field.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/transaction_branch_field.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/transaction_category_field.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/transaction_datetime_field.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/transaction_description_field.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/transaction_form_section_title.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/transaction_type_selector.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/confirm_dialog.dart';
import 'package:cashier_management/utils/management_save_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TransactionFormCard extends StatelessWidget {
  final TransactionController controller;

  const TransactionFormCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: MyColors.textPrimary.withValues(alpha: .04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // JENIS TRANSAKSI
          // ==========================================================

          const TransactionFormSectionTitle(
            title: 'Jenis Transaksi',
            subtitle: 'Tentukan jenis transaksi yang akan dicatat',
          ),

          const Gap(18),

          TransactionTypeSelector(
            controller: controller,
          ),

          const Gap(28),

          // ==========================================================
          // INFORMASI TRANSAKSI
          // ==========================================================

          const TransactionFormSectionTitle(
            title: 'Informasi Transaksi',
            subtitle: 'Lengkapi detail transaksi keuangan',
          ),

          const Gap(20),

          // ==========================================================
          // TERPUSAT
          // ==========================================================

          CentralizedTransactionField(
            controller: controller,
          ),

          // ==========================================================
          // OUTLET / CABANG
          // HANYA MUNCUL JIKA TIDAK TERPUSAT
          // ==========================================================

          Obx(
            () {
              if (controller.isCentralized.value) {
                return const SizedBox.shrink();
              }

              return const Column(
                children: [
                  Gap(12),
                  _BranchFieldWrapper(),
                ],
              );
            },
          ),

          const Gap(16),

          // ==========================================================
          // KATEGORI
          // ==========================================================

          TransactionCategoryField(
            controller: controller,
          ),

          const Gap(16),

          // ==========================================================
          // NOMINAL
          // ==========================================================

          TransactionAmountField(
            controller: controller,
          ),

          const Gap(16),

          // ==========================================================
          // KETERANGAN
          // ==========================================================

          TransactionDescriptionField(
            controller: controller,
          ),

          const Gap(28),

          // ==========================================================
          // WAKTU
          // ==========================================================

          const TransactionFormSectionTitle(
            title: 'Waktu Transaksi',
            subtitle: 'Tentukan tanggal dan waktu transaksi',
          ),

          const Gap(18),

          TransactionDateTimeField(
            controller: controller,
          ),

          const Gap(30),

          // ==========================================================
          // SAVE
          // ==========================================================

          _SaveButton(
            controller: controller,
          ),
        ],
      ),
    );
  }
}

class _BranchFieldWrapper extends StatelessWidget {
  const _BranchFieldWrapper();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();

    return TransactionBranchField(
      transactionController: controller,
    );
  }
}

// ==================================================================
// SAVE BUTTON
// ==================================================================

class _SaveButton extends StatelessWidget {
  final TransactionController controller;

  const _SaveButton({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isLoading = controller.isLoadingSaveTransaction.value;

        final canSave = controller.validateTransaction() && !isLoading;

        return ManagementSaveButton(
          label: 'Simpan Transaksi',
          isLoading: isLoading,
          onPressed: canSave ? () => _save(context) : null,
        );
      },
    );
  }

  Future<void> _save(
    BuildContext context,
  ) async {
    FocusScope.of(context).unfocus();

    if (!controller.validateTransaction()) {
      await _showValidationError(
        context,
      );
      return;
    }

    final success = await controller.saveTransaction();

    if (!context.mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      return;
    }

    await AppConfirmDialog.show(
      context,
      title: 'Gagal Menyimpan',
      message: 'Transaksi gagal disimpan. Silakan coba kembali.',
      confirmText: 'Tutup',
      cancelText: 'Batal',
      icon: Icons.error_outline_rounded,
      type: AppConfirmType.danger,
    );
  }

  Future<void> _showValidationError(
    BuildContext context,
  ) async {
    String title = 'Data Belum Lengkap';
    String message = 'Silakan lengkapi data transaksi terlebih dahulu.';
    IconData icon = Icons.info_outline_rounded;

    if (controller.amountController.text.trim().isEmpty) {
      title = 'Nominal Belum Diisi';
      message = 'Silakan masukkan nominal transaksi.';
      icon = Icons.payments_outlined;
    } else if (controller.descriptionController.text.trim().isEmpty) {
      title = 'Keterangan Belum Diisi';
      message = 'Silakan masukkan keterangan transaksi.';
      icon = Icons.notes_outlined;
    } else if (controller.idCategoryTransaction.value <= 0) {
      title = 'Kategori Belum Dipilih';
      message = 'Silakan pilih kategori transaksi.';
      icon = Icons.category_outlined;
    } else if (!controller.isCentralized.value &&
        controller.idCabang.value <= 0) {
      title = 'Outlet Belum Dipilih';
      message = 'Silakan pilih outlet atau cabang transaksi.';
      icon = Icons.storefront_outlined;
    }

    await AppConfirmDialog.show(
      context,
      title: title,
      message: message,
      confirmText: 'Tutup',
      cancelText: 'Batal',
      icon: icon,
      type: AppConfirmType.warning,
    );
  }
}
