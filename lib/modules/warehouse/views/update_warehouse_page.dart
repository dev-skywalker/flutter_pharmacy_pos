import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../controllers/warehouse_controller.dart';

class UpdateWarehousePage extends GetView<WarehouseController> {
  const UpdateWarehousePage({super.key});
  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getWarehouse(int.parse(id));

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text("Update Warehouse"),
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.warehouses}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.updateWarehouseFormKey.currentState!.validate();
              if (isValidate) {
                controller.updateWarehouse(int.parse(id));
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _updateWarehouseWidget(),
    );
  }

  Widget _updateWarehouseWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Form(
            key: controller.updateWarehouseFormKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Warehouse Name:"),
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
                        hintText: "Warehouse Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Phone:"),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: controller.phoneController,
                      decoration: const InputDecoration(
                        hintText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email:"),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        hintText: "Email address",
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
                    const Text("City:"),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: controller.cityController,
                      decoration: const InputDecoration(
                        hintText: "City",
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
                    const Text("Address:"),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      maxLines: 3,
                      controller: controller.addressController,
                      decoration: const InputDecoration(
                        hintText: "Address",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
