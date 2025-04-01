import 'package:dio/dio.dart';

abstract class PurchaseRepository {
  Future<Response?> getPurchase({required int id});
  Future<Response?> searchPurchaseProduct(
      {required Map<String, dynamic> params});
  Future<Response?> createPurchase(Map<String, dynamic> data);
  Future<Response?> createPurchaseItem(Map<String, dynamic> data);
  Future<Response?> createPurchaseWithItem(Map<String, dynamic> data);
  Future<Response?> updatePurchaseWithItem(Map<String, dynamic> data);
  Future<Response?> createPurchaseReturnWithItem(Map<String, dynamic> data);
  Future<Response?> updatePurchase(int id, String name, String description);
}
