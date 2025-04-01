import 'package:dio/dio.dart';

import '../../../services/base_api_service.dart';

class DashboardService extends BaseApiService {
  Future<Response?> getChartData() async {
    final response = await getRequest('/reports/weekly/sales');
    return response;
  }

  Future<Response?> getPieChartData() async {
    final response = await getRequest('/reports/top_selling');
    return response;
  }

  Future<Response?> getSaleProductTotal(int startDate, int endDate) async {
    Map<String, dynamic> params = {};
    params.addAll({
      //"warehouseId": warehouseId,
      "startDate": startDate,
      "endDate": endDate
    });

    final response = await getRequest('/reports/sales/total', params: params);
    print(response?.data);
    return response;
  }

  Future<Response?> getPurchaseProductTotal(int startDate, int endDate) async {
    Map<String, dynamic> params = {};
    params.addAll({
      //"warehouseId": warehouseId,
      "startDate": startDate,
      "endDate": endDate
    });

    final response =
        await getRequest('/reports/purchase/total', params: params);

    return response;
  }

  Future<Response?> getStockAlertItems(Map<String, dynamic> params) async {
    final response = await getRequest('/reports/alerts', params: params);

    return response;
  }
}
