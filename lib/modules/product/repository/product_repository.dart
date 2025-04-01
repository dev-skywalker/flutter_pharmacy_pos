import 'package:dio/dio.dart';

abstract class ProductRepository {
  Future<Response?> createProduct({required Map<String, dynamic> data});
  Future<Response?> createProductImage({required FormData formdata});
  Future<Response?> updateProduct({required Map<String, dynamic> data});
  Future<Response?> deleteProductImage({required String id});
  Future<Response?> getProduct({required int id});
  Future<Response?> login({required String email, required String password});
  Future<Response?> register(
      {required String email,
      required String password,
      required String role,
      required bool isActive});
}
