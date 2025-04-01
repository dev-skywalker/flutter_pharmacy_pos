import 'package:dio/dio.dart';

abstract class CategoryRepository {
  Future<Response?> getCategory({required int id});

  Future<Response?> createCategory(String name, String description);
  Future<Response?> updateCategory(int id, String name, String description);
}
