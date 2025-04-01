import 'package:get/get.dart';

import '../controllers/purchase_product_controller.dart';
import '../repository/purchase_product_repository.dart';
import '../repository/purchase_product_repository_impl.dart';

class PurchaseProductBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<PurchaseProductRepository>(
            () => PurchaseProductRepositoryImpl()),
        Bind.lazyPut<PurchaseProductController>(
            () => PurchaseProductController(Get.find()))
      ];
}
