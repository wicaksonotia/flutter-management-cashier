import 'package:cashier_management/controllers/transaction_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TransactionDateTimeField extends StatelessWidget {
  final TransactionController controller;

  const TransactionDateTimeField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Column(
          children: [
            _DateField(
              title: 'Tanggal transaksi',
              value: controller.formattedTransactionDate,
              icon: Icons.calendar_month_outlined,
              onTap: controller.showDialogDatePicker,
            ),
            const Gap(12),
            _DateField(
              title: 'Waktu transaksi',
              value: controller.formattedTransactionTime,
              icon: Icons.schedule_outlined,
              onTap: controller.showDialogTimePicker,
            ),
          ],
        );
      },
    );
  }
}

class _DateField extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _DateField({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColors.background,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: MyColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: MyColors.primary,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: MyColors.textSecondary,
                    ),
                  ),
                  const Gap(3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: MyColors.textPrimary,
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
  }
}
