import 'package:get/get.dart';

import '../controllers/lost_damage_controller.dart';
import '../repository/lost_damage_repository.dart';
import '../repository/lost_damage_repository_impl.dart';

class LostDamageBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<LostDamageRepository>(() => LostDamageRepositoryImpl()),
        Bind.lazyPut<LostDamageController>(
            () => LostDamageController(Get.find()))
      ];
}
