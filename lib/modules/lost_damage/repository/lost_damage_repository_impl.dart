import 'package:dio/dio.dart';

import '../services/lost_damage_services.dart';
import 'lost_damage_repository.dart';

class LostDamageRepositoryImpl extends LostDamageRepository {
  final LostDamageService _lostdamageService = LostDamageService();

  @override
  Future<Response?> createLostDamage(Map<String, dynamic> data) {
    return _lostdamageService.createLostDamage(data);
  }

  @override
  Future<Response?> createLostDamageItem(Map<String, dynamic> data) {
    return _lostdamageService.createLostDamageItem(data);
  }

  @override
  Future<Response?> createLostDamageWithItem(Map<String, dynamic> data) {
    return _lostdamageService.createLostDamageWithItem(data);
  }

  @override
  Future<Response?> updateLostDamage(int id, String name, String description) {
    return _lostdamageService.updateLostDamage(id, name, description);
  }

  @override
  Future<Response?> getLostDamage({required int id}) {
    return _lostdamageService.getLostDamage(id);
  }

  @override
  Future<Response?> searchLostDamageProduct(
      {required Map<String, dynamic> params}) {
    return _lostdamageService.searchLostDamageProduct(params);
  }
}
