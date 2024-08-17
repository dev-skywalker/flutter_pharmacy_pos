import 'package:dio/dio.dart';

import '../services/product_services.dart';
import 'product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductService _productService = ProductService();

  @override
  Future<Response?> createProduct({required FormData formdata}) =>
      _productService.createProduct(formdata);
  @override
  Future<Response?> updateProduct({required FormData formdata}) =>
      _productService.updateProduct(formdata);
  @override
  Future<Response?> login({required String email, required String password}) =>
      _productService.login(email: email, password: password);

  @override
  Future<Response?> register(
          {required String email,
          required String password,
          required String role,
          required bool isActive}) =>
      _productService.register(
          email: email, password: password, role: role, isActive: isActive);
}
