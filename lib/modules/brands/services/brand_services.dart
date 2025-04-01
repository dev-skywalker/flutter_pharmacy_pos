import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class BrandService extends BaseApiService {
  Future<Response?> login(
      {required String email, required String password}) async {
    final data = {"email": email, "password": password};
    final response = await postRequest('/users/login', data);
    return response;
  }

  Future<Response?> register(
      {required String email,
      required String password,
      required String role,
      required bool isActive}) async {
    final data = {
      "email": email,
      "password": password,
      "role": role,
      "isActive": isActive
    };
    final response = await postRequest('/users/register', data);

    return response;
  }

  Future<Response?> getBrand(int id) async {
    final response = await getRequest('/brands/$id');

    return response;
  }

  Future<Response?> createBrand(String name, String description) async {
    final response = await postRequest(
        '/brands', {"name": name, "description": description});
    return response;
  }

  Future<Response?> updateBrand(int id, String name, String description) async {
    final response = await putRequest(
        '/brands', {"id": id, "name": name, "description": description});
    return response;
  }

  Future<Response?> getAllBrands() async {
    final response = await getRequest('/brands');

    return response;
  }
}
