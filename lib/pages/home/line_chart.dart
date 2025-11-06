import 'package:cashier_management/controllers/total_per_type_controller.dart';
import 'package:cashier_management/utils/sizes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) {
    final chartController = Get.find<TotalPerTypeController>();

    return Obx(
      () => LineChart(
        sampleData1(chartController),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  LineChartData sampleData1(TotalPerTypeController chartController) =>
      LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1(chartController),
        minX: 0,
        maxX: 12,
        maxY: 7,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              Colors.blueGrey.withValues(alpha: 0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> lineBarsData1(
          TotalPerTypeController chartController) =>
      [
        lineChartBarData1_1(chartController),
        lineChartBarData1_2(chartController),
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1 Jt';
        break;
      case 2:
        text = '2 Jt';
        break;
      case 3:
        text = '3 Jt';
        break;
      case 4:
        text = '4 Jt';
        break;
      case 5:
        text = '5 Jt';
        break;
      case 6:
        text = '6 Jt';
        break;
      case 7:
        text = '7 Jt';
        break;
      // case 8:
      //   text = '8 Jt';
      //   break;
      // case 9:
      //   text = '9 Jt';
      //   break;
      // case 10:
      //   text = '10 Jt';
      //   break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 32,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.grey.shade500,
      fontSize: MySizes.fontSizeXsm,
    );
    String text;
    if (value.toInt() >= 0 && value.toInt() < 12) {
      const months = [
        'JAN',
        'FEB',
        'MAR',
        'APR',
        'MAY',
        'JUN',
        'JUL',
        'AUG',
        'SEP',
        'OCT',
        'NOV',
        'DEC'
      ];
      text = months[value.toInt()];
    } else {
      text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 35,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: Colors.black.withValues(alpha: 0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData lineChartBarData1_1(
          TotalPerTypeController chartController) =>
      LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          ...List.generate(
            chartController.resultChartItem.length,
            (index) => FlSpot(
              index.toDouble() + 1,
              (chartController.resultChartItem[index].income ?? 0) /
                  1000000.0, // 👉 convert to juta
            ),
          ),
        ],
      );

  LineChartBarData lineChartBarData1_2(
          TotalPerTypeController chartController) =>
      LineChartBarData(
        isCurved: true,
        color: Colors.pink, // bisa ganti misalnya Colors.blue untuk balance
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          ...List.generate(
            chartController.resultChartItem.length,
            (index) {
              final income = chartController.resultChartItem[index].income ?? 0;
              final expense =
                  chartController.resultChartItem[index].expense ?? 0;
              final balance = income - expense; // 👉 balance
              return FlSpot(
                index.toDouble() + 1,
                balance / 1000000.0, // convert ke juta
              );
            },
          ),
        ],
      );
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
