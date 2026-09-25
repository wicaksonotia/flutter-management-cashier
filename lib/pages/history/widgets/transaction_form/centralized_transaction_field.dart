import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CentralizedTransactionField extends StatelessWidget {
  final TransactionController controller;

  const CentralizedTransactionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final selected = controller.isCentralized.value;

        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            controller.isCentralized.value = !selected;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected ? MyColors.primaryLight : MyColors.surface,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected ? MyColors.selectedBorder : MyColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: selected ? MyColors.primary : MyColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    color: selected ? Colors.white : MyColors.primary,
                    size: 20,
                  ),
                ),
                const Gap(12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaksi Terpusat',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: MyColors.textPrimary,
                        ),
                      ),
                      Gap(3),
                      Text(
                        'Gunakan transaksi untuk seluruh outlet',
                        style: TextStyle(
                          fontSize: 11,
                          color: MyColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: selected,
                  activeTrackColor: MyColors.primary,
                  onChanged: (value) {
                    controller.isCentralized.value = value;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
