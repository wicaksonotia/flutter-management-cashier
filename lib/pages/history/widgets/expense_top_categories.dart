import 'package:cashier_management/controllers/history_controller.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseTopCategories extends StatefulWidget {
  final HistoryController controller;

  const ExpenseTopCategories({
    super.key,
    required this.controller,
  });

  @override
  State<ExpenseTopCategories> createState() => _ExpenseTopCategoriesState();
}

class _ExpenseTopCategoriesState extends State<ExpenseTopCategories> {
  // Default: bagian pengeluaran tersembunyi.
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Obx(() {
      final items = controller.topExpenseCategories;

      if (controller.isLoadingHistory.value && items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: MyColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header untuk show/hide
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: MyColors.errorBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: MyColors.error,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pengeluaran Terbesar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: MyColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Berdasarkan total per kategori',
                          style: TextStyle(
                            fontSize: 11,
                            color: MyColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: MyColors.textSecondary,
                  ),
                ],
              ),
            ),

            // Konten hanya ditampilkan ketika dibuka.
            if (_isExpanded) ...[
              const SizedBox(height: 18),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'Belum ada data pengeluaran pada periode ini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  final name = item['name'] as String;
                  final total = item['total'] as int;
                  final count = item['count'] as int;
                  final maxTotal = items.first['total'] as int;

                  final ratio = maxTotal > 0 ? total / maxTotal : 0.0;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == items.length - 1 ? 0 : 17,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nomor peringkat
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: MyColors.surfaceSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: MyColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Nama kategori dan jumlah transaksi
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: MyColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '$count transaksi',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: MyColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Total pengeluaran
                            Text(
                              controller.formatRupiah(total),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: MyColors.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),

                        // Bar perbandingan total pengeluaran
                        Padding(
                          padding: const EdgeInsets.only(left: 38),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: ratio.clamp(0.0, 1.0).toDouble(),
                              minHeight: 6,
                              backgroundColor: MyColors.border,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                MyColors.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ],
        ),
      );
    });
  }
}
