import 'package:get/get.dart';

import '../repository/unit_repository.dart';
import '../repository/unit_repository_impl.dart';

class UnitBinding extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<UnitRepository>(() => UnitRepositoryImpl()),
        //Bind.lazyPut<UnitController>(() => UnitController())
      ];
}
