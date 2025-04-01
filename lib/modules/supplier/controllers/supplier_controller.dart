import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/supplier/model/supplier_model.dart';
import '../../../routes/routes.dart';
import '../repository/supplier_repository.dart';

class SupplierController extends GetxController {
  final SupplierRepository supplierRepository;
  SupplierController(this.supplierRepository);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final GlobalKey<FormState> createSupplierFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateSupplierFormKey = GlobalKey<FormState>();

  Future<void> getSupplier(int id) async {
    final response = await supplierRepository.getSupplier(id: id);
    final supplierModel = SupplierModel.fromJson(response?.data);
    nameController.text = supplierModel.name;
    phoneController.text = supplierModel.phone ?? "";
    emailController.text = supplierModel.email ?? "";
    cityController.text = supplierModel.city ?? "";
    addressController.text = supplierModel.address ?? "";
  }

  void createSupplier() async {
    final response = await supplierRepository.createSupplier({
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
      Get.snackbar("Success", "Supplier Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void updateSupplier(int id) async {
    final response = await supplierRepository.updateSupplier({
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
          : Get.offAllNamed('${Routes.app}${Routes.suppliers}');
      Get.snackbar("Success", "Supplier Updated.",
          snackPosition: SnackPosition.bottom);
    }
  }
}
