import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  dynamic get({required String key}) {
    var data = _box.read(key);
    if (data != null) {
      return data;
    }
    return null;
  }

  void save({required String key, dynamic data}) {
    _box.write(key, data);
  }

  void clear({required String key}) {
    _box.remove(key);
  }
}
