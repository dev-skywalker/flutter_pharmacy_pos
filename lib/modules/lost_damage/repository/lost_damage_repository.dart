import 'package:dio/dio.dart';

abstract class LostDamageRepository {
  Future<Response?> getLostDamage({required int id});
  Future<Response?> searchLostDamageProduct(
      {required Map<String, dynamic> params});
  Future<Response?> createLostDamage(Map<String, dynamic> data);
  Future<Response?> createLostDamageItem(Map<String, dynamic> data);
  Future<Response?> createLostDamageWithItem(Map<String, dynamic> data);
  Future<Response?> updateLostDamage(int id, String name, String description);
}
