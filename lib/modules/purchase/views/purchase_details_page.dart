import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../routes/routes.dart';
import '../controllers/purchase_controller.dart';
import '../model/purchase_details_model.dart';

class PurchaseDetailsPage extends GetView<PurchaseController> {
  const PurchaseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getPurchaseDetails(int.parse(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Details"),
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.purchases}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Obx(() {
          if (controller.purchaseResponse.value == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildPurchaseDetails();
          }
        }),
      ),
    );
  }

  Widget _buildPurchaseDetails() {
    var purchase = controller.purchaseResponse.value!;
    var dateFormat = DateFormat('dd/MM/yyyy');
    DateTime date = DateTime.fromMillisecondsSinceEpoch(purchase.date!);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveGridRow(
            children: [
              // ResponsiveGridCol(
              //   sm: 12,
              //   md: 6,
              //   lg: 4,
              //   child: Text("Purchase Date: ${dateFormat.format(date)}",
              //       style: const TextStyle(
              //           fontSize: 18, fontWeight: FontWeight.bold)),
              // ),
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("Purchase Info", [
                  _buildDetailRow("Purchase Id", purchase.id.toString()),
                  _buildDetailRow("Purchase Date", dateFormat.format(date)),
                  _buildDetailRow("Refer Code", purchase.refCode.toString()),
                  _buildDetailRow(
                      "Status", purchase.status! == 0 ? "Received" : "Pending"),
                  // _buildDetailRow(
                  //     "Email", purchase.supplier?.supplierEmail ?? ""),
                  // _buildDetailRow(
                  //     "Address", purchase.supplier?.supplierAddress ?? ""),
                ]),
              ),
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("Supplier Info", [
                  _buildDetailRow("Name", purchase.supplier?.name ?? ""),
                  _buildDetailRow("Phone", purchase.supplier?.phone ?? ""),
                  _buildDetailRow("Email", purchase.supplier?.email ?? ""),
                  _buildDetailRow("Address",
                      "${purchase.supplier?.address} ${purchase.supplier?.city}"),
                ]),
              ),
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("Warehouse Info", [
                  _buildDetailRow("Name", purchase.warehouse?.name ?? ""),
                  _buildDetailRow("Phone", purchase.warehouse?.phone ?? ""),
                  _buildDetailRow("Email", purchase.warehouse?.email ?? ""),
                  _buildDetailRow("Address",
                      "${purchase.warehouse?.address} ${purchase.warehouse?.city}"),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Purchase Items",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildPurchaseItemsTable(purchase.purchaseItems),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Payment Status: ${purchase.paymentStatus == 0 ? "Paid" : "Unpaid"}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 10),
                  Text("Payment Type: ${purchase.paymentType?.name ?? ""}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 10),
                  Text("Note: ${purchase.note ?? ""}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Shipping: ${purchase.shipping}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text("Sub Total: ${purchase.amount}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text("Total: ${purchase.shipping! + purchase.amount!}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPurchaseItemsTable(List<PurchaseItem> items) {
    //print(controller.purchaseItemList.length);
    controller.tableHeight =
        ((controller.purchaseResponse.value!.purchaseItems.length + 1) * 50);
    return SizedBox(
      height: controller.tableHeight + 50,
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        columns: const [
          DataColumn2(label: Text('NO'), size: ColumnSize.S),
          DataColumn2(label: Text('PRODUCT'), size: ColumnSize.L),
          DataColumn2(
              label: Text('PRODUCT ID'), size: ColumnSize.S, numeric: true),
          DataColumn2(
              label: Text('QUANTITY'), size: ColumnSize.M, numeric: true),
          DataColumn2(
              label: Text('Unit Cost'), size: ColumnSize.S, numeric: true),
          // DataColumn2(
          //     label: Text('Unit Price'), size: ColumnSize.S, numeric: true),
          DataColumn2(
              label: Text('Subtotal'), size: ColumnSize.S, numeric: true),
        ],
        rows: List<DataRow>.generate(
          items.length,
          (index) => DataRow(cells: [
            DataCell(Text("${index + 1}")),
            DataCell(Text(items[index].productName?.split(',')[0] ?? "")),
            DataCell(Text("${items[index].productId}")),
            DataCell(Text("${items[index].quantity}")),
            DataCell(Text("${items[index].productCost}")),
            // DataCell(Text("${items[index].productPrice}")),
            DataCell(Text("${items[index].itemSubTotal}")),
          ]),
        ),
      ),
    );
  }
}
