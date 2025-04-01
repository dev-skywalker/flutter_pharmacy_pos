import 'package:dio/dio.dart';

import '../services/warehouse_services.dart';
import 'warehouse_repository.dart';

class WarehouseRepositoryImpl extends WarehouseRepository {
  final WarehouseService _warehouseService = WarehouseService();

  @override
  Future<Response?> createWarehouse(Map<String, dynamic> data) {
    return _warehouseService.createWarehouse(data);
  }

  @override
  Future<Response?> updateWarehouse(Map<String, dynamic> data) {
    return _warehouseService.updateWarehouse(data);
  }

  @override
  Future<Response?> getWarehouse({required int id}) {
    return _warehouseService.getWarehouse(id);
  }
}
