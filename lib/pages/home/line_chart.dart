import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/models/chart_model.dart';
import 'package:cashier_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class LineChartSample1 extends StatelessWidget {
  const LineChartSample1({super.key});

  @override
  Widget build(BuildContext context) {
    final TotalPerTypeController controller =
        Get.find<TotalPerTypeController>();

    return Obx(() {
      final data = controller.resultChartItem.toList();

      if (data.isEmpty) {
        return const SizedBox.shrink();
      }

      return LineChart(
        _buildChartData(data),
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  LineChartData _buildChartData(List<DataListChart> data) {
    final double maxY = _calculateMaxY(data);

    return LineChartData(
      minX: _calculateMinX(data),
      maxX: _calculateMaxX(data),
      minY: 0,
      maxY: maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _calculateInterval(maxY),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: MyColors.border.withValues(alpha: .55),
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: false,
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: _leftTitles(maxY),
        ),
        bottomTitles: AxisTitles(
          sideTitles: _bottomTitles(data),
        ),
      ),
      lineBarsData: [
        _incomeLine(data),
        _expenseLine(data),
      ],
      lineTouchData: _touchData(data),
      extraLinesData: ExtraLinesData(
        horizontalLines: [],
      ),
    );
  }

  double _calculateMinX(List<DataListChart> data) {
    if (data.isEmpty) return 1;

    int minMonth = data.first.month ?? 1;

    for (final item in data) {
      final month = item.month ?? 1;

      if (month < minMonth) {
        minMonth = month;
      }
    }

    return minMonth.toDouble();
  }

  double _calculateMaxX(List<DataListChart> data) {
    if (data.isEmpty) return 12;

    int maxMonth = data.first.month ?? 12;

    for (final item in data) {
      final month = item.month ?? 12;

      if (month > maxMonth) {
        maxMonth = month;
      }
    }

    return maxMonth.toDouble();
  }

  double _calculateMaxY(List<DataListChart> data) {
    double maxValue = 0;

    for (final item in data) {
      final income = (item.income ?? 0).toDouble();
      final expense = (item.expense ?? 0).toDouble();

      if (income > maxValue) {
        maxValue = income;
      }

      if (expense > maxValue) {
        maxValue = expense;
      }
    }

    final double valueInMillion = maxValue / 1000000;

    if (valueInMillion <= 0) {
      return 1;
    }

    if (valueInMillion <= 1) {
      return 1.2;
    }

    if (valueInMillion <= 2) {
      return 2.4;
    }

    if (valueInMillion <= 5) {
      return 6;
    }

    if (valueInMillion <= 10) {
      return 12;
    }

    if (valueInMillion <= 20) {
      return 24;
    }

    if (valueInMillion <= 50) {
      return 60;
    }

    final double rounded = ((valueInMillion / 10).ceil() * 10).toDouble();

    return rounded;
  }

  double _calculateInterval(double maxY) {
    if (maxY <= 1.2) {
      return .2;
    }

    if (maxY <= 2.4) {
      return .4;
    }

    if (maxY <= 6) {
      return 1;
    }

    if (maxY <= 12) {
      return 2;
    }

    if (maxY <= 24) {
      return 4;
    }

    if (maxY <= 60) {
      return 10;
    }

    return 10;
  }

  SideTitles _leftTitles(double maxY) {
    return SideTitles(
      showTitles: true,
      reservedSize: 38,
      interval: _calculateInterval(maxY),
      getTitlesWidget: (value, meta) {
        if (value < 0) {
          return const SizedBox.shrink();
        }

        final String text;

        if (value >= 1) {
          text = '${_formatNumber(value)}Jt';
        } else {
          text = '${(value * 1000).round()}K';
        }

        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 6,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w500,
              color: MyColors.textMuted,
            ),
          ),
        );
      },
    );
  }

  SideTitles _bottomTitles(List<DataListChart> data) {
    final bool showEveryMonth = data.length <= 7;

    return SideTitles(
      showTitles: true,
      reservedSize: 28,
      interval: 1,
      getTitlesWidget: (value, meta) {
        final int month = value.toInt();

        if (month < 1 || month > 12) {
          return const SizedBox.shrink();
        }

        /*
         * Kalau data <= 7 bulan:
         * tampilkan semua bulan.
         *
         * Kalau 12 bulan:
         * tampilkan Jan, Mar, Mei, Jul, Sep, Nov
         * supaya tidak bertabrakan.
         */
        if (!showEveryMonth && month.isEven) {
          return const SizedBox.shrink();
        }

        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 6,
          child: Text(
            _monthName(month),
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: MyColors.textMuted,
            ),
          ),
        );
      },
    );
  }

  LineChartBarData _incomeLine(List<DataListChart> data) {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: .25,
      barWidth: 2.5,
      color: MyColors.primary,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 3,
            color: MyColors.primary,
            strokeWidth: 2,
            strokeColor: MyColors.surface,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: MyColors.primary.withValues(alpha: .06),
      ),
      spots: data
          .where((item) => item.month != null)
          .map(
            (item) => FlSpot(
              item.month!.toDouble(),
              (item.income ?? 0) / 1000000,
            ),
          )
          .toList(),
    );
  }

  LineChartBarData _expenseLine(List<DataListChart> data) {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: .25,
      barWidth: 2.5,
      color: MyColors.error,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 3,
            color: MyColors.error,
            strokeWidth: 2,
            strokeColor: MyColors.surface,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
      spots: data
          .where((item) => item.month != null)
          .map(
            (item) => FlSpot(
              item.month!.toDouble(),
              (item.expense ?? 0) / 1000000,
            ),
          )
          .toList(),
    );
  }

  LineTouchData _touchData(List<DataListChart> data) {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchSpotThreshold: 20,
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: barData.color?.withValues(alpha: .25),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
            FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: bar.color ?? MyColors.primary,
                  strokeWidth: 2,
                  strokeColor: MyColors.surface,
                );
              },
            ),
          );
        }).toList();
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) {
          return MyColors.textPrimary.withValues(alpha: .92);
        },
        tooltipRoundedRadius: 10,
        tooltipPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final int month = spot.x.toInt();

            final String type =
                spot.barIndex == 0 ? 'Pemasukan' : 'Pengeluaran';

            final int value = (spot.y * 1000000).round();

            return LineTooltipItem(
              '${_monthName(month)}\n'
              '$type\n'
              '${_formatRupiah(value)}',
              TextStyle(
                color: spot.bar.color ?? Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            );
          }).toList();
        },
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MEI',
      'JUN',
      'JUL',
      'AGU',
      'SEP',
      'OKT',
      'NOV',
      'DES',
    ];

    if (month < 1 || month > 12) {
      return '';
    }

    return months[month - 1];
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
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
