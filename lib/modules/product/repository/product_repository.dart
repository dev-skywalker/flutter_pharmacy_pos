import 'package:dio/dio.dart';

abstract class ProductRepository {
  Future<Response?> createProduct({required FormData formdata});
  Future<Response?> updateProduct({required FormData formdata});
  Future<Response?> login({required String email, required String password});
  Future<Response?> register(
      {required String email,
      required String password,
      required String role,
      required bool isActive});
}
