import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/dashboard/models/purchase_total_model.dart';
import 'package:pharmacy_pos/modules/dashboard/repository/dashboard_repository.dart';
import 'package:pharmacy_pos/modules/stock_alert/model/stock_alert_model.dart';

import '../models/chart_model.dart';
import '../models/pie_chart_model.dart';
import '../models/sales_total_model.dart';

class DashboardController extends GetxController {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  RxList<StockAlertModel> stockAlertList = <StockAlertModel>[].obs;

  final DashboardRepository dashboardRepository;
  DashboardController(this.dashboardRepository);
  RxBool isLoading = false.obs;

  Rx<PurchaseTotalModel?> purchaseTotalData = Rx<PurchaseTotalModel?>(null);
  Rx<SalesTotalModel?> salesTotalData = Rx<SalesTotalModel?>(null);
  Rx<PurchaseTotalModel?> purchaseTotalTodayData =
      Rx<PurchaseTotalModel?>(null);
  Rx<SalesTotalModel?> salesTotalTodayData = Rx<SalesTotalModel?>(null);

  double tableHeight = 50;

  @override
  void onInit() {
    initFunction();
    super.onInit();
  }

  List<ChartModel> chartList = <ChartModel>[].obs;
  List<PieChartModel> pieChartList = <PieChartModel>[].obs;
  RxString selectedChart = "LineChart".obs;
  RxInt touchedIndex = (-1).obs;

  void initFunction() async {
    isLoading.value = true;
    try {
      List responses = await Future.wait([
        getSaleTotal(),
        getPurchaseTotal(),
        getSaleTotalToday(),
        getPurchaseTotalToday(),
        getChartData(),
        getPieChartData(),
        getStockAlertItems()
      ]);
      print(responses);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> getStockAlertItems() async {
    Map<String, dynamic> params = {
      // "filter": filter,
      "limit": 10,
      "offset": 0,
      // "sortBy": sortedBy,
      // "sortOrder": sortedAsc ? "asc" : "desc",
    };
    final response = await dashboardRepository.getStockAlertItems(params);
    if (response != null && response.statusCode == 200) {
      var data = response.data['data'] as List<dynamic>;
      print(data);
      for (var val in data) {
        stockAlertList.add(StockAlertModel.fromJson(val));
      }
    }
  }

  Future<void> getChartData() async {
    // final List<dynamic> response = [
    //   {"date": "2024-11-21", "sales": 0, "purchases": 0},
    //   {"date": "2024-11-22", "sales": 0, "purchases": 0},
    //   {"date": "2024-11-23", "sales": 0, "purchases": 0},
    //   {"date": "2024-11-24", "sales": 4990, "purchases": 0},
    //   // {"date": "2024-11-25", "sales": 6000, "purchases": 1600},
    //   // {"date": "2024-11-26", "sales": 0, "purchases": 0},
    //   // {"date": "2024-11-27", "sales": 0, "purchases": 0}
    // ];
    final response = await dashboardRepository.getChartData();

    if (response != null && response.statusCode == 200) {
      for (var val in response.data as List<dynamic>) {
        chartList.add(ChartModel.fromJson(val));
        rawBarGroups = List.generate(chartList.length, (index) {
          return makeGroupData(
            index,
            chartList[index].sales!.toDouble(),
            chartList[index].purchases!.toDouble(),
          );
        });

        showingBarGroups = rawBarGroups;
      }
    }
  }

  Future<void> getPieChartData() async {
    List<Color> colorList = [
      Colors.indigo,
      Colors.pink,
      Colors.teal,
      Colors.blue,
      Colors.deepOrange
    ];
    final response = await dashboardRepository.getPieChartData();
    if (response != null && response.statusCode == 200) {
      response.data.asMap().forEach((index, value) {
        pieChartList.add(PieChartModel(
            productName: value['productName'],
            qty: value['productQuantitySold'],
            color: colorList[index]));
      });
    }

    // final List<Map<String, dynamic>> bestSellingItems = [
    //   {"productName": "Product One", "qty": 40, "color": Colors.blue},
    //   {"productName": "Product Two", "qty": 20, "color": Colors.yellow},
    //   {"productName": "Product Three", "qty": 50, "color": Colors.purple},
    //   {"productName": "Product Four", "qty": 18, "color": Colors.green},
    //   {"productName": "Product Five", "qty": 5, "color": Colors.red},
    // ];

    // for (var val in bestSellingItems) {
    //   pieChartList.add(PieChartModel.fromJson(val));
    // }
  }

  Future<void> getSaleTotal() async {
    final now = DateTime.now();
    print(DateFormat.MMM().format(now));
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    var startDate = DateTime(
        firstDayOfMonth.year, firstDayOfMonth.month, firstDayOfMonth.day);
    var endDate = DateTime(lastDayOfMonth.year, lastDayOfMonth.month,
        lastDayOfMonth.day, 23, 59, 59, 999);
    final response = await dashboardRepository.getSaleProductTotal(
        startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch);
    if (response != null && response.statusCode == 200) {
      print(response.data);
      final data = response.data as Map<String, dynamic>;
      var salesTotal = SalesTotalModel.fromJson(data);
      print(salesTotal.paymentReceivedAmount);
      salesTotalData.value = salesTotal;
    }
  }

  Future<void> getSaleTotalToday() async {
    final now = DateTime.now();
    //print(DateFormat.MMM().format(now));
    // final firstDayOfMonth = DateTime(now.year, now.month, 1);
    // final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    var startDate = DateTime(now.year, now.month, now.day);
    var endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    final response = await dashboardRepository.getSaleProductTotal(
        startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch);
    if (response != null && response.statusCode == 200) {
      //print(response.data);
      final data = response.data as Map<String, dynamic>;
      var salesTotal = SalesTotalModel.fromJson(data);
      salesTotalTodayData.value = salesTotal;
    }
  }

  Future<void> getPurchaseTotal() async {
    final now = DateTime.now();
    //print(DateFormat.MMM().format(now));
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    var startDate = DateTime(
        firstDayOfMonth.year, firstDayOfMonth.month, firstDayOfMonth.day);
    var endDate = DateTime(lastDayOfMonth.year, lastDayOfMonth.month,
        lastDayOfMonth.day, 23, 59, 59, 999);
    final response = await dashboardRepository.getPurchaseProductTotal(
        startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch);
    if (response != null && response.statusCode == 200) {
      //print(response.data);
      final data = response.data as Map<String, dynamic>;
      var purchaseTotal = PurchaseTotalModel.fromJson(data);
      print(purchaseTotal.totalPaymentPurchased);
      purchaseTotalData.value = purchaseTotal;
    }
  }

  Future<void> getPurchaseTotalToday() async {
    final now = DateTime.now();
    //print(DateFormat.MMM().format(now));
    var startDate = DateTime(now.year, now.month, now.day);
    var endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    final response = await dashboardRepository.getPurchaseProductTotal(
        startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch);
    if (response != null && response.statusCode == 200) {
      //print(response.data);
      final data = response.data as Map<String, dynamic>;
      var purchaseTotal = PurchaseTotalModel.fromJson(data);
      print(purchaseTotal.totalPaymentPurchased);
      purchaseTotalTodayData.value = purchaseTotal;
    }
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          borderRadius: BorderRadius.zero,
          toY: y1,
          color: Colors.indigo,
          width: 16,
        ),
        BarChartRodData(
          borderRadius: BorderRadius.zero,
          toY: y2,
          color: Colors.teal,
          width: 16,
        ),
      ],
    );
  }
}
