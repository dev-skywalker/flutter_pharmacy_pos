import 'package:get/get.dart';

import '../controllers/sales_return_controller.dart';
import '../repository/sale_return_repository.dart';
import '../repository/sale_return_repository_impl.dart';

class SalesReturnBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<SalesReturnRepository>(() => SalesReturnRepositoryImpl()),
        Bind.lazyPut<SalesReturnController>(
            () => SalesReturnController(Get.find()))
      ];
}
