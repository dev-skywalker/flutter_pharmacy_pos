import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import '../../../routes/routes.dart';
import '../repository/warehouse_repository.dart';

class WarehouseController extends GetxController {
  final WarehouseRepository warehouseRepository;
  WarehouseController(this.warehouseRepository);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final GlobalKey<FormState> createWarehouseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateWarehouseFormKey = GlobalKey<FormState>();

  Future<void> getWarehouse(int id) async {
    final response = await warehouseRepository.getWarehouse(id: id);
    final warehouseModel = WarehouseModel.fromJson(response?.data);
    nameController.text = warehouseModel.name;
    phoneController.text = warehouseModel.phone ?? "";
    emailController.text = warehouseModel.email ?? "";
    cityController.text = warehouseModel.city ?? "";
    addressController.text = warehouseModel.address ?? "";
  }

  void createWarehouse() async {
    final response = await warehouseRepository.createWarehouse({
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "city": cityController.text,
      "address": addressController.text
    });
    if (response != null && response.statusCode == 201) {
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      cityController.clear();
      addressController.clear();
      Get.snackbar("Success", "Warehouse Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void updateWarehouse(int id) async {
    final response = await warehouseRepository.updateWarehouse({
      "id": id,
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "city": cityController.text,
      "address": addressController.text,
      "createdAt": DateTime.now().millisecondsSinceEpoch
    });
    if (response != null && response.statusCode == 200) {
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      cityController.clear();
      addressController.clear();
      Get.rootController.rootDelegate.canBack
          ? Get.back()
          : Get.offAllNamed('${Routes.app}${Routes.warehouses}');
      Get.snackbar("Success", "Warehouse Updated.",
          snackPosition: SnackPosition.bottom);
    }
  }
}
