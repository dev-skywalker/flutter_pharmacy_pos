import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class PurchaseService extends BaseApiService {
  Future<Response?> getPurchase(int id) async {
    final response = await getRequest('/purchases/$id');

    return response;
  }

  Future<Response?> searchPurchaseProduct(Map<String, dynamic> params) async {
    final response = await getRequest('/products/search', params: params);

    return response;
  }

  Future<Response?> createPurchase(Map<String, dynamic> data) async {
    final response = await postRequest('/purchases', data);
    return response;
  }

  Future<Response?> createPurchaseWithItem(Map<String, dynamic> data) async {
    final response = await postRequest('/purchases/items', data);
    return response;
  }

  Future<Response?> updatePurchaseWithItem(Map<String, dynamic> data) async {
    final response = await putRequest('/purchases/items', data);
    return response;
  }

  Future<Response?> createPurchaseReturnWithItem(
      Map<String, dynamic> data) async {
    final response = await postRequest('/purchase_return', data);
    return response;
  }

  Future<Response?> createPurchaseItem(Map<String, dynamic> data) async {
    final response = await postRequest('/purchase_items', data);
    return response;
  }

  Future<Response?> updatePurchase(
      int id, String name, String description) async {
    final response = await putRequest(
        '/purchases', {"id": id, "name": name, "description": description});
    return response;
  }

  Future<Response?> getAllPurchases() async {
    final response = await getRequest('/purchases');

    return response;
  }
}
