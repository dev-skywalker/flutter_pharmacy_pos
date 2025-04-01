import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/units/repository/unit_repository.dart';

import '../../../routes/routes.dart';
import '../model/unit_model.dart';

class UnitController extends GetxController {
  final UnitRepository unitRepository;
  UnitController(this.unitRepository);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> createUnitFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateUnitFormKey = GlobalKey<FormState>();

  Future<void> getUnit(int id) async {
    final response = await unitRepository.getUnit(id: id);
    final unitModel = Units.fromJson(response?.data);
    nameController.text = unitModel.name;
    descriptionController.text = unitModel.description ?? "";
  }

  void createUnit() async {
    final response = await unitRepository.createUnit(
        nameController.text, descriptionController.text);
    if (response != null && response.statusCode == 201) {
      nameController.clear();
      descriptionController.clear();
      Get.snackbar("Success", "Unit Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void updateUnit(int id) async {
    final response = await unitRepository.updateUnit(
        id, nameController.text, descriptionController.text);
    if (response != null && response.statusCode == 200) {
      nameController.clear();
      descriptionController.clear();
      Get.rootController.rootDelegate.canBack
          ? Get.back()
          : Get.offAllNamed('${Routes.app}${Routes.units}');
      Get.snackbar("Success", "Unit Updated.",
          snackPosition: SnackPosition.bottom);
    }
  }
}
