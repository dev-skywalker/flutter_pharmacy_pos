import 'package:data_table_2/data_table_2.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/customer/model/customer_model.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../routes/routes.dart';
import '../../payment_type/model/payment_type_model.dart';
import '../controllers/sales_controller.dart';

class UpdateSalesPage extends GetView<SalesController> {
  const UpdateSalesPage({super.key});
  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getSaleWithStock(int.parse(id));
    bool isSmallScreen = MediaQuery.of(context).size.width >= 980;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Update Sales"),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.sales}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              bool isValidate =
                  controller.updateSalesFormKey.currentState!.validate();
              if (isValidate) {
                controller.updateSalesWithItem(int.parse(id));
              }
              //print(controller.salesDate.toIso8601String());
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _updateSalesWidget(context, isSmallScreen),
    );
  }

  Widget _updateSalesWidget(BuildContext context, bool isSmallScreen) {
    var date = DateFormat('dd/MM/yyyy').format(controller.salesDate);
    controller.dateController.text = date;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          key: controller.updateSalesFormKey,
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
                              enabled: controller.salesItemList.isEmpty,
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
                              Text("Customer:"),
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
                            return DropdownSearch<CustomerModel>(
                              validator: (value) {
                                if (controller.selectedCustomer.value == null ||
                                    value == null) {
                                  return 'Customer is required!';
                                }
                                return null;
                              },
                              popupProps: const PopupProps.menu(
                                constraints: BoxConstraints(maxHeight: 200),
                                searchDelay: Duration.zero,
                              ),
                              asyncItems: (String filter) =>
                                  controller.getAllCustomers(),
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Customer",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              selectedItem: controller.selectedCustomer.value,
                              onChanged: (value) {
                                controller.selectedCustomer.value = value!;
                              },
                              itemAsString: (CustomerModel customer) =>
                                  customer.name,
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
                                      .searchSalesProduct(pattern);
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
                                  int index = controller.salesItemList
                                      .indexWhere((item) =>
                                          item.productId ==
                                          suggestion['productId']);

                                  if (index != -1) {
                                    // If the product already exists, update its quantity and subtotal
                                    var existingProduct =
                                        controller.salesItemList[index];
                                    int newQuantity = existingProduct.quantity +
                                        1; // Increment the quantity by 1 (you can adjust this logic if needed)
                                    int newSubTotal = existingProduct
                                            .productPrice *
                                        newQuantity; // Calculate new subtotal
                                    int profit = (existingProduct.productPrice -
                                            existingProduct.productCost) *
                                        newQuantity;
                                    // Update the product in the list
                                    controller.salesItemList[index] =
                                        SalesItemModel(
                                      productName: existingProduct.productName,
                                      productId: existingProduct.productId,
                                      quantity: newQuantity,
                                      oldQuantity: 0,
                                      productCost: existingProduct.productCost,
                                      productPrice:
                                          existingProduct.productPrice,
                                      unit: existingProduct.unit,
                                      subTotal: newSubTotal,
                                      stock: existingProduct.stock,
                                      profit: profit,
                                    );
                                  } else {
                                    // If the product doesn't exist, add it to the list
                                    if (suggestion['warehouseStock'] != 0) {
                                      int profit = (suggestion['productPrice'] -
                                          suggestion['productCost']);
                                      controller.salesItemList.add(
                                        SalesItemModel(
                                          productName:
                                              suggestion['productName'],
                                          productId: suggestion['productId'],
                                          quantity: 1,
                                          oldQuantity: 0,
                                          profit: profit,
                                          productCost:
                                              suggestion['productCost'],
                                          productPrice:
                                              suggestion['productPrice'],
                                          unit: suggestion['unit'],
                                          subTotal: suggestion['productPrice'],
                                          stock: suggestion[
                                              'warehouseStock'], // Initial subtotal is productCost * quantity (1)
                                        ),
                                      );
                                    } else {
                                      Get.snackbar("Out of stock",
                                          "Product out of stock",
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
                    Obx(() {
                      controller.tableHeight =
                          ((controller.salesItemList.length + 1) * 50);
                      return Container(
                          color: Colors.blueGrey.withOpacity(0.2),
                          height: controller.tableHeight,
                          // padding: const EdgeInsets.all(16),
                          child: DataTable2(
                              columnSpacing: 12,
                              horizontalMargin: 12,
                              dataRowHeight: 50,
                              headingRowHeight: 50,
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
                                  controller.salesItemList.length, (index) {
                                var stockLimit = controller
                                        .salesItemList[index].stock +
                                    controller.salesItemList[index].oldQuantity;
                                return DataRow(cells: [
                                  DataCell(Text("${index + 1}")),
                                  DataCell(Text(controller
                                      .salesItemList[index].productName
                                      .split(',')[0])),
                                  DataCell(Text(
                                      "${controller.salesItemList[index].stock} ${controller.salesItemList[index].unit}")),
                                  DataCell(Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            if (controller.salesItemList[index]
                                                    .quantity >
                                                1) {
                                              // Update the quantity of the specific item
                                              controller.salesItemList[index]
                                                  .quantity--;

                                              int newSubTotal = controller
                                                      .salesItemList[index]
                                                      .quantity *
                                                  controller
                                                      .salesItemList[index]
                                                      .productPrice;
                                              int profit = (controller
                                                          .salesItemList[index]
                                                          .productPrice -
                                                      controller
                                                          .salesItemList[index]
                                                          .productCost) *
                                                  controller
                                                      .salesItemList[index]
                                                      .quantity;
                                              // Reassign the modified item to trigger a UI update
                                              controller.salesItemList[index] =
                                                  SalesItemModel(
                                                productName: controller
                                                    .salesItemList[index]
                                                    .productName,
                                                productCost: controller
                                                    .salesItemList[index]
                                                    .productCost,
                                                productPrice: controller
                                                    .salesItemList[index]
                                                    .productPrice,
                                                unit: controller
                                                    .salesItemList[index].unit,
                                                subTotal: newSubTotal,
                                                quantity: controller
                                                    .salesItemList[index]
                                                    .quantity,
                                                oldQuantity: controller
                                                            .salesItemList[
                                                                index]
                                                            .oldQuantity ==
                                                        -1
                                                    ? controller
                                                        .salesItemList[index]
                                                        .quantity
                                                    : controller
                                                        .salesItemList[index]
                                                        .oldQuantity,
                                                profit: profit,
                                                productId: controller
                                                    .salesItemList[index]
                                                    .productId,
                                                stock: controller
                                                    .salesItemList[index].stock,
                                              );
                                            }
                                            controller.calculateGrandTotal();
                                          },
                                          child: const Text("-")),
                                      SizedBox(
                                        width: 30,
                                        child: Text(controller
                                            .salesItemList[index].quantity
                                            .toString()),
                                        // child: TextField(
                                        //   keyboardType:
                                        //       TextInputType.number,
                                        //   onChanged: (value) {
                                        //     controller
                                        //             .salesItemList[index]
                                        //             .quantity =
                                        //         int.parse(value);
                                        //     int newSubTotal = controller
                                        //             .salesItemList[index]
                                        //             .quantity *
                                        //         controller
                                        //             .salesItemList[index]
                                        //             .productPrice;

                                        //     int profit = (controller
                                        //                 .salesItemList[
                                        //                     index]
                                        //                 .productPrice -
                                        //             controller
                                        //                 .salesItemList[
                                        //                     index]
                                        //                 .productCost) *
                                        //         controller
                                        //             .salesItemList[index]
                                        //             .quantity;
                                        //     // Reassign the modified item to trigger a UI update
                                        //     controller.salesItemList[
                                        //         index] = SalesItemModel(
                                        //       productName: controller
                                        //           .salesItemList[index]
                                        //           .productName,
                                        //       productCost: controller
                                        //           .salesItemList[index]
                                        //           .productCost,
                                        //       productPrice: controller
                                        //           .salesItemList[index]
                                        //           .productPrice,
                                        //       unit: controller
                                        //           .salesItemList[index]
                                        //           .unit,
                                        //       subTotal: newSubTotal,
                                        //       quantity: controller
                                        //           .salesItemList[index]
                                        //           .quantity,
                                        //       profit: profit,
                                        //       productId: controller
                                        //           .salesItemList[index]
                                        //           .productId,
                                        //       stock: controller
                                        //           .salesItemList[index]
                                        //           .stock,
                                        //     );

                                        //     controller
                                        //         .calculateGrandTotal();
                                        //   },
                                        //   controller:
                                        //       TextEditingController(
                                        //           text: controller
                                        //               .salesItemList[
                                        //                   index]
                                        //               .quantity
                                        //               .toString()),
                                        //   decoration:
                                        //       const InputDecoration(
                                        //           border:
                                        //               InputBorder.none),
                                        // ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            //print("stockk $stock");
                                            // print(controller
                                            //     .salesItemList[index]
                                            //     .oldQuantity);
                                            // Update the quantity of the specific item
                                            if (controller.salesItemList[index]
                                                    .quantity >=
                                                stockLimit) return;
                                            controller.salesItemList[index]
                                                .quantity++;

                                            int newSubTotal = controller
                                                    .salesItemList[index]
                                                    .quantity *
                                                controller.salesItemList[index]
                                                    .productPrice;

                                            int profit = (controller
                                                        .salesItemList[index]
                                                        .productPrice -
                                                    controller
                                                        .salesItemList[index]
                                                        .productCost) *
                                                controller.salesItemList[index]
                                                    .quantity;

                                            // Reassign the modified item to trigger a UI update
                                            controller.salesItemList[
                                                    index] =
                                                SalesItemModel(
                                                    productName: controller
                                                        .salesItemList[index]
                                                        .productName,
                                                    productCost: controller
                                                        .salesItemList[index]
                                                        .productCost,
                                                    productPrice: controller
                                                        .salesItemList[index]
                                                        .productPrice,
                                                    unit: controller
                                                        .salesItemList[index]
                                                        .unit,
                                                    subTotal: newSubTotal,
                                                    quantity: controller
                                                        .salesItemList[index]
                                                        .quantity,
                                                    oldQuantity: controller
                                                                .salesItemList[
                                                                    index]
                                                                .oldQuantity ==
                                                            -1
                                                        ? controller
                                                            .salesItemList[
                                                                index]
                                                            .quantity
                                                        : controller
                                                            .salesItemList[
                                                                index]
                                                            .oldQuantity,
                                                    profit: profit,
                                                    productId: controller
                                                        .salesItemList[index]
                                                        .productId,
                                                    stock: controller
                                                        .salesItemList[index]
                                                        .stock);
                                            controller.calculateGrandTotal();
                                          },
                                          child: const Text("+"))
                                    ],
                                  )),
                                  DataCell(Text(controller
                                      .salesItemList[index].productCost
                                      .toString())),
                                  DataCell(Text(controller
                                      .salesItemList[index].productPrice
                                      .toString())),
                                  DataCell(Text(controller
                                      .salesItemList[index].subTotal
                                      .toString())),
                                  DataCell(IconButton(
                                      onPressed: () {
                                        controller.salesItemList
                                            .removeAt(index);
                                        controller.calculateGrandTotal();
                                      },
                                      icon: const Icon(Icons.delete)))
                                ]);
                              })));
                    })
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
                              Text("Order Tax"),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Discount"),
                              SizedBox(
                                height: 8,
                              ),
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
                                Text(controller.taxValue.toString()),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(controller.discountValue.value.toString()),
                                const SizedBox(
                                  height: 8,
                                ),
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
                        const Text("Order Tax:"),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            // var taxPercent =
                            //     controller.taxController.text.isEmpty
                            //         ? 0
                            //         : int.parse(controller.taxController.text);
                            controller.calculateGrandTotal();
                          },
                          //readOnly: true,
                          controller: controller.taxController,
                          decoration: const InputDecoration(
                              hintText: "Tax Percent (%)",
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
                        const Text("Discount:"),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            controller.discountValue.value = controller
                                    .discountController.text.isEmpty
                                ? 0
                                : int.parse(controller.discountController.text);
                            controller.calculateGrandTotal();
                          },
                          //readOnly: true,
                          controller: controller.discountController,
                          decoration: const InputDecoration(
                              hintText: "Discount Amount",
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
                )
              ]),
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
                            ),
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
                      minLines: 2,
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
