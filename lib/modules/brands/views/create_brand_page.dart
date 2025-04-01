import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../controllers/brand_controller.dart';

class CreateBrandPage extends GetView<BrandController> {
  const CreateBrandPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Create New Brand"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.brands}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.createBrandFormKey.currentState!.validate();
              if (isValidate) {
                controller.createBrand();
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _createBrandWidget(),
    );
  }

  Widget _createBrandWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Container(
        color: Colors.white,

        //margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Form(
            key: controller.createBrandFormKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Brand Name:"),
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
                        hintText: "Brand Name",
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

  // Widget _createBrandWidget() {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
  //     child: Form(
  //       key: controller.createBrandFormKey,
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
