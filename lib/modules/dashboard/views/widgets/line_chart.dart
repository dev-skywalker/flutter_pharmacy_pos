import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/dashboard/controllers/dashboard_controller.dart';

class LineChartView extends GetView<DashboardController> {
  const LineChartView({super.key});

  //late bool isShowingMainData;
  List<FlSpot> getSalesSpots() {
    return controller.chartList
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value.sales as num).toDouble(),
            ))
        .toList();
  }

  List<FlSpot> getPurchasesSpots() {
    return controller.chartList
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value.purchases as num).toDouble(),
            ))
        .toList();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    // Convert numeric value to shorthand format
    String formattedValue;
    if (value >= 1000000) {
      double scaledValue = value / 1000000;
      formattedValue = scaledValue % 1 == 0
          ? '${scaledValue.toInt()}M' // Remove .0 if whole number
          : '${scaledValue.toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      double scaledValue = value / 1000;
      formattedValue = scaledValue % 1 == 0
          ? '${scaledValue.toInt()}K' // Remove .0 if whole number
          : '${scaledValue.toStringAsFixed(1)}K';
    } else {
      formattedValue = value.toInt().toString(); // Default format
    }

    return Text(formattedValue, style: style);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    // Only process integer values
    if (value % 1 == 0) {
      int index = value.toInt();
      if (index >= 0 && index < controller.chartList.length) {
        final DateTime parsedDate =
            DateTime.parse(controller.chartList[index].date!);
        var formattedDate = DateFormat("ddMMM").format(parsedDate);
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(
            formattedDate, // MM-DD format
            style: style,
          ),
        );
      }
    }

    return const SizedBox
        .shrink(); // Return an empty widget for non-integer values
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LineChart(
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              isCurved: false,
              color: Colors.indigo,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              spots: controller.chartList.isNotEmpty ? getSalesSpots() : [],
            ),
            LineChartBarData(
              isCurved: false,
              color: Colors.teal,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              spots: controller.chartList.isNotEmpty ? getPurchasesSpots() : [],
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameSize: 50,
              sideTitles: SideTitles(
                showTitles: true,
                //interval: 50000,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 50,
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameSize: 100,
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitleWidgets,
                //reservedSize: 30,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.black, width: 1),
              left: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          gridData: const FlGridData(show: true),
          minX: 0,
          maxX: controller.chartList.isNotEmpty
              ? controller.chartList.length.toDouble() - 1
              : 0,
          minY: 0,
          maxY: controller.chartList.isNotEmpty
              ? controller.chartList
                      .map((e) => (e.sales as num) > (e.purchases as num)
                          ? (e.sales as num)
                          : (e.purchases as num))
                      .reduce((a, b) => a > b ? a : b)
                      .toDouble() +
                  10000
              : 0,
        ),
      );
    });
  }
}
