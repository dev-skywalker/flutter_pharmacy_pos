import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/dashboard/controllers/dashboard_controller.dart';

class PieChartView extends GetView<DashboardController> {
  const PieChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        // alignment: Alignment.bottomRight,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 50, right: 60),
            //color: Colors.blueAccent,
            //height: 300,
            //alignment: Alignment.bottomCenter,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      controller.touchedIndex.value = -1;
                      return;
                    }
                    controller.touchedIndex.value =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingSections(),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.pieChartList.isNotEmpty
                  ? controller.pieChartList.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Indicator(
                          color: item.color as Color,
                          text: item.productName!.split(',')[0],
                          isSquare: true,
                        ),
                      );
                    }).toList()
                  : [],
            ),
          ),
        ],
      );
    });
  }

  List<PieChartSectionData> showingSections() {
    if (controller.pieChartList.isEmpty) return [];
    return controller.pieChartList.asMap().entries.map((entry) {
      final int index = entry.key;
      final data = entry.value;

      final bool isTouched = index == controller.touchedIndex.value;
      //final double fontSize = isTouched ? 16.0 : 14.0;
      final double radius = isTouched ? 60.0 : 50.0;
      //const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        showTitle: isTouched,
        color: data.color,
        value: data.qty?.toDouble(),
        title: '${data.productName}', // Display quantity
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          //color: Colors.white,
          //shadows: shadows,
        ),
      );
    }).toList();
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = const Color(0xff505050),
    super.key,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        SizedBox(
          width: 100,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}
