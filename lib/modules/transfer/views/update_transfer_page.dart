import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/transfer_controller.dart';

class UpdateTransferPage extends GetView<TransferController> {
  const UpdateTransferPage({super.key});
  @override
  Widget build(BuildContext context) {
    // String id = Get.parameters['id'] ?? '';
    // controller.getTransfer(int.parse(id));
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text("Update Transfer"),
        leading: IconButton(
          onPressed: () {
            // Get.rootController.rootDelegate.canBack
            //     ? Get.back()
            //     : Get.offAllNamed('${Routes.app}${Routes.transfers}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.updateTransferFormKey.currentState!.validate();
              if (isValidate) {
                //controller.updateTransfer(int.parse(id));
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _updateTransferWidget(),
    );
  }

  Widget _updateTransferWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Container(
        color: Colors.white,

        //margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Form(
            key: controller.updateTransferFormKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Transfer Name:"),
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
                      //controller: controller.nameController,
                      decoration: const InputDecoration(
                        hintText: "Transfer Name",
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
  // Widget _updateTransferWidget() {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
  //     child: Form(
  //       key: controller.updateTransferFormKey,
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
