import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 6),
              child: const _LineChart(),
            ),
          ),
          _buildLegend(),
        ],
      ),
    );
  }

  // 🔥 Legend
  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(Colors.green, "Income"),
          _legendItem(Colors.red, "Expense"),
          _legendItem(Colors.blue, "Balance"),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}

// ============================================================================
//                               MAIN CHART
// ============================================================================

class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) {
    final chartController = Get.find<TotalPerTypeController>();

    return Obx(
      () => LineChart(
        _data(chartController),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  // 🔥 Main Config Chart
  LineChartData _data(TotalPerTypeController c) {
    return LineChartData(
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 10, // juta
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: _bottomTitles),
        leftTitles: AxisTitles(sideTitles: _leftTitles),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        _incomeLine(c),
        _expenseLine(c),
        _balanceLine(c),
      ],
      lineTouchData: _touchData(),
    );
  }

  // ========================================================================
  //                               TOOLTIP
  // ========================================================================
  LineTouchData _touchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touched) => Colors.black.withOpacity(0.7),
        getTooltipItems: (spots) {
          return spots.map((spot) {
            final jutaValue = spot.y;
            final rupiah = jutaValue * 1_000_000;

            final formatted = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(rupiah);

            return LineTooltipItem(
              "${_monthName(spot.x.toInt())}\n$formatted",
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          }).toList();
        },
      ),
    );
  }

  String _monthName(int index) {
    const months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC",
    ];
    if (index < 1 || index > 12) return "";
    return months[index - 1];
  }

  // ========================================================================
  //                               TITLES
  // ========================================================================

  // Bottom months title
  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 32,
        getTitlesWidget: (value, meta) {
          const months = [
            "JAN",
            "FEB",
            "MAR",
            "APR",
            "MAY",
            "JUN",
            "JUL",
            "AUG",
            "SEP",
            "OCT",
            "NOV",
            "DEC"
          ];

          if (value.toInt() >= 1 && value.toInt() <= 12) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(
                months[value.toInt() - 1],
                style: TextStyle(
                  fontSize: MySizes.fontSizeXsm,
                  color: Colors.grey.shade600,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );

  // Left titles
  SideTitles get _leftTitles => SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          if (value % 1 != 0) return const SizedBox.shrink();

          return Text(
            "${value.toInt()} JT",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      );

  // ========================================================================
  //                               LINE DATA
  // ========================================================================

  LineChartBarData _incomeLine(TotalPerTypeController c) {
    return LineChartBarData(
      isCurved: false,
      barWidth: 4,
      color: Colors.green,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      spots: List.generate(
        c.resultChartItem.length,
        (i) => FlSpot(
          (i + 1).toDouble(),
          (c.resultChartItem[i].income ?? 0) / 1_000_000,
        ),
      ),
    );
  }

  LineChartBarData _expenseLine(TotalPerTypeController c) {
    return LineChartBarData(
      isCurved: false,
      barWidth: 4,
      color: Colors.red,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      spots: List.generate(
        c.resultChartItem.length,
        (i) => FlSpot(
          (i + 1).toDouble(),
          (c.resultChartItem[i].expense ?? 0) / 1_000_000,
        ),
      ),
    );
  }

  LineChartBarData _balanceLine(TotalPerTypeController c) {
    return LineChartBarData(
      isCurved: false,
      barWidth: 4,
      color: Colors.blue,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      spots: List.generate(
        c.resultChartItem.length,
        (i) {
          final income = c.resultChartItem[i].income ?? 0;
          final expense = c.resultChartItem[i].expense ?? 0;
          return FlSpot(
            (i + 1).toDouble(),
            (income - expense) / 1_000_000,
          );
        },
      ),
    );
  }
}
