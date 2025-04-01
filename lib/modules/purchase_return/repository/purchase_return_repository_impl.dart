import 'package:dio/dio.dart';

import '../services/purchase_return_service.dart';
import 'purchase_return_repository.dart';

class PurchaseReturnRepositoryImpl extends PurchaseReturnRepository {
  final PurchaseReturnService _purchaseReturnService = PurchaseReturnService();

  @override
  Future<Response?> getPurchaseReturn({required int id}) {
    return _purchaseReturnService.getPurchaseReturn(id);
  }
}
