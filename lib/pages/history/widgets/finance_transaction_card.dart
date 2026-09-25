import 'package:cashier_management/models/history_model.dart';
import 'package:cashier_management/utils/app_popup_menu.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinanceTransactionCard extends StatelessWidget {
  final DataHistory data;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FinanceTransactionCard({
    super.key,
    required this.data,
    this.onEdit,
    this.onDelete,
  });

  bool get isIncome => data.transactionType == 'PEMASUKAN';

  String _currency(int value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  String _timeLabel() {
    if (data.transactionDate == null || data.transactionDate!.trim().isEmpty) {
      return '-';
    }

    try {
      final date = DateTime.parse(data.transactionDate!);

      return DateFormat(
        'HH:mm',
        'id_ID',
      ).format(date);
    } catch (_) {
      return '-';
    }
  }

  Widget _buildOutletChip(String branch) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 150,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: MyColors.primaryLight,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.storefront_outlined,
            size: 11,
            color: MyColors.primary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              branch,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: MyColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: MyColors.surfaceSoft,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time_rounded,
            size: 11,
            color: MyColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            _timeLabel(),
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: MyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashier(String cashier) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.person_outline_rounded,
          size: 11,
          color: MyColors.textMuted,
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            cashier,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9.5,
              color: MyColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? MyColors.success : MyColors.error;
    final softColor = isIncome ? MyColors.successBg : MyColors.errorBg;

    final transactionName = data.transactionName?.trim().isNotEmpty == true
        ? data.transactionName!.trim()
        : 'Transaksi';

    final branch = data.cabang?.trim() ?? '';
    final cashier = data.namaKasir?.trim() ?? '';
    final note = data.note?.trim() ?? '';

    return Container(
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ICON TRANSAKSI
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: color,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          // INFORMASI TRANSAKSI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAMA TRANSAKSI
                Text(
                  transactionName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: MyColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                // OUTLET + JAM
                Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: [
                    if (branch.isNotEmpty) _buildOutletChip(branch),
                    _buildTimeChip(),
                  ],
                ),

                // CATATAN
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: MyColors.textMuted,
                    ),
                  ),
                ],

                // KASIR
                if (cashier.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  _buildCashier(cashier),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          // NOMINAL + MENU
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}${_currency(data.amount ?? 0)}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(height: 1),
              AppPopupMenu(
                items: [
                  if (onEdit != null)
                    const AppPopupMenuItem(
                      value: 'edit',
                      label: 'Edit Transaksi',
                      icon: Icons.edit_outlined,
                    ),
                  if (onDelete != null)
                    const AppPopupMenuItem(
                      value: 'delete',
                      label: 'Hapus Transaksi',
                      icon: Icons.delete_outline_rounded,
                      color: MyColors.error,
                    ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                      break;

                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
