import 'package:get/get.dart';

import '../controllers/category_controller.dart';
import '../repository/category_repository.dart';
import '../repository/category_repository_impl.dart';

class CategoryBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl()),
        Bind.lazyPut<CategoryController>(() => CategoryController(Get.find()))
      ];
}
