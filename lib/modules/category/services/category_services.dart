import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class CategoryService extends BaseApiService {
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

  Future<Response?> getCategory(int id) async {
    final response = await getRequest('/category/$id');

    return response;
  }

  Future<Response?> createCategory(String name, String description) async {
    final response = await postRequest(
        '/category', {"name": name, "description": description});
    return response;
  }

  Future<Response?> updateCategory(
      int id, String name, String description) async {
    final response = await putRequest(
        '/category', {"id": id, "name": name, "description": description});
    return response;
  }

  Future<Response?> getAllCategorys() async {
    final response = await getRequest('/category');

    return response;
  }
}
