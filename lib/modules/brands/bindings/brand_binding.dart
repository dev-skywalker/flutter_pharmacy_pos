import 'package:get/get.dart';

import '../controllers/brand_controller.dart';
import '../repository/brand_repository.dart';
import '../repository/brand_repository_impl.dart';

class BrandBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<BrandRepository>(() => BrandRepositoryImpl()),
        Bind.lazyPut<BrandController>(() => BrandController(Get.find()))
      ];
}
