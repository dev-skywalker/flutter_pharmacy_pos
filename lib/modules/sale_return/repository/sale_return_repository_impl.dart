import 'package:dio/dio.dart';

import '../services/sale_return_service.dart';
import 'sale_return_repository.dart';

class SalesReturnRepositoryImpl extends SalesReturnRepository {
  final SalesReturnService _salesReturnService = SalesReturnService();

  @override
  Future<Response?> getSalesReturn({required int id}) {
    return _salesReturnService.getSalesReturn(id);
  }
}
