import 'package:dio/dio.dart';

abstract class SupplierRepository {
  Future<Response?> getSupplier({required int id});
  Future<Response?> createSupplier(Map<String, dynamic> data);
  Future<Response?> updateSupplier(Map<String, dynamic> data);
}
