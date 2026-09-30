import 'package:cashier_management/models/monitoring_outlet_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:cashier_management/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonitoringTransactionCard extends StatelessWidget {
  final List<DataTransaction> transactions;

  const MonitoringTransactionCard({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate();

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        30,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final date = grouped.keys.elementAt(index);
            final items = grouped[date]!;

            return _DateGroup(
              date: date,
              items: items,
            );
          },
          childCount: grouped.length,
        ),
      ),
    );
  }

  Map<String, List<DataTransaction>> _groupByDate() {
    final Map<String, List<DataTransaction>> grouped = {};

    for (final item in transactions) {
      if (item.transactionDate == null) continue;

      final date = DateTime.parse(
        item.transactionDate!,
      );

      final key = DateFormat(
        'yyyy-MM-dd',
      ).format(date);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }

    final entries = grouped.entries.toList();

    entries.sort(
      (a, b) => b.key.compareTo(a.key),
    );

    return Map.fromEntries(entries);
  }
}

// ================================================================
// DATE GROUP
// ================================================================

class _DateGroup extends StatelessWidget {
  final String date;
  final List<DataTransaction> items;

  const _DateGroup({
    required this.date,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.parse(date);

    final validItems = items.where(
      (element) => !(element.deleteStatus ?? false),
    );

    final total = validItems.fold<int>(
      0,
      (sum, item) => sum + (item.grandTotal ?? 0),
    );

    final itemCount = validItems.fold<int>(
      0,
      (sum, item) =>
          sum +
          (item.details?.fold<int>(
                0,
                (detailSum, detail) => detailSum + (detail.quantity ?? 0),
              ) ??
              0),
    );

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------
          // DATE HEADER
          // ------------------------------------------------------

          Padding(
            padding: const EdgeInsets.only(
              bottom: 9,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: MyColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat(
                          'dd',
                        ).format(parsedDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'MMM',
                          'id_ID',
                        ).format(parsedDate).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat(
                          'EEEE',
                          'id_ID',
                        ).format(parsedDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: MyColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat(
                          'MMMM yyyy',
                          'id_ID',
                        ).format(parsedDate),
                        style: const TextStyle(
                          fontSize: 11,
                          color: MyColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyFormat.convertToIdr(
                        total,
                        0,
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: MyColors.primary,
                      ),
                    ),
                    Text(
                      '$itemCount item',
                      style: const TextStyle(
                        fontSize: 10,
                        color: MyColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // TRANSACTIONS
          // ------------------------------------------------------

          ...items.map(
            (item) => _TransactionCard(
              item: item,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// TRANSACTION CARD
// ================================================================

class _TransactionCard extends StatelessWidget {
  final DataTransaction item;

  const _TransactionCard({
    required this.item,
  });

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return _TransactionDetail(
          item: item,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = item.transactionDate != null
        ? DateTime.parse(item.transactionDate!)
        : null;

    final isDeleted = item.deleteStatus ?? false;

    final transactionNumber = 'HIMALAYA/${item.branchCode ?? '-'}'
        '/${(item.numerator ?? 0).toString().padLeft(4, '0')}';

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDetail(context),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDeleted
                    ? MyColors.error.withOpacity(.25)
                    : MyColors.border,
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDeleted
                            ? MyColors.errorBg
                            : MyColors.primaryLight,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        isDeleted
                            ? Icons.cancel_rounded
                            : Icons.receipt_long_rounded,
                        color: isDeleted ? MyColors.error : MyColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactionNumber,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isDeleted
                                  ? MyColors.error
                                  : MyColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              if (date != null)
                                Text(
                                  DateFormat(
                                    'HH:mm',
                                  ).format(date),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: MyColors.textMuted,
                                  ),
                                ),
                              const _Dot(),
                              Flexible(
                                child: Text(
                                  item.cashierName ?? 'Unknown Cashier',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: MyColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormat.convertToIdr(
                            item.grandTotal,
                            0,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color:
                                isDeleted ? MyColors.error : MyColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.background,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.paymentMethod ?? 'Cash',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: MyColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 15,
                      color: MyColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${item.totalItem ?? 0} item',
                      style: const TextStyle(
                        fontSize: 11,
                        color: MyColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Lihat detail',
                      style: TextStyle(
                        fontSize: 11,
                        color: MyColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 17,
                      color: MyColors.primary,
                    ),
                  ],
                ),
                if (isDeleted) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: MyColors.errorBg,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 15,
                          color: MyColors.error,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Transaksi dibatalkan'
                            '${item.deleteReason != null && item.deleteReason!.isNotEmpty ? ': ${item.deleteReason}' : ''}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: MyColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// DETAIL
// ================================================================

class _TransactionDetail extends StatelessWidget {
  final DataTransaction item;

  const _TransactionDetail({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final date = item.transactionDate != null
        ? DateTime.parse(item.transactionDate!)
        : null;

    final isDeleted = item.deleteStatus ?? false;

    final transactionNumber = 'HIMALAYA/${item.branchCode ?? '-'}'
        '/${(item.numerator ?? 0).toString().padLeft(4, '0')}';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MyColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detail Transaksi',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: MyColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transactionNumber,
                          style: const TextStyle(
                            fontSize: 11,
                            color: MyColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDeleted ? MyColors.errorBg : MyColors.successBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isDeleted ? 'Dibatalkan' : 'Selesai',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isDeleted ? MyColors.error : MyColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: MyColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.calendar_today_rounded,
                      title: 'Tanggal',
                      value: date == null
                          ? '-'
                          : DateFormat(
                              'dd MMMM yyyy, HH:mm',
                              'id_ID',
                            ).format(date),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.person_outline_rounded,
                      title: 'Kasir',
                      value: item.cashierName ?? '-',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.payments_outlined,
                      title: 'Pembayaran',
                      value: item.paymentMethod ?? 'Cash',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Detail Produk',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: MyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: MyColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    if (item.details != null)
                      ...item.details!.map(
                        (detail) => Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detail.productName ?? 'Unknown Product',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: MyColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      '${detail.quantity ?? 0} item',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: MyColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                CurrencyFormat.convertToIdr(
                                  detail.totalPrice,
                                  0,
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: MyColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: MyColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total Transaksi',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: MyColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      CurrencyFormat.convertToIdr(
                        item.grandTotal,
                        0,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: MyColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDeleted) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MyColors.errorBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Alasan pembatalan:\n${item.deleteReason ?? '-'}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: MyColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// INFO ROW
// ================================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: MyColors.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: MyColors.textMuted,
            ),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: MyColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// DOT
// ================================================================

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      decoration: const BoxDecoration(
        color: MyColors.textMuted,
        shape: BoxShape.circle,
      ),
    );
  }
}
