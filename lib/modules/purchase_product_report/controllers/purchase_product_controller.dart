import 'package:get/get.dart';

import '../../purchase/model/purchase_details_model.dart';
import '../repository/purchase_product_repository.dart';

class PurchaseProductController extends GetxController {
  final PurchaseProductRepository purchaseProductRepository;
  PurchaseProductController(this.purchaseProductRepository);
  Rx<PurchaseDetailsModel?> purchaseResponse = Rx<PurchaseDetailsModel?>(null);

  double tableHeight = 50;
  Future<void> getPurchase(int id, bool isReturn) async {
    //print(id);
    final response = await purchaseProductRepository.getPurchases(id: id);
    if (response != null && response.statusCode == 200) {
      //print(response.data);
      purchaseResponse.value = PurchaseDetailsModel.fromJson(response.data);
    }
  }
}
