import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class ManageStockService extends BaseApiService {
  Future<Response?> createManageStock(Map<String, dynamic> data) async {
    final response = await postRequest('/manage_stocks', data);
    return response;
  }
}
