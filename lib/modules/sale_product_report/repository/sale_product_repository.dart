import 'package:dio/dio.dart';

abstract class SaleProductRepository {
  Future<Response?> getSaleProduct({required int id});
}
