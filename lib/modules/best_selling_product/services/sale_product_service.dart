import 'package:dio/dio.dart';

import '../../../services/base_api_service.dart';

class SaleProductService extends BaseApiService {
  Future<Response?> getSaleProductTotal(
      int startDate, int endDate, int? warehouseId) async {
    Map<String, dynamic> params = {};
    if (warehouseId == null || warehouseId == -1) {
      params.addAll({
        //"warehouseId": warehouseId,
        "startDate": startDate,
        "endDate": endDate
      });
    } else {
      params.addAll({
        "warehouseId": warehouseId,
        "startDate": startDate,
        "endDate": endDate
      });
    }

    final response = await getRequest('/reports/sales/total', params: params);

    return response;
  }

  Future<Response?> getSales(int id) async {
    final response = await getRequest('/sales/$id');

    return response;
  }
}
