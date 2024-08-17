import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/product/controllers/product_controller.dart';
import 'package:pharmacy_pos/modules/product/model/product_model.dart';

import '../../units/model/unit_model.dart';

class UpdateProductPage extends GetView<ProductController> {
  const UpdateProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    //String id = Get.parameters['id'] ?? '';
    ProductModel productModel = Get.arguments as ProductModel;
    List<String> nameList = productModel.name!.split(',');
    String firstItem = nameList.removeAt(0);
    controller.brandNameController.text = firstItem;
    controller.chemicalNameList.addAll(nameList);
    controller.descriptionController.text = productModel.description ?? "";
    controller.tabletOnCardController.text =
        productModel.tabletOnCard.toString();
    controller.cardOnBoxController.text = productModel.cardOnBox.toString();
    controller.selectedUnit.value = productModel.units;
    controller.isLocalProduct.value = productModel.isLocalProduct ?? false;
    controller.updateImageUrl.value = productModel.imageUrl ?? "";
    //controller.imageData != null ? productModel.i

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text("Update Product"),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.updateProductFormKey.currentState!.validate();
              if (isValidate) {
                controller.updateProduct(
                    id: productModel.id!, url: productModel.imageUrl);
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _updateProductWidget(),
    );
  }

  Widget _updateProductWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      child: Form(
        key: controller.updateProductFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'BrandName is required!';
                }
                return null;
              },
              controller: controller.brandNameController,
              decoration: const InputDecoration(hintText: "Brand Name"),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return Wrap(
                children: List<Widget>.generate(
                  controller.chemicalNameList.length,
                  (int idx) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        deleteIcon: const Icon(
                          Icons.clear,
                          size: 18,
                          color: Colors.red,
                        ),
                        onDeleted: () {
                          controller.chemicalNameList.removeAt(idx);
                        },
                        clipBehavior: Clip.antiAlias,
                        label: Text(controller.chemicalNameList[idx]),
                      ),
                    );
                  },
                ).toList(),
              );
            }),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: controller.chemicalNameController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: "Chemical Name",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                      onPressed: () {
                        if (controller.chemicalNameController.text.isNotEmpty) {
                          controller.chemicalNameList
                              .add(controller.chemicalNameController.text);
                          controller.chemicalNameController.clear();
                        }
                      },
                      child: const Text("Add")),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onTap: () {
                controller.hasImage.value = false;
                controller.imageData = null;
              },
              controller: controller.descriptionController,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return DropdownSearch<Units>(
                      validator: (value) {
                        if (controller.selectedUnit.value == null ||
                            value == null) {
                          return 'Unit is required!';
                        }
                        return null;
                      },
                      popupProps: const PopupProps.menu(
                        constraints: BoxConstraints(maxHeight: 200),
                        searchDelay: Duration.zero,
                      ),
                      asyncItems: (String filter) => controller.getAllUnits(),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            hintText: "Unit", labelText: "Unit"),
                      ),
                      selectedItem: controller.selectedUnit.value,
                      onChanged: (value) {
                        controller.selectedUnit.value = value!;
                      },
                      itemAsString: (Units unit) => unit.name ?? "",
                    );
                  }),
                ),
                Expanded(
                  child: Obx(() {
                    return SwitchListTile(
                        title: const Text("Local Product"),
                        value: controller.isLocalProduct.value,
                        onChanged: (v) => controller.isLocalProduct.value = v);
                  }),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return controller.selectedUnit.value?.name == "card"
                  ? Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: controller.tabletOnCardController,
                            decoration: const InputDecoration(
                                hintText: "Tablets on card"),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: controller.cardOnBoxController,
                            decoration:
                                const InputDecoration(hintText: "Card on box"),
                          ),
                        ),
                      ],
                    )
                  : Container();
            }),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "Product Image",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 18,
                ),
                Obx(() {
                  return controller.updateImageUrl.value != ""
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SizedBox(
                                width: 200,
                                //height: 200,
                                child: Image.network(
                                    controller.updateImageUrl.value)),
                            IconButton(
                                onPressed: () {
                                  controller.updateImageUrl.value = "";
                                },
                                icon: const Icon(Icons.clear))
                          ],
                        )
                      : controller.hasImage.value
                          ? Stack(
                              alignment: Alignment.topRight,
                              children: [
                                SizedBox(
                                    width: 200,
                                    //height: 200,
                                    child: Image.memory(controller.imageData!)),
                                IconButton(
                                    onPressed: () {
                                      controller.imageData = null;
                                      controller.hasImage.value = false;
                                    },
                                    icon: const Icon(Icons.clear))
                              ],
                            )
                          : ElevatedButton(
                              onPressed: () {
                                controller.pickProductImage();
                              },
                              child: const Text("Pick Image"));
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
