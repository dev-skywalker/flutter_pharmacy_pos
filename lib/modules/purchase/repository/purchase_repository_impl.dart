import 'package:dio/dio.dart';

import '../services/purchase_services.dart';
import 'purchase_repository.dart';

class PurchaseRepositoryImpl extends PurchaseRepository {
  final PurchaseService _purchaseService = PurchaseService();

  @override
  Future<Response?> createPurchase(Map<String, dynamic> data) {
    return _purchaseService.createPurchase(data);
  }

  @override
  Future<Response?> createPurchaseItem(Map<String, dynamic> data) {
    return _purchaseService.createPurchaseItem(data);
  }

  @override
  Future<Response?> createPurchaseWithItem(Map<String, dynamic> data) {
    return _purchaseService.createPurchaseWithItem(data);
  }

  @override
  Future<Response?> updatePurchaseWithItem(Map<String, dynamic> data) {
    return _purchaseService.updatePurchaseWithItem(data);
  }

  @override
  Future<Response?> createPurchaseReturnWithItem(Map<String, dynamic> data) {
    return _purchaseService.createPurchaseReturnWithItem(data);
  }

  @override
  Future<Response?> updatePurchase(int id, String name, String description) {
    return _purchaseService.updatePurchase(id, name, description);
  }

  @override
  Future<Response?> getPurchase({required int id}) {
    return _purchaseService.getPurchase(id);
  }

  @override
  Future<Response?> searchPurchaseProduct(
      {required Map<String, dynamic> params}) {
    return _purchaseService.searchPurchaseProduct(params);
  }
}
