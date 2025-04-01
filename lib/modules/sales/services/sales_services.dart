import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class SalesService extends BaseApiService {
  Future<Response?> getSales(int id) async {
    final response = await getRequest('/sales/$id');

    return response;
  }

  Future<Response?> getSalesWithStock(int id) async {
    final response = await getRequest('/sales/items/$id');

    return response;
  }

  Future<Response?> searchSalesProduct(Map<String, dynamic> params) async {
    final response = await getRequest('/products/search', params: params);

    return response;
  }

  Future<Response?> createSales(Map<String, dynamic> data) async {
    final response = await postRequest('/sales', data);
    return response;
  }

  Future<Response?> createSalesWithItem(Map<String, dynamic> data) async {
    final response = await postRequest('/sales/items', data);
    return response;
  }

  Future<Response?> updateSalesWithItem(Map<String, dynamic> data) async {
    final response = await putRequest('/sales/items', data);
    return response;
  }

  Future<Response?> createSalesReturnWithItem(Map<String, dynamic> data) async {
    final response = await postRequest('/sale_return', data);
    return response;
  }

  Future<Response?> createSalesItem(Map<String, dynamic> data) async {
    final response = await postRequest('/sales_items', data);
    return response;
  }

  Future<Response?> updateSales(int id, String name, String description) async {
    final response = await putRequest(
        '/sales', {"id": id, "name": name, "description": description});
    return response;
  }

  Future<Response?> getAllSaless() async {
    final response = await getRequest('/sales');

    return response;
  }
}
