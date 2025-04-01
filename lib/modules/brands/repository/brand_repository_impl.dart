import 'package:dio/dio.dart';

import '../services/brand_services.dart';
import 'brand_repository.dart';

class BrandRepositoryImpl extends BrandRepository {
  final BrandService _brandService = BrandService();

  @override
  Future<Response?> createBrand(String name, String description) {
    return _brandService.createBrand(name, description);
  }

  @override
  Future<Response?> updateBrand(int id, String name, String description) {
    return _brandService.updateBrand(id, name, description);
  }

  @override
  Future<Response?> getBrand({required int id}) {
    return _brandService.getBrand(id);
  }
}
