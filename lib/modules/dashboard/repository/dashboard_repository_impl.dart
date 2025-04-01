import 'package:dio/dio.dart';
import 'package:pharmacy_pos/modules/dashboard/services/dashboard_service.dart';

import 'dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardService _dashboardService = DashboardService();
  @override
  Future<Response?> getChartData() {
    return _dashboardService.getChartData();
  }

  @override
  Future<Response?> getPieChartData() {
    return _dashboardService.getPieChartData();
  }

  @override
  Future<Response?> getPurchaseProductTotal(int startDate, int endDate) {
    return _dashboardService.getPurchaseProductTotal(startDate, endDate);
  }

  @override
  Future<Response?> getSaleProductTotal(int startDate, int endDate) {
    return _dashboardService.getSaleProductTotal(startDate, endDate);
  }

  @override
  Future<Response?> getStockAlertItems(Map<String, dynamic> params) {
    return _dashboardService.getStockAlertItems(params);
  }
}
