import 'package:dio/dio.dart';

import '../services/category_services.dart';
import 'category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryService _categoryService = CategoryService();

  @override
  Future<Response?> createCategory(String name, String description) {
    return _categoryService.createCategory(name, description);
  }

  @override
  Future<Response?> updateCategory(int id, String name, String description) {
    return _categoryService.updateCategory(id, name, description);
  }

  @override
  Future<Response?> getCategory({required int id}) {
    return _categoryService.getCategory(id);
  }
}
