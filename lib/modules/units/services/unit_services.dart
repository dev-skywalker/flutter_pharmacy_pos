import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class UnitService extends BaseApiService {
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

  Future<Response?> getUnit(int id) async {
    final response = await getRequest('/units/$id');

    return response;
  }

  Future<Response?> createUnit(String name, String description) async {
    final response =
        await postRequest('/units', {"name": name, "description": description});
    return response;
  }

  Future<Response?> updateUnit(int id, String name, String description) async {
    final response = await putRequest(
        '/units', {"id": id, "name": name, "description": description});
    return response;
  }

  Future<Response?> getAllUnits() async {
    final response = await getRequest('/units');

    return response;
  }
}
