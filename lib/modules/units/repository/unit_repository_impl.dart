import 'package:dio/dio.dart';

import '../services/unit_services.dart';
import 'unit_repository.dart';

class UnitRepositoryImpl extends UnitRepository {
  final UnitService _unitService = UnitService();

  @override
  Future<Response?> login({required String email, required String password}) =>
      _unitService.login(email: email, password: password);

  @override
  Future<Response?> register(
          {required String email,
          required String password,
          required String role,
          required bool isActive}) =>
      _unitService.register(
          email: email, password: password, role: role, isActive: isActive);
}
