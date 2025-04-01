import 'package:dio/dio.dart';

abstract class WarehouseRepository {
  Future<Response?> getWarehouse({required int id});
  Future<Response?> createWarehouse(Map<String, dynamic> data);
  Future<Response?> updateWarehouse(Map<String, dynamic> data);
}
