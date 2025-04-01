import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../routes/routes.dart';
import '../controllers/product_controller.dart';

class ProductDetailsPage extends GetView<ProductController> {
  const ProductDetailsPage({super.key});
  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getProduct(int.parse(id), false);
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text("Product Details"),
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.products}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
      ),
      body: _updateProductWidget(),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _updateProductWidget() {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Obx(() {
            if (controller.productDetails.value == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              var product = controller.productDetails.value!;
              var nameList = product.name.split(",");
              var brandName = nameList[0];
              nameList.removeAt(0);
              DateTime? expire =
                  DateTime.fromMillisecondsSinceEpoch(product.expireDate!);
              DateTime? createdAt =
                  DateTime.fromMillisecondsSinceEpoch(product.createdAt!);
              DateTime? updatedAt =
                  DateTime.fromMillisecondsSinceEpoch(product.updatedAt!);
              var date = DateFormat('dd/MM/yyyy');

              return ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    sm: 12,
                    md: 6,
                    lg: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem("Product Name/Brand Name:", brandName),
                        _buildDetailItem(
                            "Chemical Name/Other Name:", nameList.join(", ")),
                        _buildDetailItem(
                            "Description:", product.description ?? ""),
                        _buildDetailItem(
                            "Categories:",
                            product.productCategories
                                .map((e) => e.category?.name ?? "")
                                .join(", ")),
                        _buildDetailItem("Expire Date:", date.format(expire)),
                      ],
                    ),
                  ),
                  ResponsiveGridCol(
                    sm: 12,
                    md: 6,
                    lg: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem("Brand:", product.brand.name),
                        _buildDetailItem("Unit:", product.unit.name),
                        if (product.unit.name.toLowerCase() == "card")
                          _buildDetailItem("Presantation:",
                              "${product.tabletOnCard}Tablets x ${product.cardOnBox}Card"),
                        _buildDetailItem("Local Product:",
                            product.isLocalProduct! ? "Yes" : "No"),
                        _buildDetailItem("Quantity Limit:",
                            product.quantityLimit.toString()),
                      ],
                    ),
                  ),
                  // ResponsiveGridCol(
                  //   sm: 12,
                  //   md: 6,
                  //   lg: 4,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [

                  //     ],
                  //   ),
                  // ),
                  // ResponsiveGridCol(
                  //   sm: 12,
                  //   md: 6,
                  //   lg: 4,
                  //   child: _buildDetailItem(
                  //       "Local Product:", product.isLocalProduct.toString()),
                  // ),
                  // ResponsiveGridCol(
                  //   sm: 12,
                  //   md: 6,
                  //   lg: 4,
                  //   child: _buildDetailItem(
                  //       "Categories:",
                  //       product.productCategories
                  //           .map((e) => e.category?.name ?? "")
                  //           .join(", ")),
                  // ),
                  // ResponsiveGridCol(
                  //   sm: 12,
                  //   md: 6,
                  //   lg: 4,
                  //   child: _buildDetailItem(
                  //       "Cost:", "\$${product.productCost.toString()}"),
                  // ),
                  // ResponsiveGridCol(
                  //   sm: 12,
                  //   md: 6,
                  //   lg: 4,
                  //   child: _buildDetailItem(
                  //       "Price:", "\$${product.productPrice.toString()}"),
                  // ),

                  ResponsiveGridCol(
                    sm: 12,
                    md: 6,
                    lg: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem(
                            "Stock Alert:", product.stockAlert.toString()),
                        _buildDetailItem("Created At:", date.format(createdAt)),
                        _buildDetailItem("Updated At:", date.format(updatedAt)),
                        product.imageUrl != ""
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Product Image",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      height: 180,
                                      child: Image.network(product.imageUrl!),
                                    ),
                                  ],
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Product Image",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 6),
                                    SizedBox(
                                        //height: 180,
                                        //child: Image.network(product.imageUrl!),
                                        ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),

                  ResponsiveGridCol(
                    sm: 12,
                    md: 6,
                    lg: 4,
                    child: Obx(() {
                      if (controller.isUpdateCost.value) {
                        controller.updateCostController.text =
                            product.productCost.toString();
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Product Cost:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: TextFormField(
                                      controller:
                                          controller.updateCostController,
                                      // onChanged: (value) {
                                      //   controller.updateCostController.text =
                                      //       value;
                                      // },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        controller.isUpdateCost.value = false;
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        controller
                                            .updateProductCost(product.id);
                                      },
                                      icon: const Icon(Icons.done)),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Row(
                          children: [
                            _buildDetailItem("Product Cost:",
                                "\$${product.productCost.toString()}"),
                            IconButton(
                                onPressed: () {
                                  controller.isUpdateCost.value = true;
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        );
                      }
                    }),
                  ),
                  ResponsiveGridCol(
                    sm: 12,
                    md: 6,
                    lg: 4,
                    child: Obx(() {
                      if (controller.isUpdatePrice.value) {
                        controller.updatePriceController.text =
                            product.productPrice.toString();
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Product Price:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: TextFormField(
                                      controller:
                                          controller.updatePriceController,
                                      // onChanged: (value) {
                                      //   controller.updatePriceController.text =
                                      //       value;
                                      // },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        controller.isUpdatePrice.value = false;
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        controller
                                            .updateProductPrice(product.id);
                                      },
                                      icon: const Icon(Icons.done)),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Row(
                          children: [
                            _buildDetailItem("Product Price:",
                                "\$${product.productPrice.toString()}"),
                            IconButton(
                                onPressed: () {
                                  controller.isUpdatePrice.value = true;
                                },
                                icon: const Icon(Icons.edit))
                          ],
                        );
                      }
                    }),
                  ),
                ],
              );
            }
          }),
        ));
  }

  // Widget _updateProductWidget() {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
  //     child: Form(
  //       key: controller.updateProductFormKey,
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
