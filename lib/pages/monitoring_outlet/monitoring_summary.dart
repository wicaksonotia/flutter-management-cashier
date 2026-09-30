import 'package:cashier_management/controllers/monitoring_outlet_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonitoringSummary extends StatelessWidget {
  final MonitoringOutletController controller;

  const MonitoringSummary({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final income = controller.totalIncome.value;
        final expense = controller.totalExpense.value;
        final balance = controller.totalBalance.value;

        return Container(
          margin: const EdgeInsets.fromLTRB(
            16,
            14,
            16,
            0,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: MyColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Ringkasan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: MyColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.successBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controller.resultData.length} transaksi',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: MyColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      title: 'Pemasukan',
                      value: CurrencyFormat.convertToIdr(
                        income,
                        0,
                      ),
                      icon: Icons.arrow_downward_rounded,
                      color: MyColors.success,
                      background: MyColors.successBg,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryItem(
                      title: 'Pengeluaran',
                      value: CurrencyFormat.convertToIdr(
                        expense,
                        0,
                      ),
                      icon: Icons.arrow_upward_rounded,
                      color: MyColors.error,
                      background: MyColors.errorBg,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: MyColors.primaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 19,
                      color: MyColors.primary,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Saldo',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: MyColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(
                        balance,
                        0,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: MyColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color background;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
