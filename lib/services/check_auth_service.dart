import 'package:get/get.dart';
import 'package:pharmacy_pos/services/storage_services.dart';

class CheckAuthService extends GetxService {
  final _storage = StorageService();
  // final authed = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  bool subscribe() {
    final token = _storage.get(key: 'token');
    if (token != null) {
      return true;
    }
    return false;
  }
}
