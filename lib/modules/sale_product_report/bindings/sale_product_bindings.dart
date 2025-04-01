import 'package:get/get.dart';

import '../controllers/sale_product_controller.dart';
import '../repository/sale_product_repository.dart';
import '../repository/sale_product_repository_impl.dart';

class SaleProductBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<SaleProductRepository>(() => SaleProductRepositoryImpl()),
        Bind.lazyPut<SaleProductController>(
            () => SaleProductController(Get.find()))
      ];
}
