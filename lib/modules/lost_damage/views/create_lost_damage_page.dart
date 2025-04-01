import 'package:data_table_2/data_table_2.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../routes/routes.dart';
import '../controllers/lost_damage_controller.dart';

class CreateLostDamagePage extends GetView<LostDamageController> {
  const CreateLostDamagePage({super.key});
  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width >= 980;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Create New Lost/Damage"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.lostDamage}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.createLostDamageFormKey.currentState!.validate();
              if (isValidate) {
                controller.createLostDamageWithItem();
              }
              //print(controller.lostdamageDate.toIso8601String());
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _createLostDamageWidget(context, isSmallScreen),
    );
  }

  Widget _createLostDamageWidget(BuildContext context, bool isSmallScreen) {
    var date = DateFormat('dd/MM/yyyy').format(controller.lostdamageDate);
    controller.dateController.text = date;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          key: controller.createLostDamageFormKey,
          child: Column(
            children: [
              ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Date:"),
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: controller.dateController,
                            decoration: const InputDecoration(
                                hintText: "Date", border: OutlineInputBorder()),
                            onTap: () => controller.selectDate(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text("Source Warehouse:"),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Obx(() {
                            return DropdownSearch<WarehouseModel>(
                              enabled: controller.lostdamageItemList.isEmpty,
                              validator: (value) {
                                if (controller.selectedWarehouse.value ==
                                        null ||
                                    value == null) {
                                  return 'Warehouse is required!';
                                }
                                return null;
                              },
                              popupProps: const PopupProps.menu(
                                constraints: BoxConstraints(maxHeight: 200),
                                searchDelay: Duration.zero,
                              ),
                              asyncItems: (String filter) =>
                                  controller.getAllWarehouses(),
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Warehouse",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              selectedItem: controller.selectedWarehouse.value,
                              onChanged: (value) {
                                controller.selectedWarehouse.value = value!;
                              },
                              itemAsString: (WarehouseModel warehouse) =>
                                  warehouse.name,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  // ResponsiveGridCol(
                  //   lg: 4,
                  //   md: 6,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const Row(
                  //           children: [
                  //             Text("Distanation Warehouse:"),
                  //             Text(
                  //               " *",
                  //               style: TextStyle(color: Colors.red),
                  //             )
                  //           ],
                  //         ),
                  //         const SizedBox(
                  //           height: 6,
                  //         ),
                  //         Obx(() {
                  //           return DropdownSearch<WarehouseModel>(
                  //             enabled: controller.lostdamageItemList.isEmpty,
                  //             validator: (value) {
                  //               if (controller.selectedToWarehouse.value ==
                  //                       null ||
                  //                   value == null) {
                  //                 return 'Warehouse is required!';
                  //               }
                  //               return null;
                  //             },
                  //             popupProps: PopupProps.menu(
                  //               disabledItemFn: (item) {
                  //                 if (item.id ==
                  //                     controller.selectedWarehouse.value!.id) {
                  //                   return true;
                  //                 } else {
                  //                   return false;
                  //                 }
                  //               },
                  //               constraints:
                  //                   const BoxConstraints(maxHeight: 200),
                  //               searchDelay: Duration.zero,
                  //             ),
                  //             asyncItems: (String filter) =>
                  //                 controller.getAllWarehouses(),
                  //             dropdownDecoratorProps:
                  //                 const DropDownDecoratorProps(
                  //               dropdownSearchDecoration: InputDecoration(
                  //                 hintText: "Warehouse",
                  //                 border: OutlineInputBorder(),
                  //               ),
                  //             ),
                  //             selectedItem:
                  //                 controller.selectedToWarehouse.value,
                  //             onChanged: (value) {
                  //               controller.selectedToWarehouse.value = value;
                  //             },
                  //             itemAsString: (WarehouseModel warehouse) =>
                  //                 warehouse.name,
                  //           );
                  //         }),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  ResponsiveGridCol(
                    lg: 12,
                    child: Obx(() {
                      return Visibility(
                        visible: controller.selectedWarehouse.value == null
                            ? false
                            : true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Search:"),
                              const SizedBox(
                                height: 6,
                              ),
                              DropDownSearchField(
                                debounceDuration:
                                    const Duration(milliseconds: 200),
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                autoFlipMinHeight: 300,
                                //autoFlipDirection: false,
                                //loadingBuilder: (context) => Container(),
                                textFieldConfiguration: TextFieldConfiguration(
                                    //autofocus: true,
                                    controller: controller.searchController,
                                    decoration: const InputDecoration(
                                        hintText: "Search Products",
                                        border: OutlineInputBorder())),
                                suggestionsCallback: (pattern) async {
                                  // if (controller.selectedWarehouse.value ==
                                  //     null) {
                                  //   return [];
                                  // }
                                  if (pattern.isEmpty) return [];
                                  return await controller
                                      .searchLostDamageProduct(pattern);
                                  //if (pattern.length <= 1) return [];
                                  // return [
                                  //   {"name": "ggg", "sub": "hh"},
                                  //   {"name": "sss", "sub": "hh"}
                                  //];
                                },
                                itemBuilder: (context, suggestion) {
                                  //print(suggestion['productName']);
                                  return ListTile(
                                    leading: const Icon(Icons.shopping_cart),
                                    title: Text("${suggestion['productName']}"),
                                    subtitle:
                                        Text('${suggestion['warehouseStock']}'),
                                    trailing:
                                        Text('\$${suggestion['productCost']}'),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  int index = controller.lostdamageItemList
                                      .indexWhere((item) =>
                                          item.productId ==
                                          suggestion['productId']);

                                  if (index != -1) {
                                    // If the product already exists, update its quantity and subtotal
                                    var existingProduct =
                                        controller.lostdamageItemList[index];
                                    int newQuantity = existingProduct.quantity +
                                        1; // Increment the quantity by 1 (you can adjust this logic if needed)
                                    int newSubTotal = existingProduct
                                            .productCost *
                                        newQuantity; // Calculate new subtotal
                                    // Update the product in the list
                                    controller.lostdamageItemList[index] =
                                        LostDamageItemModel(
                                      productName: existingProduct.productName,
                                      productId: existingProduct.productId,
                                      quantity: newQuantity,
                                      productCost: existingProduct.productCost,
                                      productPrice:
                                          existingProduct.productPrice,
                                      unit: existingProduct.unit,
                                      subTotal: newSubTotal,
                                      stock: existingProduct.stock,
                                    );
                                  } else {
                                    // If the product doesn't exist, add it to the list

                                    if (controller.lostdamageItemList.isEmpty) {
                                      if (suggestion['warehouseStock'] != 0) {
                                        controller.lostdamageItemList.add(
                                          LostDamageItemModel(
                                            productName:
                                                suggestion['productName'],
                                            productId: suggestion['productId'],
                                            quantity: 1,
                                            productCost:
                                                suggestion['productCost'],
                                            productPrice:
                                                suggestion['productPrice'],
                                            unit: suggestion['unit'],
                                            subTotal: suggestion['productCost'],
                                            stock: suggestion[
                                                'warehouseStock'], // Initial subtotal is productCost * quantity (1)
                                          ),
                                        );
                                      } else {
                                        Get.snackbar("Out of stock",
                                            "Product out of stock",
                                            snackPosition:
                                                SnackPosition.bottom);
                                      }
                                    } else {
                                      Get.snackbar("Something Wrong",
                                          "Add only one items",
                                          snackPosition: SnackPosition.bottom);
                                    }
                                  }
                                  controller.calculateGrandTotal();
                                  controller.searchController.clear();
                                },
                                displayAllSuggestionWhenTap: false,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    const Text("Order Items:"),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                        color: Colors.blueGrey.withOpacity(0.2),
                        height: 180,
                        // padding: const EdgeInsets.all(16),
                        child: Obx(() {
                          controller.lostdamageItemList.value;
                          return DataTable2(
                              columnSpacing: 12,
                              horizontalMargin: 12,
                              minWidth: 600,
                              columns: const [
                                DataColumn2(
                                  label: Text('NO'),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text('PRODUCT'),
                                  size: ColumnSize.L,
                                ),
                                DataColumn2(
                                    label: Text('STOCK'),
                                    size: ColumnSize.S,
                                    numeric: true),
                                DataColumn2(
                                    label: Text('QUANTITY'),
                                    size: ColumnSize.M,
                                    numeric: true),
                                DataColumn2(
                                    label: Text('Unit Cost'),
                                    size: ColumnSize.S,
                                    numeric: true),
                                DataColumn2(
                                    label: Text('Unit Price'),
                                    size: ColumnSize.S,
                                    numeric: true),
                                DataColumn2(
                                  size: ColumnSize.S,
                                  label: Text('Subtotal'),
                                  numeric: true,
                                ),
                                DataColumn2(
                                  label: Text('Action'),
                                  size: ColumnSize.S,
                                  numeric: true,
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                  controller.lostdamageItemList.length,
                                  (index) => DataRow(cells: [
                                        DataCell(Text("${index + 1}")),
                                        DataCell(Text(controller
                                            .lostdamageItemList[index]
                                            .productName
                                            .split(',')[0])),
                                        DataCell(Text(
                                            "${controller.lostdamageItemList[index].stock} ${controller.lostdamageItemList[index].unit}")),
                                        DataCell(Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  if (controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .quantity >
                                                      1) {
                                                    // Update the quantity of the specific item
                                                    controller
                                                        .lostdamageItemList[
                                                            index]
                                                        .quantity--;

                                                    int newSubTotal = controller
                                                            .lostdamageItemList[
                                                                index]
                                                            .quantity *
                                                        controller
                                                            .lostdamageItemList[
                                                                index]
                                                            .productCost;

                                                    // Reassign the modified item to trigger a UI update
                                                    controller.lostdamageItemList[
                                                            index] =
                                                        LostDamageItemModel(
                                                      productName: controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .productName,
                                                      productCost: controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .productCost,
                                                      productPrice: controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .productPrice,
                                                      unit: controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .unit,
                                                      subTotal: newSubTotal,
                                                      quantity: controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .quantity,
                                                      productId: controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .productId,
                                                      stock: controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .stock,
                                                    );
                                                  }
                                                  controller
                                                      .calculateGrandTotal();
                                                },
                                                child: const Text("-")),
                                            SizedBox(
                                              width: 30,
                                              child: Text(controller
                                                  .lostdamageItemList[index]
                                                  .quantity
                                                  .toString()),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  // Update the quantity of the specific item
                                                  if (controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .quantity >=
                                                      controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .stock) return;
                                                  controller
                                                      .lostdamageItemList[index]
                                                      .quantity++;

                                                  int newSubTotal = controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .quantity *
                                                      controller
                                                          .lostdamageItemList[
                                                              index]
                                                          .productCost;

                                                  // Reassign the modified item to trigger a UI update
                                                  controller.lostdamageItemList[
                                                          index] =
                                                      LostDamageItemModel(
                                                          productName: controller
                                                              .lostdamageItemList[
                                                                  index]
                                                              .productName,
                                                          productCost: controller
                                                              .lostdamageItemList[
                                                                  index]
                                                              .productCost,
                                                          productPrice: controller
                                                              .lostdamageItemList[
                                                                  index]
                                                              .productPrice,
                                                          unit: controller
                                                              .lostdamageItemList[
                                                                  index]
                                                              .unit,
                                                          subTotal: newSubTotal,
                                                          quantity: controller
                                                              .lostdamageItemList[
                                                                  index]
                                                              .quantity,
                                                          productId: controller
                                                              .lostdamageItemList[
                                                                  index]
                                                              .productId,
                                                          stock: controller
                                                              .lostdamageItemList[
                                                                  index]
                                                              .stock);
                                                  controller
                                                      .calculateGrandTotal();
                                                },
                                                child: const Text("+"))
                                          ],
                                        )),
                                        DataCell(Text(controller
                                            .lostdamageItemList[index]
                                            .productCost
                                            .toString())),
                                        DataCell(Text(controller
                                            .lostdamageItemList[index]
                                            .productPrice
                                            .toString())),
                                        DataCell(Text(controller
                                            .lostdamageItemList[index].subTotal
                                            .toString())),
                                        DataCell(IconButton(
                                            onPressed: () {
                                              controller.lostdamageItemList
                                                  .removeAt(index);
                                              controller.calculateGrandTotal();
                                            },
                                            icon: const Icon(Icons.delete)))
                                      ])));
                        }))
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ResponsiveGridRow(children: [
                ResponsiveGridCol(
                  lg: 4,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Reason:"),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          maxLines: 2,
                          onChanged: (value) {
                            // controller.shipping.value = controller
                            //         .shippingController.text.isEmpty
                            //     ? 0
                            //     : int.parse(controller.shippingController.text);
                            //controller.calculateGrandTotal();
                          },
                          //readOnly: true,
                          controller: controller.reasonController,
                          decoration: const InputDecoration(
                              hintText: "Reason", border: OutlineInputBorder()),
                          // onTap: () => controller.selectDate(context),
                        ),
                      ],
                    ),
                  ),
                ),
                // ResponsiveGridCol(
                //   lg: 3,
                //   md: 6,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const Text("Status:"),
                //         const SizedBox(
                //           height: 6,
                //         ),
                //         Obx(() {
                //           return DropdownSearch<StatusModel>(
                //             // validator: (value) {
                //             //   if (controller.selectedSupplier.value == null ||
                //             //       value == null) {
                //             //     return 'Supplier is required!';
                //             //   }
                //             //   return null;
                //             // },
                //             popupProps: const PopupProps.menu(
                //               constraints: BoxConstraints(maxHeight: 200),
                //               searchDelay: Duration.zero,
                //             ),
                //             items: [
                //               StatusModel(id: 0, status: "Completed"),
                //               StatusModel(id: 1, status: "Pending"),
                //               StatusModel(id: 2, status: "Ordered")
                //             ],
                //             dropdownDecoratorProps:
                //                 const DropDownDecoratorProps(
                //               dropdownSearchDecoration: InputDecoration(
                //                 hintText: "Choose Status",
                //                 border: OutlineInputBorder(),
                //               ),
                //             ),
                //             selectedItem: controller.selectedStatus.value,
                //             onChanged: (value) {
                //               controller.selectedStatus.value = value!;
                //             },
                //             itemAsString: (StatusModel item) => item.status,
                //           );
                //         })
                //       ],
                //     ),
                //   ),
                // ),
                ResponsiveGridCol(
                  lg: 4,
                  md: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Note:"),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          minLines: 2,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          //readOnly: true,
                          controller: controller.descriptionController,
                          decoration: const InputDecoration(
                              hintText: "Note", border: OutlineInputBorder()),
                          // onTap: () => controller.selectDate(context),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  md: 6,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.blueGrey.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Grand Total"),
                        Obx(() => Text(controller.grandTotal.value.toString()))
                      ],
                    ),
                  ),
                )
              ]),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
