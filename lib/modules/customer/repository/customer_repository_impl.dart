import 'package:dio/dio.dart';

import '../services/customer_services.dart';
import 'customer_repository.dart';

class CustomerRepositoryImpl extends CustomerRepository {
  final CustomerService _customerService = CustomerService();

  @override
  Future<Response?> createCustomer(Map<String, dynamic> data) {
    return _customerService.createCustomer(data);
  }

  @override
  Future<Response?> updateCustomer(Map<String, dynamic> data) {
    return _customerService.updateCustomer(data);
  }

  @override
  Future<Response?> getCustomer({required int id}) {
    return _customerService.getCustomer(id);
  }
}
