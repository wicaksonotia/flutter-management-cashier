import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionController controller;

  const TransactionTypeSelector({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isIncome = controller.isIncome.value;

        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: MyColors.background,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: MyColors.border,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _TypeOption(
                  title: 'Pemasukan',
                  icon: Icons.arrow_downward_rounded,
                  selected: isIncome,
                  selectedColor: MyColors.success,
                  onTap: () {
                    controller.changeTransactionType(true);
                  },
                ),
              ),
              const Gap(5),
              Expanded(
                child: _TypeOption(
                  title: 'Pengeluaran',
                  icon: Icons.arrow_upward_rounded,
                  selected: !isIncome,
                  selectedColor: MyColors.error,
                  onTap: () {
                    controller.changeTransactionType(false);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _TypeOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected ? Colors.white : MyColors.textSecondary,
              ),
              const Gap(7),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : MyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
