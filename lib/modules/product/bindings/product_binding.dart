import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/manage_stock/repository/manage_stock_repository.dart';
import 'package:pharmacy_pos/modules/manage_stock/repository/manage_stock_repository_impl.dart';
import 'package:pharmacy_pos/modules/product/controllers/product_controller.dart';
import 'package:pharmacy_pos/modules/product/repository/product_repository.dart';

import '../../purchase/repository/purchase_repository.dart';
import '../../purchase/repository/purchase_repository_impl.dart';
import '../repository/product_repository_impl.dart';

class ProductBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<PurchaseRepository>(() => PurchaseRepositoryImpl()),
        Bind.lazyPut<ManageStockRepository>(() => ManageStockRepositoryImpl()),
        Bind.lazyPut<ProductRepository>(() => ProductRepositoryImpl()),
        Bind.lazyPut<ProductController>(() => ProductController(
            Get.find<ProductRepository>(),
            Get.find<PurchaseRepository>(),
            Get.find<ManageStockRepository>()))
      ];
}
