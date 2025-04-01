import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class SupplierService extends BaseApiService {
  Future<Response?> getSupplier(int id) async {
    final response = await getRequest('/suppliers/$id');

    return response;
  }

  Future<Response?> createSupplier(Map<String, dynamic> data) async {
    final response = await postRequest('/suppliers', data);
    return response;
  }

  Future<Response?> updateSupplier(Map<String, dynamic> data) async {
    final response = await putRequest('/suppliers', data);
    return response;
  }

  Future<Response?> getAllSuppliers() async {
    final response = await getRequest('/suppliers');

    return response;
  }
}
