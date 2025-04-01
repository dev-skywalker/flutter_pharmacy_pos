import 'package:dio/dio.dart';

abstract class TransferRepository {
  Future<Response?> getTransfer({required int id});
  Future<Response?> searchTransferProduct(
      {required Map<String, dynamic> params});
  Future<Response?> createTransfer(Map<String, dynamic> data);
  Future<Response?> createTransferItem(Map<String, dynamic> data);
  Future<Response?> createTransferWithItem(Map<String, dynamic> data);
  Future<Response?> updateTransfer(int id, String name, String description);
}
