import 'package:dio/dio.dart';

abstract class UnitRepository {
  Future<Response?> getUnit({required int id});
  Future<Response?> createUnit(String name, String description);
  Future<Response?> updateUnit(int id, String name, String description);
}
