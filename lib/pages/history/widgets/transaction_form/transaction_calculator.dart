import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCalculator extends StatefulWidget {
  const TransactionCalculator({
    super.key,
  });

  @override
  State<TransactionCalculator> createState() => _TransactionCalculatorState();
}

class _TransactionCalculatorState extends State<TransactionCalculator> {
  String expression = '';
  String display = '0';

  void _input(String value) {
    setState(() {
      if (value == 'C') {
        expression = '';
        display = '0';
        return;
      }

      if (value == '⌫') {
        if (expression.isNotEmpty) {
          expression = expression.substring(
            0,
            expression.length - 1,
          );

          display = expression.isEmpty ? '0' : expression;
        }

        return;
      }

      if (value == '=') {
        final result = _calculate(
          expression,
        );

        if (result == null) return;

        expression = result.toString();
        display = _formatNumber(result);

        return;
      }

      if (value == '×') {
        _appendOperator('*');
        return;
      }

      if (value == '÷') {
        _appendOperator('/');
        return;
      }

      if (value == '+' || value == '-') {
        _appendOperator(value);
        return;
      }

      expression += value;

      final number = int.tryParse(expression);

      if (number != null) {
        display = _formatNumber(number);
      } else {
        display = expression;
      }
    });
  }

  void _appendOperator(
    String operator,
  ) {
    if (expression.isEmpty) {
      return;
    }

    final last = expression[expression.length - 1];

    if (last == '+' || last == '-' || last == '*' || last == '/') {
      expression = expression.substring(
        0,
        expression.length - 1,
      );
    }

    expression += operator;
    display = expression;
  }

  int? _calculate(
    String value,
  ) {
    if (value.isEmpty) return null;

    final normalized = value.replaceAll('×', '*').replaceAll('÷', '/');

    try {
      final tokens = <String>[];

      String current = '';

      for (int i = 0; i < normalized.length; i++) {
        final char = normalized[i];

        if ('0123456789'.contains(char)) {
          current += char;
          continue;
        }

        if (current.isNotEmpty) {
          tokens.add(current);
          current = '';
        }

        tokens.add(char);
      }

      if (current.isNotEmpty) {
        tokens.add(current);
      }

      if (tokens.isEmpty) {
        return null;
      }

      // Kali / bagi terlebih dahulu.
      int index = 1;

      while (index < tokens.length - 1) {
        final operator = tokens[index];

        if (operator == '*' || operator == '/') {
          final left = double.tryParse(
            tokens[index - 1],
          );

          final right = double.tryParse(
            tokens[index + 1],
          );

          if (left == null || right == null) {
            return null;
          }

          double result;

          if (operator == '*') {
            result = left * right;
          } else {
            if (right == 0) {
              return null;
            }

            result = left / right;
          }

          tokens[index - 1] = result.toString();
          tokens.removeAt(index);
          tokens.removeAt(index);

          continue;
        }

        index += 2;
      }

      // Tambah / kurang.
      double result = double.tryParse(tokens.first) ?? 0;

      index = 1;

      while (index < tokens.length - 1) {
        final operator = tokens[index];

        final right = double.tryParse(
          tokens[index + 1],
        );

        if (right == null) {
          return null;
        }

        if (operator == '+') {
          result += right;
        } else if (operator == '-') {
          result -= right;
        }

        index += 2;
      }

      if (!result.isFinite) {
        return null;
      }

      return result.round();
    } catch (_) {
      return null;
    }
  }

  String _formatNumber(
    int value,
  ) {
    return NumberFormat.decimalPattern(
      'id_ID',
    ).format(value);
  }

  void _submit() {
    final result = _calculate(
      expression,
    );

    if (result == null) {
      return;
    }

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: MyColors.textPrimary.withValues(alpha: .12),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ========================================================
            // HEADER
            // ========================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                12,
                12,
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: MyColors.primaryLight,
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: const Icon(
                      Icons.calculate_outlined,
                      color: MyColors.primary,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kalkulator',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: MyColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Hitung nominal transaksi',
                          style: TextStyle(
                            fontSize: 11,
                            color: MyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pop();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: MyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // ========================================================
            // DISPLAY
            // ========================================================

            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                14,
              ),
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                18,
              ),
              decoration: BoxDecoration(
                color: MyColors.background,
                borderRadius: BorderRadius.circular(
                  16,
                ),
                border: Border.all(
                  color: MyColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    expression.isEmpty ? 'Masukkan perhitungan' : expression,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: MyColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Rp $display',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      color: MyColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // ========================================================
            // BUTTONS
            // ========================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                18,
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.35,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _CalculatorButton(
                    label: 'C',
                    type: _CalculatorButtonType.danger,
                    onTap: () => _input('C'),
                  ),
                  _CalculatorButton(
                    label: '⌫',
                    icon: Icons.backspace_outlined,
                    type: _CalculatorButtonType.action,
                    onTap: () => _input('⌫'),
                  ),
                  _CalculatorButton(
                    label: '÷',
                    type: _CalculatorButtonType.operator,
                    onTap: () => _input('÷'),
                  ),
                  _CalculatorButton(
                    label: '×',
                    type: _CalculatorButtonType.operator,
                    onTap: () => _input('×'),
                  ),
                  _CalculatorButton(
                    label: '7',
                    onTap: () => _input('7'),
                  ),
                  _CalculatorButton(
                    label: '8',
                    onTap: () => _input('8'),
                  ),
                  _CalculatorButton(
                    label: '9',
                    onTap: () => _input('9'),
                  ),
                  _CalculatorButton(
                    label: '-',
                    type: _CalculatorButtonType.operator,
                    onTap: () => _input('-'),
                  ),
                  _CalculatorButton(
                    label: '4',
                    onTap: () => _input('4'),
                  ),
                  _CalculatorButton(
                    label: '5',
                    onTap: () => _input('5'),
                  ),
                  _CalculatorButton(
                    label: '6',
                    onTap: () => _input('6'),
                  ),
                  _CalculatorButton(
                    label: '+',
                    type: _CalculatorButtonType.operator,
                    onTap: () => _input('+'),
                  ),
                  _CalculatorButton(
                    label: '1',
                    onTap: () => _input('1'),
                  ),
                  _CalculatorButton(
                    label: '2',
                    onTap: () => _input('2'),
                  ),
                  _CalculatorButton(
                    label: '3',
                    onTap: () => _input('3'),
                  ),
                  _CalculatorButton(
                    label: '=',
                    type: _CalculatorButtonType.primary,
                    onTap: _submit,
                  ),
                  _CalculatorButton(
                    label: '0',
                    expanded: true,
                    onTap: () => _input('0'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _CalculatorButtonType {
  normal,
  operator,
  action,
  danger,
  primary,
}

class _CalculatorButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final _CalculatorButtonType type;
  final VoidCallback onTap;
  final bool expanded;

  const _CalculatorButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.type = _CalculatorButtonType.normal,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    Color background;
    Color foreground;

    switch (type) {
      case _CalculatorButtonType.primary:
        background = MyColors.primary;
        foreground = Colors.white;
        break;

      case _CalculatorButtonType.operator:
        background = MyColors.primaryLight;
        foreground = MyColors.primary;
        break;

      case _CalculatorButtonType.action:
        background = MyColors.surfaceSoft;
        foreground = MyColors.textSecondary;
        break;

      case _CalculatorButtonType.danger:
        background = MyColors.errorBg;
        foreground = MyColors.error;
        break;

      case _CalculatorButtonType.normal:
        background = MyColors.background;
        foreground = MyColors.textPrimary;
        break;
    }

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  color: foreground,
                  size: 19,
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
        ),
      ),
    );
  }
}
