import 'package:dio/dio.dart';

abstract class PurchaseProductRepository {
  Future<Response?> getPurchases({required int id});
}
