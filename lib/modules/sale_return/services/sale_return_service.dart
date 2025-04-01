import 'package:dio/dio.dart';

import '../../../services/base_api_service.dart';

class SalesReturnService extends BaseApiService {
  Future<Response?> getSalesReturn(int id) async {
    final response = await getRequest('/sale_return/$id');

    return response;
  }
}
