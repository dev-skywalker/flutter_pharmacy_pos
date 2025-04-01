import 'package:dio/dio.dart';

import '../services/supplier_services.dart';
import 'supplier_repository.dart';

class SupplierRepositoryImpl extends SupplierRepository {
  final SupplierService _supplierService = SupplierService();

  @override
  Future<Response?> createSupplier(Map<String, dynamic> data) {
    return _supplierService.createSupplier(data);
  }

  @override
  Future<Response?> updateSupplier(Map<String, dynamic> data) {
    return _supplierService.updateSupplier(data);
  }

  @override
  Future<Response?> getSupplier({required int id}) {
    return _supplierService.getSupplier(id);
  }
}
