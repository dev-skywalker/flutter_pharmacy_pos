import 'package:dio/dio.dart';

import '../services/sales_services.dart';
import 'sales_repository.dart';

class SalesRepositoryImpl extends SalesRepository {
  final SalesService _salesService = SalesService();

  @override
  Future<Response?> createSales(Map<String, dynamic> data) {
    return _salesService.createSales(data);
  }

  @override
  Future<Response?> createSalesItem(Map<String, dynamic> data) {
    return _salesService.createSalesItem(data);
  }

  @override
  Future<Response?> createSalesWithItem(Map<String, dynamic> data) {
    return _salesService.createSalesWithItem(data);
  }

  @override
  Future<Response?> updateSalesWithItem(Map<String, dynamic> data) {
    return _salesService.updateSalesWithItem(data);
  }

  @override
  Future<Response?> createSalesReturnWithItem(Map<String, dynamic> data) {
    return _salesService.createSalesReturnWithItem(data);
  }

  @override
  Future<Response?> updateSales(int id, String name, String description) {
    return _salesService.updateSales(id, name, description);
  }

  @override
  Future<Response?> getSales({required int id}) {
    return _salesService.getSales(id);
  }

  @override
  Future<Response?> getSalesWithStock({required int id}) {
    return _salesService.getSalesWithStock(id);
  }

  @override
  Future<Response?> searchSalesProduct({required Map<String, dynamic> params}) {
    return _salesService.searchSalesProduct(params);
  }
}
