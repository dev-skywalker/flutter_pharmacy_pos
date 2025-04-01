import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../repository/dashboard_repository.dart';
import '../repository/dashboard_repository_impl.dart';

class DashboardBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<DashboardRepository>(() => DashboardRepositoryImpl()),
        Bind.lazyPut<DashboardController>(() => DashboardController(Get.find()))
      ];
}
