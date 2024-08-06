import 'package:dio/dio.dart';

abstract class AuthRepository {
  Future<Response?> login({required String email, required String password});
  Future<Response?> register(
      {required String email,
      required String password,
      required String role,
      required bool isActive});
}
