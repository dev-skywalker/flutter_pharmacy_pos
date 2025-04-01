import 'package:get/get.dart';

import '../controllers/sales_controller.dart';
import '../repository/sales_repository.dart';
import '../repository/sales_repository_impl.dart';

class SalesBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<SalesRepository>(() => SalesRepositoryImpl()),
        Bind.lazyPut<SalesController>(() => SalesController(Get.find()))
      ];
}
