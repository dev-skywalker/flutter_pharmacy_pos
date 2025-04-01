import 'package:get/get.dart';

import '../controllers/supplier_controller.dart';
import '../repository/supplier_repository.dart';
import '../repository/supplier_repository_impl.dart';

class SupplierBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<SupplierRepository>(() => SupplierRepositoryImpl()),
        Bind.lazyPut<SupplierController>(() => SupplierController(Get.find()))
      ];
}
