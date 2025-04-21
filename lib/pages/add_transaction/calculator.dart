import 'package:financial_apps/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TransactionController _transactionController =
      Get.find<TransactionController>();
  double? _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return SimpleCalculator(
      value: _currentValue!,
      hideExpression: false,
      hideSurroundingBorder: true,
      autofocus: true,
      onChanged: (key, value, expression) {
        setState(() {
          _currentValue = value ?? 0;
          var hasil = NumberFormat.currency(
            locale: 'id',
            decimalDigits: 0,
            symbol: 'Rp.',
          ).format(value);
          _transactionController.amountController.text = hasil;
        });
      },
      theme: const CalculatorThemeData(
        borderColor: Colors.black,
        borderWidth: .5,
        displayColor: Colors.black,
        displayStyle: TextStyle(fontSize: 80, color: Colors.white),
        expressionColor: Colors.black,
        expressionStyle: TextStyle(fontSize: 20, color: Colors.white),
        operatorColor: Colors.orange,
        operatorStyle: TextStyle(fontSize: 30, color: Colors.white),
        commandColor: Colors.orange,
        commandStyle: TextStyle(fontSize: 30, color: Colors.white),
        numColor: Colors.black,
        numStyle: TextStyle(fontSize: 50, color: Colors.white),
      ),
    );
  }
}
