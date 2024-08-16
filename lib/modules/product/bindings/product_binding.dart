import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/product/controllers/product_controller.dart';
import 'package:pharmacy_pos/modules/product/repository/product_repository.dart';

import '../repository/product_repository_impl.dart';

class ProductBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<ProductRepository>(() => ProductRepositoryImpl()),
        Bind.lazyPut<ProductController>(() => ProductController(Get.find()))
      ];
}
