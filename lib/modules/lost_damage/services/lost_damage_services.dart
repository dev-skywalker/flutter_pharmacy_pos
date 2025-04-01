import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class LostDamageService extends BaseApiService {
  Future<Response?> getLostDamage(int id) async {
    final response = await getRequest('/lostdamages/$id');

    return response;
  }

  Future<Response?> searchLostDamageProduct(Map<String, dynamic> params) async {
    final response = await getRequest('/products/search', params: params);

    return response;
  }

  Future<Response?> createLostDamage(Map<String, dynamic> data) async {
    final response = await postRequest('/lostdamage', data);
    return response;
  }

  Future<Response?> createLostDamageWithItem(Map<String, dynamic> data) async {
    final response = await postRequest('/lost_damage', data);
    return response;
  }

  Future<Response?> createLostDamageItem(Map<String, dynamic> data) async {
    final response = await postRequest('/lostdamage_items', data);
    return response;
  }

  Future<Response?> updateLostDamage(
      int id, String name, String description) async {
    final response = await putRequest(
        '/lostdamage', {"id": id, "name": name, "description": description});
    return response;
  }

  Future<Response?> getAllLostDamages() async {
    final response = await getRequest('/lostdamage');

    return response;
  }
}
