import 'package:dio/dio.dart';

abstract class SalesReturnRepository {
  Future<Response?> getSalesReturn({required int id});
}
