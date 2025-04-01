import 'package:dio/dio.dart';

import '../services/product_services.dart';
import 'product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductService _productService = ProductService();

  @override
  Future<Response?> createProduct({required Map<String, dynamic> data}) =>
      _productService.createProduct(data);
  @override
  Future<Response?> createProductImage({required FormData formdata}) =>
      _productService.createProductImage(formdata);
  @override
  Future<Response?> updateProduct({required Map<String, dynamic> data}) =>
      _productService.updateProduct(data);
  @override
  Future<Response?> deleteProductImage({required String id}) =>
      _productService.deleteProductImage(id: id);
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

  @override
  Future<Response?> getProduct({required int id}) =>
      _productService.getProduct(id);
}
