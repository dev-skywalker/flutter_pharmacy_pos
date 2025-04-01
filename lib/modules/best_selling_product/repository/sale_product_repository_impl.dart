import 'package:dio/dio.dart';

import '../services/sale_product_service.dart';
import 'sale_product_repository.dart';

class SaleProductRepositoryImpl extends SaleProductRepository {
  final SaleProductService _saleProductService = SaleProductService();

  @override
  Future<Response?> getSaleProduct({required int id}) {
    return _saleProductService.getSales(id);
  }
}
