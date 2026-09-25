import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/pages/history/widgets/transaction_form/transaction_calculator.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionAmountField extends StatelessWidget {
  final TransactionController controller;

  const TransactionAmountField({
    super.key,
    required this.controller,
  });

  Future<void> _openCalculator(
    BuildContext context,
  ) async {
    final result = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const TransactionCalculator();
      },
    );

    if (result == null) return;

    final formatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(result);

    controller.amountController.text = formatted;

    controller.amountController.selection = TextSelection.collapsed(
      offset: formatted.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InputField(
      label: 'Nominal',
      icon: Icons.payments_outlined,
      controller: controller.amountController,
      hint: 'Rp 0',
      keyboardType: TextInputType.number,
      inputFormatters: [
        _RupiahInputFormatter(),
      ],
      suffixIcon: Padding(
        padding: const EdgeInsets.only(
          right: 6,
        ),
        child: IconButton(
          tooltip: 'Kalkulator',
          onPressed: () {
            _openCalculator(context);
          },
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: MyColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calculate_outlined,
              size: 19,
              color: MyColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
      );
    }

    final number = int.tryParse(digits);

    if (number == null) {
      return oldValue;
    }

    final formatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}
