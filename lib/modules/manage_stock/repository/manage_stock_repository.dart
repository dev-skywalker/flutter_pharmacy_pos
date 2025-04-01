import 'package:dio/dio.dart';

abstract class ManageStockRepository {
  Future<Response?> createManageStock(Map<String, dynamic> data);
}
