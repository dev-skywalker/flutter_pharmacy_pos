import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class ProductService extends BaseApiService {
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

  Future<Response?> createProduct(FormData formdata) async {
    final response = await postFormRequest('/products', formdata);

    return response;
  }
}
