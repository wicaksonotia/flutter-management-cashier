import 'package:cashier_management/pages/home/line_chart.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeSalesChart extends StatelessWidget {
  const HomeSalesChart({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Penjualan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MyColors.textMuted,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Rp 28,4 Jt',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: MyColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Spacer(),
              _ChartLegend(),
            ],
          ),
          SizedBox(height: 18),
          SizedBox(
            height: 190,
            child: LineChartSample1(),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: MyColors.primaryLight,
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.circle,
            size: 7,
            color: MyColors.primary,
          ),
          SizedBox(width: 5),
          Text(
            'Penjualan',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: MyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
