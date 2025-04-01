import 'package:get/get.dart';

import '../controllers/transfer_controller.dart';
import '../repository/transfer_repository.dart';
import '../repository/transfer_repository_impl.dart';

class TransferBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<TransferRepository>(() => TransferRepositoryImpl()),
        Bind.lazyPut<TransferController>(() => TransferController(Get.find()))
      ];
}
