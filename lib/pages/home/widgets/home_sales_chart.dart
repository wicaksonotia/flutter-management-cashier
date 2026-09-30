import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/pages/home/line_chart.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSalesChart extends StatelessWidget {
  const HomeSalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final TotalPerTypeController controller =
        Get.find<TotalPerTypeController>();

    return Obx(() {
      if (controller.isLoadingChart.value) {
        return const _ChartLoading();
      }

      final data = controller.resultChartItem.toList();

      if (data.isEmpty) {
        return const _ChartEmpty();
      }

      final totalIncome = data.fold<int>(
        0,
        (sum, item) => sum + (item.income ?? 0),
      );

      final totalExpense = data.fold<int>(
        0,
        (sum, item) => sum + (item.expense ?? 0),
      );

      return Container(
        padding: const EdgeInsets.fromLTRB(
          14,
          18,
          14,
          12,
        ),
        decoration: BoxDecoration(
          color: MyColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: MyColors.border,
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Arus Keuangan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MyColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatRupiah(totalIncome),
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: MyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Total pemasukan',
                      style: TextStyle(
                        fontSize: 10,
                        color: MyColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _LegendItem(
                      iconColor: MyColors.primary,
                      label: 'Pemasukan',
                    ),
                    SizedBox(height: 6),
                    _LegendItem(
                      iconColor: MyColors.error,
                      label: 'Pengeluaran',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            const SizedBox(
              height: 190,
              child: LineChartSample1(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    label: 'Pemasukan',
                    value: _formatRupiah(totalIncome),
                    icon: Icons.arrow_downward_rounded,
                    iconColor: MyColors.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryItem(
                    label: 'Pengeluaran',
                    value: _formatRupiah(totalExpense),
                    icon: Icons.arrow_upward_rounded,
                    iconColor: MyColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  String _formatRupiah(int value) {
    if (value >= 1000000) {
      final juta = value / 1000000;

      if (juta == juta.roundToDouble()) {
        return 'Rp ${juta.toInt()} Jt';
      }

      return 'Rp ${juta.toStringAsFixed(1)} Jt';
    }

    if (value >= 1000) {
      final ribu = value / 1000;

      if (ribu == ribu.roundToDouble()) {
        return 'Rp ${ribu.toInt()}K';
      }

      return 'Rp ${ribu.toStringAsFixed(1)}K';
    }

    return 'Rp $value';
  }
}

class _LegendItem extends StatelessWidget {
  final Color iconColor;
  final String label;

  const _LegendItem({
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: MyColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: MyColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 14,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    color: MyColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: MyColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLoading extends StatelessWidget {
  const _ChartLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LoadingBox(
            width: 80,
            height: 12,
          ),
          SizedBox(height: 8),
          _LoadingBox(
            width: 130,
            height: 24,
          ),
          SizedBox(height: 20),
          Expanded(
            child: _LoadingBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartEmpty extends StatelessWidget {
  const _ChartEmpty();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: MyColors.border,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart_rounded,
            size: 34,
            color: MyColors.textMuted,
          ),
          SizedBox(height: 10),
          Text(
            'Belum ada data keuangan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: MyColors.textSecondary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Data grafik akan muncul setelah ada transaksi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: MyColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBox extends StatelessWidget {
  final double width;
  final double height;

  const _LoadingBox({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: MyColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
