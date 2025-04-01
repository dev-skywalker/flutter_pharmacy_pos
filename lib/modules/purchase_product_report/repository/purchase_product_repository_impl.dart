import 'package:dio/dio.dart';

import '../services/purchase_product_service.dart';
import 'purchase_product_repository.dart';

class PurchaseProductRepositoryImpl extends PurchaseProductRepository {
  final PurchaseProductService _purchaseProductService =
      PurchaseProductService();

  @override
  Future<Response?> getPurchases({required int id}) {
    return _purchaseProductService.getPurchase(id);
  }
}
