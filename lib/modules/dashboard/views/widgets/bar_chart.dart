import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/dashboard/controllers/dashboard_controller.dart';

class BarChartView extends GetView<DashboardController> {
  const BarChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.chartList.isEmpty) {
        return Container();
      } else {
        return BarChart(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
          BarChartData(
            borderData: FlBorderData(
              show: true,
              border: const Border(
                bottom: BorderSide(color: Colors.black, width: 1),
                left: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            maxY: controller.chartList
                    .map((e) => (e.sales as num) > (e.purchases as num)
                        ? (e.sales as num)
                        : (e.purchases as num))
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble() +
                10000, // Set maxY value based on your data
            rangeAnnotations: RangeAnnotations(horizontalRangeAnnotations: [
              HorizontalRangeAnnotation(y1: 10, y2: 5)
            ]),
            barTouchData: BarTouchData(
              mouseCursorResolver: (FlTouchEvent event, response) {
                return SystemMouseCursors.click;
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: bottomTitles,
                  reservedSize: 42,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  //interval: 5000, // Set appropriate interval based on your data
                  getTitlesWidget: leftTitles,
                ),
              ),
            ),
            // borderData: FlBorderData(
            //   show: false,
            // ),
            barGroups: controller.showingBarGroups,
            gridData: const FlGridData(show: true),
          ),
        );
      }
    });
  }

  // Left titles - Show the amounts for the bars
  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    // String text;
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

    // return SideTitleWidget(
    //   axisSide: meta.axisSide,
    //   space: 0,
    //   child: Text(text, style: style),
    // );
    // const style = TextStyle(
    //   fontWeight: FontWeight.bold,
    //   fontSize: 14,
    // );
    return Text(formattedValue, style: style);
  }

  // Bottom titles - Show dates from the response
  Widget bottomTitles(double value, TitleMeta meta) {
    String date = controller.chartList[value.toInt()].date!;
    final DateTime parsedDate = DateTime.parse(date);
    var formattedDate = DateFormat("ddMMM").format(parsedDate);
    final Widget text = Text(
      formattedDate, // Only show the MM-DD part of the date
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  // Create bar group data using sales and purchases
  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.amber,
          //width: 100,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.red,
          //width: 100,
        ),
      ],
    );
  }
}
