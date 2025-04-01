import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/dashboard/views/widgets/line_chart.dart';
import 'package:pharmacy_pos/modules/dashboard/views/widgets/pie_chart.dart';
import 'package:pharmacy_pos/widgets/amount_card.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../controllers/dashboard_controller.dart';
import 'widgets/bar_chart.dart';

//This Month sale/purchase/qty/profit
//today Sale/Purchase/qty/today payment received
class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentYear = DateFormat.y().format(now);
    return Scaffold(body: SingleChildScrollView(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const LinearProgressIndicator();
        } else {
          return Column(
            children: [
              dashboardCard(now),
              chartWidget(currentYear),
              stockAlertWidget()
            ],
          );
        }
      }),
    ));
  }

  Widget stockAlertWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
      child: Card(
        color: Colors.white,
        child: Obx(() {
          controller.tableHeight =
              ((controller.stockAlertList.length + 1) * 50);
          return Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Stock Alert",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  // color: Colors.blueGrey.withOpacity(0.2),
                  height: controller.tableHeight,
                  child: DataTable2(
                      headingRowColor: WidgetStateColor.resolveWith(
                          (states) => Colors.blueGrey.withOpacity(0.2)),
                      headingRowHeight: 50,
                      dataRowHeight: 50,
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: const [
                        DataColumn2(
                          label: Text('NO'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('PRODUCT'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('UNIT'),
                          size: ColumnSize.S,
                          //numeric: true
                        ),
                        DataColumn2(
                          label: Text('QUANTITY'),
                          size: ColumnSize.S,
                          //numeric: true
                        ),
                        DataColumn2(
                          label: Text('ALERT LEVEL'),
                          size: ColumnSize.S,
                          //numeric: true
                        ),
                        // DataColumn2(
                        //     label: Text('Unit Price'),
                        //     size: ColumnSize.S,
                        //     numeric: true),
                        DataColumn2(
                          size: ColumnSize.M,
                          label: Text('WAREHOUSE'),
                          // numeric: false,
                        ),
                      ],
                      rows: List<DataRow>.generate(
                          controller.stockAlertList.length,
                          (index) => DataRow(cells: [
                                DataCell(Text("${index + 1}")),
                                DataCell(Text(controller
                                    .stockAlertList[index].productName!
                                    .split(',')[0])),
                                DataCell(Text(
                                    controller.stockAlertList[index].unitName ??
                                        "")),
                                DataCell(Text(controller
                                    .stockAlertList[index].quantity
                                    .toString())),
                                DataCell(Text(controller
                                    .stockAlertList[index].alertLevel
                                    .toString())),
                                // DataCell(Text(controller
                                //     .purchaseItemList[index]
                                //     .productPrice
                                //     .toString())),
                                DataCell(Text(controller
                                        .stockAlertList[index].warehouseName ??
                                    "")),
                              ]))),
                ),
                Center(
                    child: controller.stockAlertList.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("No Data Avaliable"),
                          )
                        : Container())
              ],
            ),
          );
        }),
      ),
    );
  }

  ResponsiveGridRow chartWidget(String currentYear) {
    return ResponsiveGridRow(children: [
      ResponsiveGridCol(
        lg: 8,
        // md: 6,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 10),
          child: Card(
            color: Colors.white,
            child: Container(
                //color: Colors.amber,
                padding: const EdgeInsets.only(left: 30, right: 70, bottom: 10),
                height: 300,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Daily Sales & Purchases',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            //letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: 120,
                            child: DropdownSearch<String>(
                              popupProps: const PopupProps.menu(
                                constraints: BoxConstraints(maxHeight: 100),
                                searchDelay: Duration.zero,
                              ),
                              // asyncItems: (String filter) =>
                              //     controller.getAllWarehouses(),
                              items: const ["LineChart", "BarChart"],

                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Select Chart",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              selectedItem: controller.selectedChart.value,
                              onChanged: (value) {
                                controller.selectedChart.value = value!;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 26,
                          height: 14,
                          color: Colors.indigo,
                        ),
                        const SizedBox(width: 5),
                        const Text("Sales"),
                        const SizedBox(width: 8),
                        Container(
                          width: 26,
                          height: 14,
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 5),
                        const Text("Purchases")
                      ],
                    ),
                    const SizedBox(height: 5),
                    Flexible(child: Obx(() {
                      if (controller.selectedChart.value == "LineChart") {
                        return const LineChartView();
                      } else {
                        return const BarChartView();
                      }
                    })),
                  ],
                )),
          ),
        ),
      ),
      ResponsiveGridCol(
        lg: 4,
        //md: 6,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
          child: Card(
            color: Colors.white,
            child: SizedBox(
              //color: Colors.blue,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Top Selling Products ($currentYear)',
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        //letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  //const SizedBox(height: 10),
                  const Flexible(child: PieChartView()),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }

  Widget dashboardCard(DateTime now) {
    return Obx(() {
      //final now = DateTime.now();
      final currentMonth = DateFormat.MMM().format(now);
      return Padding(
        padding: const EdgeInsets.only(top: 5, left: 5, right: 20),
        child: Column(
          children: [
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                lg: 3,
                md: 4,
                child: AmountCard(
                    color: Colors.indigo,
                    icon: Icons.shopping_cart,
                    title: controller.salesTotalData.value != null
                        ? controller.salesTotalData.value!.totalSalesAmount
                            .toString()
                        : "0",
                    subTitle: "$currentMonth Sales"),
              ),
              ResponsiveGridCol(
                lg: 3,
                md: 4,
                child: AmountCard(
                    color: Colors.teal,
                    icon: Icons.add_shopping_cart,
                    title: controller.purchaseTotalData.value != null
                        ? controller
                            .purchaseTotalData.value!.totalPurchaseAmount
                            .toString()
                        : "0",
                    subTitle: "$currentMonth Purchases"),
              ),
              ResponsiveGridCol(
                lg: 3,
                md: 4,
                child: AmountCard(
                    color: Colors.blue,
                    icon: Icons.shopping_basket,
                    title: controller.salesTotalData.value != null
                        ? controller.salesTotalData.value!.totalQuantitySold
                            .toString()
                        : "0",
                    subTitle: "$currentMonth Quantity Sold"),
              ),
              ResponsiveGridCol(
                lg: 3,
                md: 4,
                child: AmountCard(
                    color: Colors.deepOrange,
                    icon: Icons.attach_money,
                    title: controller.salesTotalData.value != null
                        ? controller.salesTotalData.value!.totalProfit
                            .toString()
                        : "0",
                    subTitle: "$currentMonth Profit"),
              )
            ]),
            ResponsiveGridRow(children: [
              ResponsiveGridCol(
                lg: 3,
                md: 4,
                child: AmountCard(
                    color: Colors.deepPurple,
                    icon: Icons.shopping_cart,
                    title: controller.salesTotalTodayData.value != null
                        ? controller.salesTotalTodayData.value!.totalSalesAmount
                            .toString()
                        : "0",
                    subTitle: "Today Sales"),
              ),
              ResponsiveGridCol(
                lg: 3,
                md: 4,
                child: AmountCard(
                    color: Colors.pink,
                    icon: Icons.add_shopping_cart,
                    title: controller.purchaseTotalTodayData.value != null
                        ? controller
                            .purchaseTotalTodayData.value!.totalPurchaseAmount
                            .toString()
                        : "0",
                    subTitle: "Today Purchases"),
              ),
              ResponsiveGridCol(
                lg: 3,
                md: 4,
                child: AmountCard(
                    color: Colors.blueAccent,
                    icon: Icons.shopping_basket,
                    title: controller.salesTotalTodayData.value != null
                        ? controller.salesTotalTodayData.value!.totalSalesAmount
                            .toString()
                        : "0",
                    subTitle: "Today Quantity Sold"),
              ),
              ResponsiveGridCol(
                lg: 3,
                md: 4,
                child: AmountCard(
                    color: Colors.cyan,
                    icon: Icons.attach_money,
                    title: controller.salesTotalTodayData.value != null
                        ? controller.salesTotalTodayData.value!.totalProfit
                            .toString()
                        : "0",
                    subTitle: "Today Profit"),
              )
            ]),
          ],
        ),
      );
    });
  }
}
