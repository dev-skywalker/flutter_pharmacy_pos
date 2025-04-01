import 'package:get/get.dart';

import '../controllers/purchase_return_controller.dart';
import '../repository/purchase_return_repository.dart';
import '../repository/purchase_return_repository_impl.dart';

class PurchaseReturnBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<PurchaseReturnRepository>(
            () => PurchaseReturnRepositoryImpl()),
        Bind.lazyPut<PurchaseReturnController>(
            () => PurchaseReturnController(Get.find()))
      ];
}
