import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/sale_return/repository/sale_return_repository.dart';

import '../model/sales_return_details_model.dart';

class SalesReturnController extends GetxController {
  final SalesReturnRepository salesReturnRepository;
  SalesReturnController(this.salesReturnRepository);

  double tableHeight = 50;

  Rx<SaleReturnDetailsModel?> salesResponse = Rx<SaleReturnDetailsModel?>(null);

  void getSalesReturn(int id) async {
    final response = await salesReturnRepository.getSalesReturn(id: id);
    if (response != null && response.statusCode == 200) {
      salesResponse.value = SaleReturnDetailsModel.fromJson(response.data);
    }
  }
}
