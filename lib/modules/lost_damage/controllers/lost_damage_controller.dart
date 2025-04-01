import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/customer/model/customer_model.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import 'package:pharmacy_pos/modules/warehouse/services/warehouse_services.dart';

import '../../customer/services/customer_services.dart';
import '../repository/lost_damage_repository.dart';

class LostDamageItemModel {
  int productId;
  String productName;
  int quantity;
  int stock;
  int productCost;
  int productPrice;
  String unit;
  int subTotal;
  LostDamageItemModel(
      {required this.productId,
      required this.productName,
      required this.quantity,
      required this.stock,
      required this.productPrice,
      required this.unit,
      required this.productCost,
      required this.subTotal});
}

class LostDamageController extends GetxController {
  final LostDamageRepository lostdamageRepository;
  LostDamageController(this.lostdamageRepository);

  Rx<WarehouseModel?> selectedWarehouse = Rx<WarehouseModel?>(null);
  //Rx<WarehouseModel?> selectedToWarehouse = Rx<WarehouseModel?>(null);
  //Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);
  //Rx<LostDamageResponse?> lostdamageResponse = Rx<LostDamageResponse?>(null);

  // RxInt shipping = 0.obs;
  RxInt grandTotal = 0.obs;

  RxList<LostDamageItemModel> lostdamageItemList = <LostDamageItemModel>[].obs;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  late DateTime lostdamageDate = DateTime.now();

  final GlobalKey<FormState> createLostDamageFormKey = GlobalKey<FormState>();
  //final GlobalKey<FormState> warehouseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateLostDamageFormKey = GlobalKey<FormState>();

  // Future<void> getLostDamage(int id) async {
  //   print(id);
  //   final response = await lostdamageRepository.getLostDamage(id: id);
  //   if (response != null && response.statusCode == 200) {
  //     print(response.data);
  //     lostdamageResponse.value = LostDamageResponse.fromJson(response.data);
  //   }
  // }

  void calculateGrandTotal() {
    grandTotal.value =
        lostdamageItemList.fold(0, (sum, item) => sum + item.subTotal);
  }

  void createLostDamageWithItem() async {
    if (lostdamageItemList.isEmpty) return;

    Map<String, dynamic> data = {
      "reason": reasonController.text,
      "amount": grandTotal.value,
      "note": descriptionController.text,
      "quantity": lostdamageItemList.value.first.quantity,
      "warehouseId": selectedWarehouse.value!.id,
      "productId": lostdamageItemList.value.first.productId,
    };
    final response = await lostdamageRepository.createLostDamageWithItem(data);
    if (response != null && response.statusCode == 201) {
      dateController.clear();
      lostdamageDate = DateTime.now();
      selectedWarehouse.value = null;
      //selectedCustomer.value = null;
      searchController.clear();
      lostdamageItemList.clear();
      reasonController.clear();
      grandTotal.value = 0;
      descriptionController.clear();
      var date = DateFormat('dd/MM/yyyy').format(lostdamageDate);
      dateController.text = date;
      Get.snackbar("Success", "New LostDamage Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  // void createLostDamage() async {
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
  //   final response = await lostdamageRepository.createLostDamage(data);
  //   if (response != null && response.statusCode == 201) {
  //     //nameController.clear();
  //     descriptionController.clear();
  //     Get.snackbar("Success", "LostDamage Created.",
  //         snackPosition: SnackPosition.bottom);
  //   }
  // }

  // void createLostDamageItem() async {
  //   Map<String, dynamic> data = {
  //     "quantity": 0,
  //     "subTotal": 0,
  //     "productCost": 100,
  //     "productId": 1,
  //     "lostdamageId": 1
  //   };
  //   final response = await lostdamageRepository.createLostDamageItem(data);
  //   if (response != null && response.statusCode == 201) {
  //     //nameController.clear();
  //     descriptionController.clear();
  //     Get.snackbar("Success", "LostDamage Created.",
  //         snackPosition: SnackPosition.bottom);
  //   }
  // }

  // void updateLostDamage(int id) async {
  //   final response = await lostdamageRepository.updateLostDamage(
  //       id);
  //   if (response != null && response.statusCode == 200) {
  //     // nameController.clear();
  //     // descriptionController.clear();
  //     // Get.rootController.rootDelegate.canBack
  //     //     ? Get.back()
  //     //     : Get.offAllNamed('${Routes.app}${Routes.lostdamages}');
  //     // Get.snackbar("Success", "LostDamage Updated.",
  //     //     snackPosition: SnackPosition.bottom);
  //   }
  // }

  Future<List<Map<String, dynamic>>> searchLostDamageProduct(
      String pattern) async {
    final response = await lostdamageRepository.searchLostDamageProduct(
        params: {
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
      lostdamageDate = picked;
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
