import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../controllers/category_controller.dart';

class UpdateCategoryPage extends GetView<CategoryController> {
  const UpdateCategoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getCategory(int.parse(id));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Create New Category"),
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.category}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.updateCategoryFormKey.currentState!.validate();
              if (isValidate) {
                controller.updateCategory(int.parse(id));
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _updateCategoryWidget(),
    );
  }

  Widget _updateCategoryWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Container(
        color: Colors.white,

        //margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Form(
            key: controller.updateCategoryFormKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Category Name:"),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required!';
                        }
                        return null;
                      },
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        hintText: "Category Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Description:"),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      maxLines: 4,
                      controller: controller.descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _updateCategoryWidget() {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
  //     child: Form(
  //       key: controller.createCategoryFormKey,
  //       child: TextFormField(
  //         validator: (value) {
  //           if (value == null || value.isEmpty) {
  //             return 'Name is required!';
  //           }
  //           return null;
  //         },
  //         controller: controller.nameController,
  //         decoration: const InputDecoration(hintText: "Name"),
  //       ),
  //     ),
  //   );
  // }
}
