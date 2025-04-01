import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class WarehouseService extends BaseApiService {
  Future<Response?> getWarehouse(int id) async {
    final response = await getRequest('/warehouses/$id');

    return response;
  }

  Future<Response?> createWarehouse(Map<String, dynamic> data) async {
    final response = await postRequest('/warehouses', data);
    return response;
  }

  Future<Response?> updateWarehouse(Map<String, dynamic> data) async {
    final response = await putRequest('/warehouses', data);
    return response;
  }

  Future<Response?> getAllWarehouses() async {
    final response = await getRequest('/warehouses');

    return response;
  }
}
