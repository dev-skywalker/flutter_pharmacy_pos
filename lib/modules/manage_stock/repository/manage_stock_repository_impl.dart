import 'package:dio/dio.dart';

import '../services/manage_stock_services.dart';
import 'manage_stock_repository.dart';

class ManageStockRepositoryImpl extends ManageStockRepository {
  final ManageStockService _managestockService = ManageStockService();

  @override
  Future<Response?> createManageStock(Map<String, dynamic> data) {
    return _managestockService.createManageStock(data);
  }
}
