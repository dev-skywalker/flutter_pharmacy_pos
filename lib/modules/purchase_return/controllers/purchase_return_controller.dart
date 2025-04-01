import 'package:get/get.dart';

import '../model/purchase_return_details_model.dart';
import '../repository/purchase_return_repository.dart';

class PurchaseReturnController extends GetxController {
  final PurchaseReturnRepository purchaseReturnRepository;
  PurchaseReturnController(this.purchaseReturnRepository);

  double tableHeight = 50;

  Rx<PurchaseReturnDetailsModel?> purchaseResponse =
      Rx<PurchaseReturnDetailsModel?>(null);

  void getPurchaseReturn(int id) async {
    final response = await purchaseReturnRepository.getPurchaseReturn(id: id);
    if (response != null && response.statusCode == 200) {
      purchaseResponse.value =
          PurchaseReturnDetailsModel.fromJson(response.data);
    }
  }
}
