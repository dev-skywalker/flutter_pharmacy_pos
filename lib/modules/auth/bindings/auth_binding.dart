import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../repository/auth_repository.dart';
import '../repository/auth_repository_impl.dart';

class AuthBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<AuthRepository>(() => AuthRepositoryImpl()),
        Bind.lazyPut<AuthController>(() => AuthController(Get.find()))
      ];
}
