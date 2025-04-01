import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class CustomerService extends BaseApiService {
  Future<Response?> getCustomer(int id) async {
    final response = await getRequest('/customers/$id');

    return response;
  }

  Future<Response?> createCustomer(Map<String, dynamic> data) async {
    final response = await postRequest('/customers', data);
    return response;
  }

  Future<Response?> updateCustomer(Map<String, dynamic> data) async {
    final response = await putRequest('/customers', data);
    return response;
  }

  Future<Response?> getAllCustomers() async {
    final response = await getRequest('/customers');

    return response;
  }
}
