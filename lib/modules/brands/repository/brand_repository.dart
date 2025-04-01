import 'package:dio/dio.dart';

abstract class BrandRepository {
  Future<Response?> getBrand({required int id});

  Future<Response?> createBrand(String name, String description);
  Future<Response?> updateBrand(int id, String name, String description);
}
