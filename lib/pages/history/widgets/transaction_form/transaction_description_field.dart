import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/utils/input_field.dart';
import 'package:flutter/material.dart';

class TransactionDescriptionField extends StatelessWidget {
  final TransactionController controller;

  const TransactionDescriptionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InputField(
      label: 'Keterangan',
      icon: Icons.notes_rounded,
      controller: controller.descriptionController,
      hint: 'Masukkan keterangan transaksi',
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
