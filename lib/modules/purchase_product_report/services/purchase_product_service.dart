import 'package:dio/dio.dart';

import '../../../services/base_api_service.dart';

class PurchaseProductService extends BaseApiService {
  Future<Response?> getPurchaseProductTotal(
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

    final response =
        await getRequest('/reports/purchase/total', params: params);

    return response;
  }

  Future<Response?> getPurchase(int id) async {
    final response = await getRequest('/purchases/$id');

    return response;
  }
}
