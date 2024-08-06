import 'package:get/get.dart';

import '../../../services/check_auth_service.dart';
import '../controller/root_controller.dart';

class RootBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut(() => CheckAuthService()),
        Bind.lazyPut<RootController>(() => RootController())
      ];
}
