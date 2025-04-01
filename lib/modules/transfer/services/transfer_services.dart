import 'package:dio/dio.dart';

import '../../../../services/base_api_service.dart';

class TransferService extends BaseApiService {
  Future<Response?> getTransfer(int id) async {
    final response = await getRequest('/transfers/$id');

    return response;
  }

  Future<Response?> searchTransferProduct(Map<String, dynamic> params) async {
    final response = await getRequest('/products/search', params: params);

    return response;
  }

  Future<Response?> createTransfer(Map<String, dynamic> data) async {
    final response = await postRequest('/transfer', data);
    return response;
  }

  Future<Response?> createTransferWithItem(Map<String, dynamic> data) async {
    final response = await postRequest('/transfers/items', data);
    return response;
  }

  Future<Response?> createTransferItem(Map<String, dynamic> data) async {
    final response = await postRequest('/transfer_items', data);
    return response;
  }

  Future<Response?> updateTransfer(
      int id, String name, String description) async {
    final response = await putRequest(
        '/transfer', {"id": id, "name": name, "description": description});
    return response;
  }

  Future<Response?> getAllTransfers() async {
    final response = await getRequest('/transfer');

    return response;
  }
}
