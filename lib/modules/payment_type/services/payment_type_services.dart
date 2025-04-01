import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class PaymentTypeService extends BaseApiService {
  Future<Response?> createPaymentType(String name) async {
    final response = await postRequest('/payment_type', {"name": name});
    return response;
  }

  Future<Response?> getAllPaymentTypes() async {
    final response = await getRequest('/payment_type/all');
    return response;
  }
}
