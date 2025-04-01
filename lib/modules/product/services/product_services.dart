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

  Future<Response?> createProductImage(FormData formdata) async {
    print("WKSSS");
    final response = await postFormRequest('/image', formdata);

    return response;
  }

  Future<Response?> getProduct(int id) async {
    final response = await getRequest('/products/$id');

    return response;
  }

  Future<Response?> deleteProductImage({required String id}) async {
    final response = await deleteRequestImage('/image', id);
    return response;
  }

  Future<Response?> createProduct(Map<String, dynamic> data) async {
    final response = await postRequest('/products', data);
    print(response);
    return response;
  }

  Future<Response?> updateProduct(Map<String, dynamic> data) async {
    final response = await putRequest('/products', data);

    return response;
  }
}
