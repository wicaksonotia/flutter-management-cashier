import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/transaction_form_card.dart';
import 'package:cashier_management/utils/background_form.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/management_header_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionForm extends StatelessWidget {
  TransactionForm({
    super.key,
  });

  final TransactionController controller = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isEdit = controller.isEdit.value;

        return Scaffold(
          backgroundColor: MyColors.background,
          body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: BackgroundForm(
              headerTitle: isEdit ? 'Edit Transaksi' : 'Tambah Transaksi',
              container: _TransactionFormBody(
                controller: controller,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TransactionFormBody extends StatelessWidget {
  final TransactionController controller;

  const _TransactionFormBody({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isEdit = controller.isEdit.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            110,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ManagementHeaderForm(
                title: isEdit ? 'Edit Transaksi' : 'Transaksi Baru',
                subtitle: isEdit
                    ? 'Perbarui detail transaksi keuangan'
                    : 'Catat pemasukan atau pengeluaran keuangan',
                icon: isEdit
                    ? Icons.edit_note_rounded
                    : Icons.receipt_long_rounded,
              ),
              const SizedBox(height: 18),
              TransactionFormCard(
                controller: controller,
              ),
            ],
          ),
        );
      },
    );
  }
}
