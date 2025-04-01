import 'package:dio/dio.dart';

abstract class SalesRepository {
  Future<Response?> getSales({required int id});
  Future<Response?> getSalesWithStock({required int id});
  Future<Response?> searchSalesProduct({required Map<String, dynamic> params});
  Future<Response?> createSales(Map<String, dynamic> data);
  Future<Response?> createSalesItem(Map<String, dynamic> data);
  Future<Response?> createSalesWithItem(Map<String, dynamic> data);
  Future<Response?> updateSalesWithItem(Map<String, dynamic> data);
  Future<Response?> createSalesReturnWithItem(Map<String, dynamic> data);
  Future<Response?> updateSales(int id, String name, String description);
}
