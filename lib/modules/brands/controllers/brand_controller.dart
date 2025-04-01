import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/brands/repository/brand_repository.dart';

import '../../../routes/routes.dart';
import '../model/brand_model.dart';

class BrandController extends GetxController {
  final BrandRepository brandRepository;
  BrandController(this.brandRepository);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> createBrandFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateBrandFormKey = GlobalKey<FormState>();

  Future<void> getBrand(int id) async {
    final response = await brandRepository.getBrand(id: id);
    final brandModel = Brands.fromJson(response?.data);
    nameController.text = brandModel.name;
    descriptionController.text = brandModel.description ?? "";
  }

  void createBrand() async {
    final response = await brandRepository.createBrand(
        nameController.text, descriptionController.text);
    if (response != null && response.statusCode == 201) {
      nameController.clear();
      descriptionController.clear();
      Get.snackbar("Success", "Brand Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void updateBrand(int id) async {
    final response = await brandRepository.updateBrand(
        id, nameController.text, descriptionController.text);
    if (response != null && response.statusCode == 200) {
      nameController.clear();
      descriptionController.clear();
      Get.rootController.rootDelegate.canBack
          ? Get.back()
          : Get.offAllNamed('${Routes.app}${Routes.brands}');
      Get.snackbar("Success", "Brand Updated.",
          snackPosition: SnackPosition.bottom);
    }
  }
}
