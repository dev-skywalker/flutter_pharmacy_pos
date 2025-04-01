import 'package:get/get.dart';

import '../controllers/warehouse_controller.dart';
import '../repository/warehouse_repository.dart';
import '../repository/warehouse_repository_impl.dart';

class WarehouseBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<WarehouseRepository>(() => WarehouseRepositoryImpl()),
        Bind.lazyPut<WarehouseController>(() => WarehouseController(Get.find()))
      ];
}
