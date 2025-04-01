import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';
import '../controllers/customer_controller.dart';

class CreateCustomerPage extends GetView<CustomerController> {
  const CreateCustomerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Create New Customer"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back(result: "back")
                : Get.offAllNamed('${Routes.app}${Routes.customers}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.createCustomerFormKey.currentState!.validate();
              if (isValidate) {
                controller.createCustomer();
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _createCustomerWidget(),
    );
  }

  Widget _createCustomerWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Form(
            key: controller.createCustomerFormKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Customer Name:"),
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
                        hintText: "Customer Name",
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
