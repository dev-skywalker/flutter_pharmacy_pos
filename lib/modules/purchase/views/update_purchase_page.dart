import 'package:data_table_2/data_table_2.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../routes/routes.dart';
import '../../payment_type/model/payment_type_model.dart';
import '../../supplier/model/supplier_model.dart';
import '../../warehouse/model/warehouse_model.dart';
import '../controllers/purchase_controller.dart';

class UpdatePurchasePage extends GetView<PurchaseController> {
  const UpdatePurchasePage({super.key});
  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getPurchase(int.parse(id), false);
    bool isSmallScreen = MediaQuery.of(context).size.width >= 980;

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text("Update Purchase"),
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.purchases}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.updatePurchaseFormKey.currentState!.validate();
              if (isValidate) {
                controller.updatePurchaseWithItem(int.parse(id));
              }
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _updatePurchaseWidget(context, isSmallScreen),
    );
  }

  Widget _updatePurchaseWidget(BuildContext context, bool isSmallScreen) {
    var date = DateFormat('dd/MM/yyyy').format(controller.purchaseDate);
    controller.dateController.text = date;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          key: controller.updatePurchaseFormKey,
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
                              Text("Warehouse:"),
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
                              enabled: controller.purchaseItemList.isEmpty,
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
                              Text("Supplier:"),
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
                            return DropdownSearch<SupplierModel>(
                              validator: (value) {
                                if (controller.selectedSupplier.value == null ||
                                    value == null) {
                                  return 'Supplier is required!';
                                }
                                return null;
                              },
                              popupProps: const PopupProps.menu(
                                constraints: BoxConstraints(maxHeight: 200),
                                searchDelay: Duration.zero,
                              ),
                              asyncItems: (String filter) =>
                                  controller.getAllSuppliers(),
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Supplier",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              selectedItem: controller.selectedSupplier.value,
                              onChanged: (value) {
                                controller.selectedSupplier.value = value!;
                              },
                              itemAsString: (SupplierModel supplier) =>
                                  supplier.name,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
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
                                      .searchPurchaseProduct(pattern);
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
                                  int index = controller.purchaseItemList
                                      .indexWhere((item) =>
                                          item.productId ==
                                          suggestion['productId']);

                                  if (index != -1) {
                                    // If the product already exists, update its quantity and subtotal
                                    var existingProduct =
                                        controller.purchaseItemList[index];
                                    int newQuantity = existingProduct.quantity +
                                        1; // Increment the quantity by 1 (you can adjust this logic if needed)
                                    int newSubTotal = existingProduct
                                            .productCost *
                                        newQuantity; // Calculate new subtotal

                                    // Update the product in the list
                                    controller.purchaseItemList[index] =
                                        PurchaseItemModel(
                                      productName: existingProduct.productName,
                                      productId: existingProduct.productId,
                                      quantity: newQuantity,
                                      productCost: existingProduct.productCost,
                                      // productPrice:
                                      //     existingProduct.productPrice,
                                      unit: existingProduct.unit,
                                      subTotal: newSubTotal,
                                      stock: existingProduct.stock,
                                    );
                                  } else {
                                    // If the product doesn't exist, add it to the list
                                    controller.purchaseItemList.add(
                                      PurchaseItemModel(
                                        productName: suggestion['productName'],
                                        productId: suggestion['productId'],
                                        quantity: 1,
                                        productCost: suggestion['productCost'],

                                        unit: suggestion['unit'],
                                        subTotal: suggestion['productCost'],
                                        stock: suggestion[
                                            'warehouseStock'], // Initial subtotal is productCost * quantity (1)
                                      ),
                                    );
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
                    Obx(() {
                      controller.tableHeight =
                          ((controller.purchaseItemList.length + 1) * 50);
                      return Column(
                        children: [
                          Container(
                            color: Colors.blueGrey.withOpacity(0.2),
                            height: controller.tableHeight,
                            child: DataTable2(
                                headingRowHeight: 50,
                                dataRowHeight: 50,
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
                                  // DataColumn2(
                                  //     label: Text('Unit Price'),
                                  //     size: ColumnSize.S,
                                  //     numeric: true),
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
                                    controller.purchaseItemList.length,
                                    (index) => DataRow(cells: [
                                          DataCell(Text("${index + 1}")),
                                          DataCell(Text(controller
                                              .purchaseItemList[index]
                                              .productName
                                              .split(',')[0])),
                                          DataCell(Text(
                                              "${controller.purchaseItemList[index].stock} ${controller.purchaseItemList[index].unit}")),
                                          DataCell(Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    if (controller
                                                            .purchaseItemList[
                                                                index]
                                                            .quantity >
                                                        1) {
                                                      // Update the quantity of the specific item
                                                      controller
                                                          .purchaseItemList[
                                                              index]
                                                          .quantity--;

                                                      int newSubTotal = controller
                                                              .purchaseItemList[
                                                                  index]
                                                              .quantity *
                                                          controller
                                                              .purchaseItemList[
                                                                  index]
                                                              .productCost;

                                                      // Reassign the modified item to trigger a UI update
                                                      controller.purchaseItemList[
                                                              index] =
                                                          PurchaseItemModel(
                                                        productName: controller
                                                            .purchaseItemList[
                                                                index]
                                                            .productName,
                                                        productCost: controller
                                                            .purchaseItemList[
                                                                index]
                                                            .productCost,
                                                        unit: controller
                                                            .purchaseItemList[
                                                                index]
                                                            .unit,
                                                        subTotal: newSubTotal,
                                                        quantity: controller
                                                            .purchaseItemList[
                                                                index]
                                                            .quantity,
                                                        productId: controller
                                                            .purchaseItemList[
                                                                index]
                                                            .productId,
                                                        stock: controller
                                                            .purchaseItemList[
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
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  onChanged: (value) {
                                                    controller
                                                            .purchaseItemList[index]
                                                            .quantity =
                                                        int.parse(value);
                                                    int newSubTotal = controller
                                                            .purchaseItemList[
                                                                index]
                                                            .quantity *
                                                        controller
                                                            .purchaseItemList[
                                                                index]
                                                            .productCost;
                                                    // Reassign the modified item to trigger a UI update
                                                    controller.purchaseItemList[
                                                            index] =
                                                        PurchaseItemModel(
                                                      productName: controller
                                                          .purchaseItemList[
                                                              index]
                                                          .productName,
                                                      productCost: controller
                                                          .purchaseItemList[
                                                              index]
                                                          .productCost,
                                                      unit: controller
                                                          .purchaseItemList[
                                                              index]
                                                          .unit,
                                                      subTotal: newSubTotal,
                                                      quantity: controller
                                                          .purchaseItemList[
                                                              index]
                                                          .quantity,
                                                      productId: controller
                                                          .purchaseItemList[
                                                              index]
                                                          .productId,
                                                      stock: controller
                                                          .purchaseItemList[
                                                              index]
                                                          .stock,
                                                    );

                                                    controller
                                                        .calculateGrandTotal();
                                                  },
                                                  controller:
                                                      TextEditingController(
                                                          text: controller
                                                              .purchaseItemList[
                                                                  index]
                                                              .quantity
                                                              .toString()),
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none),
                                                ),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    // Update the quantity of the specific item
                                                    controller
                                                        .purchaseItemList[index]
                                                        .quantity++;

                                                    int newSubTotal = controller
                                                            .purchaseItemList[
                                                                index]
                                                            .quantity *
                                                        controller
                                                            .purchaseItemList[
                                                                index]
                                                            .productCost;

                                                    // Reassign the modified item to trigger a UI update
                                                    controller.purchaseItemList[
                                                            index] =
                                                        PurchaseItemModel(
                                                            productName: controller
                                                                .purchaseItemList[
                                                                    index]
                                                                .productName,
                                                            productCost: controller
                                                                .purchaseItemList[
                                                                    index]
                                                                .productCost,
                                                            unit: controller
                                                                .purchaseItemList[
                                                                    index]
                                                                .unit,
                                                            subTotal:
                                                                newSubTotal,
                                                            quantity: controller
                                                                .purchaseItemList[
                                                                    index]
                                                                .quantity,
                                                            productId: controller
                                                                .purchaseItemList[
                                                                    index]
                                                                .productId,
                                                            stock: controller
                                                                .purchaseItemList[
                                                                    index]
                                                                .stock);
                                                    controller
                                                        .calculateGrandTotal();
                                                  },
                                                  child: const Text("+"))
                                            ],
                                          )),
                                          DataCell(Text(controller
                                              .purchaseItemList[index]
                                              .productCost
                                              .toString())),
                                          // DataCell(Text(controller
                                          //     .purchaseItemList[index]
                                          //     .productPrice
                                          //     .toString())),
                                          DataCell(Text(controller
                                              .purchaseItemList[index].subTotal
                                              .toString())),
                                          DataCell(IconButton(
                                              onPressed: () {
                                                controller.purchaseItemList
                                                    .removeAt(index);
                                                controller
                                                    .calculateGrandTotal();
                                              },
                                              icon: const Icon(Icons.delete)))
                                        ]))),
                          ),
                          Center(
                              child: controller.purchaseItemList.isEmpty
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text("No Data Avaliable"),
                                    )
                                  : Container())
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Container(
                      color: Colors.blueGrey.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Shipping"),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Grand Total"),
                            ],
                          ),
                          Obx(() {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(controller.shipping.value.toString()),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(controller.grandTotal.value.toString()),
                              ],
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
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
                        const Text("Refer Code:"),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          controller: controller.refController,
                          decoration: const InputDecoration(
                              hintText: "Refer Code",
                              border: OutlineInputBorder()),
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
                        const Text("Shipping:"),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            controller.shipping.value = controller
                                    .shippingController.text.isEmpty
                                ? 0
                                : int.parse(controller.shippingController.text);
                            controller.calculateGrandTotal();
                          },
                          //readOnly: true,
                          controller: controller.shippingController,
                          decoration: const InputDecoration(
                              hintText: "Shipping",
                              border: OutlineInputBorder()),
                          // onTap: () => controller.selectDate(context),
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
                            Text("Status:"),
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
                          return DropdownSearch<String>(
                            //enabled: controller.purchaseItemList.isEmpty,
                            validator: (value) {
                              if (value == null) {
                                return 'Status is required!';
                              }
                              return null;
                            },
                            popupProps: const PopupProps.menu(
                              constraints: BoxConstraints(maxHeight: 100),
                              searchDelay: Duration.zero,
                            ),
                            // asyncItems: (String filter) =>
                            //     controller.getAllWarehouses(),
                            items: const ["Received", "Pending"],
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Status",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            selectedItem: controller.selectedStatus.value,
                            onChanged: (value) {
                              controller.selectedStatus.value = value!;
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                )
              ]),
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
                        const Row(
                          children: [
                            Text("Payment Status:"),
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
                          return DropdownSearch<String>(
                            //enabled: controller.purchaseItemList.isEmpty,
                            validator: (value) {
                              if (value == null) {
                                return 'Payment Status is required!';
                              }
                              return null;
                            },
                            popupProps: const PopupProps.menu(
                              showSelectedItems: true,
                              constraints: BoxConstraints(maxHeight: 100),
                              searchDelay: Duration.zero,
                            ),
                            // asyncItems: (String filter) =>
                            //     controller.getAllWarehouses(),
                            items: const ["Paid", "Unpaid"],
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Payment Status",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            selectedItem:
                                controller.selectedPaymentStatus.value,
                            onChanged: (value) {
                              controller.selectedPaymentStatus.value = value!;
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  md: 6,
                  child: Obx(() {
                    return Visibility(
                      visible: controller.selectedPaymentStatus.value == "Paid",
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text("Payment Type:"),
                                Text(
                                  " *",
                                  style: TextStyle(color: Colors.red),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            DropdownSearch<PaymentTypeModel>(
                              enabled: controller.selectedPaymentStatus.value ==
                                  "Paid",
                              // validator: (value) {
                              //   if (controller.selectedPaymentType.value == null ||
                              //       value == null) {
                              //     return 'Payment Type is required!';
                              //   }
                              //   return null;
                              // },
                              popupProps: const PopupProps.menu(
                                //showSelectedItems: true,
                                constraints: BoxConstraints(maxHeight: 150),
                                searchDelay: Duration.zero,
                              ),
                              asyncItems: (String filter) =>
                                  controller.getAllPaymentType(),
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Payment Type",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              selectedItem:
                                  controller.selectedPaymentType.value,
                              onChanged: (value) {
                                controller.selectedPaymentType.value = value!;
                              },
                              itemAsString: (PaymentTypeModel payment) =>
                                  payment.name!,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Note:"),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 3,
                      //readOnly: true,
                      controller: controller.descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Note", border: OutlineInputBorder()),
                      // onTap: () => controller.selectDate(context),
                    ),
                  ],
                ),
              ),
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
