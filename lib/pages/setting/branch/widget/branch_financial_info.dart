import 'package:cashier_management/models/outlet_branch_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:flutter/material.dart';

class BranchFinancialInfo extends StatelessWidget {
  final DataListOutletBranch quotation;

  const BranchFinancialInfo({
    super.key,
    required this.quotation,
  });

  @override
  Widget build(BuildContext context) {
    final details = quotation.details;

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: MyColors.background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: MyColors.divider,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FinancialInfo(
              icon: Icons.arrow_downward_rounded,
              label: 'Pemasukan',
              value: details?.income ?? 0,
              iconColor: MyColors.success,
              backgroundColor: MyColors.successBg,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _FinancialInfo(
              icon: Icons.arrow_upward_rounded,
              label: 'Pengeluaran',
              value: details?.expense ?? 0,
              iconColor: MyColors.error,
              backgroundColor: MyColors.errorBg,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _FinancialInfo(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Saldo',
              value: details?.balance ?? 0,
              iconColor: MyColors.primary,
              backgroundColor: MyColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 38,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      color: MyColors.divider,
    );
  }
}

class _FinancialInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color iconColor;
  final Color backgroundColor;

  const _FinancialInfo({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icon,
                size: 12,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: MyColors.textMuted,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          CurrencyFormat.convertToIdr(
            value,
            0,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: MyColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
