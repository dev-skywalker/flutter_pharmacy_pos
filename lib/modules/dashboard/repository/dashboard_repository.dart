import 'package:dio/dio.dart';

abstract class DashboardRepository {
  Future<Response?> getChartData();
  Future<Response?> getPieChartData();
  Future<Response?> getPurchaseProductTotal(int startDate, int endDate);
  Future<Response?> getSaleProductTotal(int startDate, int endDate);
  Future<Response?> getStockAlertItems(Map<String, dynamic> params);
}
