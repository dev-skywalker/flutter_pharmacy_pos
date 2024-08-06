import 'package:dio/dio.dart';

import '../services/auth_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService = AuthService();

  @override
  Future<Response?> login({required String email, required String password}) =>
      _authService.login(email: email, password: password);

  @override
  Future<Response?> register(
          {required String email,
          required String password,
          required String role,
          required bool isActive}) =>
      _authService.register(
          email: email, password: password, role: role, isActive: isActive);
}
