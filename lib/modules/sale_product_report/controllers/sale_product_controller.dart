import 'package:get/get.dart';

import '../../sales/model/sale_details_model.dart';
import '../repository/sale_product_repository.dart';

class SaleProductController extends GetxController {
  final SaleProductRepository saleProductRepository;
  SaleProductController(this.saleProductRepository);
  Rx<SaleDetailsModel?> salesResponse = Rx<SaleDetailsModel?>(null);
  double tableHeight = 50;

  Future<void> getSales(int id, bool isReturn, bool isUpdate) async {
    final response = await saleProductRepository.getSaleProduct(id: id);
    if (response != null && response.statusCode == 200) {
      salesResponse.value = SaleDetailsModel.fromJson(response.data);
    }
  }
}
