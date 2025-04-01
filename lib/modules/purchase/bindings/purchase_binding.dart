import 'package:get/get.dart';

import '../controllers/purchase_controller.dart';
import '../repository/purchase_repository.dart';
import '../repository/purchase_repository_impl.dart';

class PurchaseBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<PurchaseRepository>(() => PurchaseRepositoryImpl()),
        Bind.lazyPut<PurchaseController>(() => PurchaseController(Get.find()))
      ];
}
