import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/customer/model/customer_model.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import 'package:pharmacy_pos/modules/warehouse/services/warehouse_services.dart';

import '../../customer/services/customer_services.dart';
import '../model/transfer_details_model.dart';
import '../repository/transfer_repository.dart';

class TransferItemModel {
  int productId;
  String productName;
  int quantity;
  int stock;
  int productCost;
  int productPrice;
  String unit;
  int subTotal;
  TransferItemModel(
      {required this.productId,
      required this.productName,
      required this.quantity,
      required this.stock,
      required this.productPrice,
      required this.unit,
      required this.productCost,
      required this.subTotal});
}

class TransferController extends GetxController {
  final TransferRepository transferRepository;
  TransferController(this.transferRepository);

  Rx<WarehouseModel?> selectedWarehouse = Rx<WarehouseModel?>(null);
  Rx<WarehouseModel?> selectedToWarehouse = Rx<WarehouseModel?>(null);
  Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);
  Rx<TransferDetailsModel?> transferResponse = Rx<TransferDetailsModel?>(null);

  RxInt shipping = 0.obs;
  RxInt grandTotal = 0.obs;

  RxList<TransferItemModel> transferItemList = <TransferItemModel>[].obs;
  double tableHeight = 50;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController shippingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  late DateTime transferDate = DateTime.now();

  final GlobalKey<FormState> createTransferFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> warehouseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateTransferFormKey = GlobalKey<FormState>();

  Future<void> getTransfer(int id) async {
    print(id);
    final response = await transferRepository.getTransfer(id: id);
    if (response != null && response.statusCode == 200) {
      print(response.data);
      transferResponse.value = TransferDetailsModel.fromJson(response.data);
    }
  }

  void calculateGrandTotal() {
    if (shippingController.text.isEmpty) {
      grandTotal.value =
          transferItemList.fold(0, (sum, item) => sum + item.subTotal);
    } else {
      int val = transferItemList.fold(0, (sum, item) => sum + item.subTotal);
      grandTotal.value = (val + int.parse(shippingController.text));
    }
  }

  void createTransferWithItem() async {
    if (transferItemList.isEmpty) return;
    List<Map<String, dynamic>> itemList = [];
    for (var item in transferItemList) {
      itemList.add({
        "productId": item.productId,
        "quantity": item.quantity,
        "productPrice": item.productPrice,
        "productCost": item.productCost,
        "subTotal": item.subTotal
      });
    }
    Map<String, dynamic> data = {
      "transferDate": transferDate.millisecondsSinceEpoch,
      "status": 0,
      "amount": (grandTotal.value - shipping.value),
      "note": descriptionController.text,
      "shipping": shipping.value,
      "fromWarehouseId": selectedWarehouse.value!.id,
      "toWarehouseId": selectedToWarehouse.value!.id,
      "transferItems": itemList
    };
    final response = await transferRepository.createTransferWithItem(data);
    if (response != null && response.statusCode == 201) {
      dateController.clear();
      transferDate = DateTime.now();
      selectedWarehouse.value = null;
      selectedToWarehouse.value = null;
      selectedCustomer.value = null;
      searchController.clear();
      transferItemList.clear();
      shipping.value = 0;
      shippingController.clear();
      grandTotal.value = 0;
      descriptionController.clear();
      var date = DateFormat('dd/MM/yyyy').format(transferDate);
      dateController.text = date;
      Get.snackbar("Success", "New Transfer Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  // void createTransfer() async {
  //   Map<String, dynamic> data = {
  //     "date": 0,
  //     "status": 0,
  //     "amount": 100,
  //     "refCode": "",
  //     "note": "",
  //     "shipping": 0,
  //     "warehouseId": 1,
  //     "supplierId": 1
  //   };
  //   final response = await transferRepository.createTransfer(data);
  //   if (response != null && response.statusCode == 201) {
  //     //nameController.clear();
  //     descriptionController.clear();
  //     Get.snackbar("Success", "Transfer Created.",
  //         snackPosition: SnackPosition.bottom);
  //   }
  // }

  // void createTransferItem() async {
  //   Map<String, dynamic> data = {
  //     "quantity": 0,
  //     "subTotal": 0,
  //     "productCost": 100,
  //     "productId": 1,
  //     "transferId": 1
  //   };
  //   final response = await transferRepository.createTransferItem(data);
  //   if (response != null && response.statusCode == 201) {
  //     //nameController.clear();
  //     descriptionController.clear();
  //     Get.snackbar("Success", "Transfer Created.",
  //         snackPosition: SnackPosition.bottom);
  //   }
  // }

  // void updateTransfer(int id) async {
  //   final response = await transferRepository.updateTransfer(
  //       id);
  //   if (response != null && response.statusCode == 200) {
  //     // nameController.clear();
  //     // descriptionController.clear();
  //     // Get.rootController.rootDelegate.canBack
  //     //     ? Get.back()
  //     //     : Get.offAllNamed('${Routes.app}${Routes.transfers}');
  //     // Get.snackbar("Success", "Transfer Updated.",
  //     //     snackPosition: SnackPosition.bottom);
  //   }
  // }

  Future<List<Map<String, dynamic>>> searchTransferProduct(
      String pattern) async {
    final response = await transferRepository.searchTransferProduct(params: {
      "searchTerm": pattern,
      "warehouseId": selectedWarehouse.value?.id
    });
    if (response != null && response.statusCode == 200) {
      final data = response.data as List<dynamic>;

      List<Map<String, dynamic>> res = [];
      for (var element in data) {
        res.add(element);
      }
      return res;
    } else {
      return [];
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null) {
      transferDate = picked;
      var date = DateFormat('dd/MM/yyyy').format(picked);
      dateController.text = date;
    }
  }

  Future<List<WarehouseModel>> getAllWarehouses() async {
    final WarehouseService warehouseService = WarehouseService();
    final response = await warehouseService.getAllWarehouses();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((v) => WarehouseModel.fromJson(v)).toList();
    } else {
      return [];
    }
  }

  Future<List<CustomerModel>> getAllCustomers() async {
    final CustomerService customerService = CustomerService();
    final response = await customerService.getAllCustomers();
    if (response != null && response.statusCode == 200) {
      List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((v) => CustomerModel.fromJson(v)).toList();
    } else {
      return [];
    }
  }
}
