import 'package:dio/dio.dart';

abstract class CustomerRepository {
  Future<Response?> getCustomer({required int id});
  Future<Response?> createCustomer(Map<String, dynamic> data);
  Future<Response?> updateCustomer(Map<String, dynamic> data);
}
