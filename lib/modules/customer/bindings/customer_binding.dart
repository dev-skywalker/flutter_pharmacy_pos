import 'package:get/get.dart';

import '../controllers/customer_controller.dart';
import '../repository/customer_repository.dart';
import '../repository/customer_repository_impl.dart';

class CustomerBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<CustomerRepository>(() => CustomerRepositoryImpl()),
        Bind.lazyPut<CustomerController>(() => CustomerController(Get.find()))
      ];
}
