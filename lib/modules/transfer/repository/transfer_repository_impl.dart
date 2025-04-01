import 'package:dio/dio.dart';

import '../services/transfer_services.dart';
import 'transfer_repository.dart';

class TransferRepositoryImpl extends TransferRepository {
  final TransferService _transferService = TransferService();

  @override
  Future<Response?> createTransfer(Map<String, dynamic> data) {
    return _transferService.createTransfer(data);
  }

  @override
  Future<Response?> createTransferItem(Map<String, dynamic> data) {
    return _transferService.createTransferItem(data);
  }

  @override
  Future<Response?> createTransferWithItem(Map<String, dynamic> data) {
    return _transferService.createTransferWithItem(data);
  }

  @override
  Future<Response?> updateTransfer(int id, String name, String description) {
    return _transferService.updateTransfer(id, name, description);
  }

  @override
  Future<Response?> getTransfer({required int id}) {
    return _transferService.getTransfer(id);
  }

  @override
  Future<Response?> searchTransferProduct(
      {required Map<String, dynamic> params}) {
    return _transferService.searchTransferProduct(params);
  }
}
