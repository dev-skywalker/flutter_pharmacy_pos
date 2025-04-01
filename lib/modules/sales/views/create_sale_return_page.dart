import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/customer/model/customer_model.dart';
import 'package:pharmacy_pos/modules/warehouse/model/warehouse_model.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../routes/routes.dart';
import '../controllers/sales_controller.dart';

class CreateSaleReturnPage extends GetView<SalesController> {
  const CreateSaleReturnPage({super.key});
  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getSales(int.parse(id), true);
    bool isSmallScreen = MediaQuery.of(context).size.width >= 980;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Create New SaleReturn"),
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
                  controller.createSalesFormKey.currentState!.validate();
              if (isValidate) {
                controller.createSalesReturnWithItem(int.parse(id));
              }
              //print(controller.salereturnDate.toIso8601String());
            },
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _createSaleReturnWidget(context, isSmallScreen),
    );
  }

  Widget _createSaleReturnWidget(BuildContext context, bool isSmallScreen) {
    var date = DateFormat('dd/MM/yyyy').format(controller.salesDate);
    controller.dateController.text = date;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          key: controller.createSalesFormKey,
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
                              enabled: controller.salesItemList.isEmpty,
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
                                // DataColumn2(
                                //     label: Text('Unit Cost'),
                                //     size: ColumnSize.S,
                                //     numeric: true),
                                DataColumn2(
                                    label: Text('Unit Price'),
                                    size: ColumnSize.S,
                                    numeric: true),
                                DataColumn2(
                                  size: ColumnSize.S,
                                  label: Text('Subtotal'),
                                  numeric: true,
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                  controller.salesItemList.length,
                                  (index) => DataRow(cells: [
                                        DataCell(Text("${index + 1}")),
                                        DataCell(Text(controller
                                            .salesItemList[index].productName
                                            .split(',')[0])),
                                        DataCell(Text(
                                            "${controller.salesItemList[index].stock} ${controller.salesItemList[index].unit}")),
                                        DataCell(Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  if (controller
                                                          .salesItemList[index]
                                                          .quantity >
                                                      1) {
                                                    // Update the quantity of the specific item
                                                    controller
                                                        .salesItemList[index]
                                                        .quantity--;

                                                    int newSubTotal = controller
                                                            .salesItemList[
                                                                index]
                                                            .quantity *
                                                        controller
                                                            .salesItemList[
                                                                index]
                                                            .productPrice;
                                                    int profit = (controller
                                                                .salesItemList[
                                                                    index]
                                                                .productPrice -
                                                            controller
                                                                .salesItemList[
                                                                    index]
                                                                .productCost) *
                                                        controller
                                                            .salesItemList[
                                                                index]
                                                            .quantity;
                                                    // Reassign the modified item to trigger a UI update
                                                    controller.salesItemList[
                                                        index] = SalesItemModel(
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
                                                          .salesItemList[index]
                                                          .oldQuantity,
                                                      profit: profit,
                                                      productId: controller
                                                          .salesItemList[index]
                                                          .productId,
                                                      stock: controller
                                                          .salesItemList[index]
                                                          .stock,
                                                    );
                                                  }
                                                  controller
                                                      .calculateGrandTotal();
                                                  // controller.sa
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
                                              //       oldQuantity: controller
                                              //           .salesItemList[index]
                                              //           .oldQuantity,
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
                                                  if (controller
                                                          .salesItemList[index]
                                                          .quantity >=
                                                      controller
                                                          .salesItemList[index]
                                                          .stock) return;
                                                  // Update the quantity of the specific item
                                                  controller
                                                      .salesItemList[index]
                                                      .quantity++;

                                                  int newSubTotal = controller
                                                          .salesItemList[index]
                                                          .quantity *
                                                      controller
                                                          .salesItemList[index]
                                                          .productPrice;

                                                  int profit = (controller
                                                              .salesItemList[
                                                                  index]
                                                              .productPrice -
                                                          controller
                                                              .salesItemList[
                                                                  index]
                                                              .productCost) *
                                                      controller
                                                          .salesItemList[index]
                                                          .quantity;

                                                  // Reassign the modified item to trigger a UI update
                                                  controller.salesItemList[
                                                          index] =
                                                      SalesItemModel(
                                                          productName: controller
                                                              .salesItemList[
                                                                  index]
                                                              .productName,
                                                          productCost: controller
                                                              .salesItemList[
                                                                  index]
                                                              .productCost,
                                                          productPrice:
                                                              controller
                                                                  .salesItemList[
                                                                      index]
                                                                  .productPrice,
                                                          unit: controller
                                                              .salesItemList[
                                                                  index]
                                                              .unit,
                                                          subTotal: newSubTotal,
                                                          quantity: controller
                                                              .salesItemList[
                                                                  index]
                                                              .quantity,
                                                          oldQuantity: controller
                                                              .salesItemList[
                                                                  index]
                                                              .oldQuantity,
                                                          profit: profit,
                                                          productId: controller
                                                              .salesItemList[
                                                                  index]
                                                              .productId,
                                                          stock: controller
                                                              .salesItemList[
                                                                  index]
                                                              .stock);
                                                  controller
                                                      .calculateGrandTotal();
                                                },
                                                child: const Text("+"))
                                          ],
                                        )),
                                        // DataCell(Text(controller
                                        //     .salesItemList[index].productCost
                                        //     .toString())),
                                        DataCell(Text(controller
                                            .salesItemList[index].productPrice
                                            .toString())),
                                        DataCell(Text(controller
                                            .salesItemList[index].subTotal
                                            .toString())),
                                      ]))));
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
                              Text("Grand Total"),
                            ],
                          ),
                          Obx(() {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
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
