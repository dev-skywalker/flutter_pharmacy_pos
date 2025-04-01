import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class LineChartWithResponse extends StatefulWidget {
  const LineChartWithResponse({super.key});

  @override
  State<LineChartWithResponse> createState() => _LineChartWithResponseState();
}

class _LineChartWithResponseState extends State<LineChartWithResponse> {
  //late bool isShowingMainData;
  final List<Map<String, dynamic>> response = [
    {"date": "2024-11-20", "sales": 0, "purchases": 21800},
    {"date": "2024-11-21", "sales": 0, "purchases": 0},
    {"date": "2024-11-22", "sales": 0, "purchases": 0},
    {"date": "2024-11-23", "sales": 0, "purchases": 0},
    {"date": "2024-11-24", "sales": 4990, "purchases": 0},
    {"date": "2024-11-25", "sales": 6000, "purchases": 1600},
    {"date": "2024-11-26", "sales": 0, "purchases": 0}
  ];

  @override
  void initState() {
    super.initState();
    //isShowingMainData = true;
  }

  List<FlSpot> getSalesSpots() {
    return response
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value['sales'] as num).toDouble(),
            ))
        .toList();
  }

  List<FlSpot> getPurchasesSpots() {
    return response
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value['purchases'] as num).toDouble(),
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
      if (index >= 0 && index < response.length) {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(
            response[index]['date'].toString(), // MM-DD format
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
    return Scaffold(
//backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Sales & Purchases Chart"),
        //backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              // width: 500,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.only(right: 40),
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Daily Sales & Purchases',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: LineChart(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.linear,
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: false,
                                color: AppColors.contentColorGreen,
                                barWidth: 4,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: false),
                                spots: getSalesSpots(),
                              ),
                              LineChartBarData(
                                isCurved: false,
                                color: AppColors.contentColorPink,
                                barWidth: 4,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: false),
                                spots: getPurchasesSpots(),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 5000,
                                  getTitlesWidget: leftTitleWidgets,
                                  reservedSize: 40,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                axisNameSize: 100,
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: bottomTitleWidgets,
                                  reservedSize: 150,
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
                                bottom:
                                    BorderSide(color: Colors.black, width: 1),
                                left: BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                            minX: 0,
                            maxX: response.length.toDouble() - 1,
                            minY: 0,
                            maxY: response
                                    .map((e) => (e['sales'] as num) >
                                            (e['purchases'] as num)
                                        ? (e['sales'] as num)
                                        : (e['purchases'] as num))
                                    .reduce((a, b) => a > b ? a : b)
                                    .toDouble() +
                                5000,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 500, child: BarChartSample2()),
            const SizedBox(height: 300, child: BestSellingItemsChart())
          ],
        ),
      ),
    );
  }
}

class BarChartSample2 extends StatefulWidget {
  const BarChartSample2({super.key});
  final Color leftBarColor = AppColors.contentColorCyan;
  final Color rightBarColor = AppColors.contentColorPink;
  final Color avgColor = AppColors.contentColorGreen;

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  //final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  //int touchedGroupIndex = -1;

  // Response data (sales and purchases data)
  final List<Map<String, dynamic>> response = [
    {"date": "2024-11-20", "sales": 0, "purchases": 21800},
    {"date": "2024-11-21", "sales": 0, "purchases": 0},
    {"date": "2024-11-22", "sales": 0, "purchases": 0},
    {"date": "2024-11-23", "sales": 0, "purchases": 0},
    {"date": "2024-11-24", "sales": 4990, "purchases": 0},
    {"date": "2024-11-25", "sales": 6000, "purchases": 1600},
    {"date": "2024-11-26", "sales": 0, "purchases": 0}
  ];

  @override
  void initState() {
    super.initState();

    // Create bar groups using sales and purchases data from response
    rawBarGroups = List.generate(response.length, (index) {
      return makeGroupData(
        index,
        response[index]["sales"].toDouble(),
        response[index]["purchases"].toDouble(),
      );
    });

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Daily Sales & Purchases',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BarChart(
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
                  maxY: response
                          .map((e) =>
                              (e['sales'] as num) > (e['purchases'] as num)
                                  ? (e['sales'] as num)
                                  : (e['purchases'] as num))
                          .reduce((a, b) => a > b ? a : b)
                          .toDouble() +
                      5000, // Set maxY value based on your data
                  rangeAnnotations: RangeAnnotations(
                      horizontalRangeAnnotations: [
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
                        reservedSize: 40,
                        interval:
                            5000, // Set appropriate interval based on your data
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  // borderData: FlBorderData(
                  //   show: false,
                  // ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
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
    String date = response[value.toInt()]['date'];

    final Widget text = Text(
      date.substring(5), // Only show the MM-DD part of the date
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
          color: widget.leftBarColor,
          width: 7,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: 7,
        ),
      ],
    );
  }

  // Icon for the transactions section
  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}

class BestSellingItemsChart extends StatefulWidget {
  const BestSellingItemsChart({super.key});

  @override
  State<StatefulWidget> createState() => _BestSellingItemsChartState();
}

class _BestSellingItemsChartState extends State<BestSellingItemsChart> {
  int touchedIndex = -1;

  // Best selling items data
  final List<Map<String, dynamic>> bestSellingItems = [
    {"productName": "Product One", "Qty": 40, "color": Colors.blue},
    {"productName": "Product Two", "Qty": 20, "color": Colors.yellow},
    {"productName": "Product Three", "Qty": 50, "color": Colors.purple},
    {"productName": "Product Four", "Qty": 18, "color": Colors.green},
    {"productName": "Product Five", "Qty": 10, "color": Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bestSellingItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Indicator(
                  color: item["color"] as Color,
                  text: item["productName"] as String,
                  isSquare: true,
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return bestSellingItems.asMap().entries.map((entry) {
      final int index = entry.key;
      final Map<String, dynamic> data = entry.value;

      final bool isTouched = index == touchedIndex;
      //final double fontSize = isTouched ? 16.0 : 14.0;
      final double radius = isTouched ? 60.0 : 50.0;
      //const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        showTitle: isTouched,
        color: data["color"] as Color,
        value: (data["Qty"] as num).toDouble(),
        title: '${data["productName"]}', // Display quantity
        radius: radius,
        titleStyle: TextStyle(
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
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
