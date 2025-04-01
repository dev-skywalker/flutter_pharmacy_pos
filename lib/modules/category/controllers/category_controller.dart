import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../model/category_model.dart';
import '../repository/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository categoryRepository;
  CategoryController(this.categoryRepository);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> createCategoryFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateCategoryFormKey = GlobalKey<FormState>();

  Future<void> getCategory(int id) async {
    final response = await categoryRepository.getCategory(id: id);
    final categoryModel = Category.fromJson(response?.data);
    nameController.text = categoryModel.name;
    descriptionController.text = categoryModel.description ?? "";
  }

  void createCategory() async {
    final response = await categoryRepository.createCategory(
        nameController.text, descriptionController.text);
    if (response != null && response.statusCode == 201) {
      nameController.clear();
      descriptionController.clear();
      Get.snackbar("Success", "Category Created.",
          snackPosition: SnackPosition.bottom);
    }
  }

  void updateCategory(int id) async {
    final response = await categoryRepository.updateCategory(
        id, nameController.text, descriptionController.text);
    if (response != null && response.statusCode == 200) {
      nameController.clear();
      descriptionController.clear();
      Get.rootController.rootDelegate.canBack
          ? Get.back()
          : Get.offAllNamed('${Routes.app}${Routes.category}');
      Get.snackbar("Success", "Category Updated.",
          snackPosition: SnackPosition.bottom);
    }
  }
}
