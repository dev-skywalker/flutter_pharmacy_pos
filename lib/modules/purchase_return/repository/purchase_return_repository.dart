import 'package:dio/dio.dart';

abstract class PurchaseReturnRepository {
  Future<Response?> getPurchaseReturn({required int id});
}
