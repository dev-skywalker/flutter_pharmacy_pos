import 'package:dio/dio.dart';

import '../../../services/base_api_service.dart';

class PurchaseReturnService extends BaseApiService {
  Future<Response?> getPurchaseReturn(int id) async {
    final response = await getRequest('/purchase_return/$id');

    return response;
  }
}
