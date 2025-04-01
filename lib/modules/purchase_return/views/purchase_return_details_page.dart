import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../routes/routes.dart';
import '../controllers/purchase_return_controller.dart';
import '../model/purchase_return_details_model.dart';

class PurchaseReturnDetailsPage extends GetView<PurchaseReturnController> {
  const PurchaseReturnDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getPurchaseReturn(int.parse(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Return Details"),
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.purchaseReturn}');
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
            return _buildPurchaseReturnDetails();
          }
        }),
      ),
    );
  }

  Widget _buildPurchaseReturnDetails() {
    var purchaseReturn = controller.purchaseResponse.value!;
    var dateFormat = DateFormat('dd/MM/yyyy');
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(purchaseReturn.purchaseReturnDate!);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveGridRow(
            children: [
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("Return Info", [
                  _buildDetailRow(
                      "Return ID", purchaseReturn.purchaseReturn.toString()),
                  _buildDetailRow("Return Date", dateFormat.format(date)),
                  _buildDetailRow("Return Amount",
                      purchaseReturn.purchaseReturnReturnAmount.toString()),
                  _buildDetailRow("Return Note",
                      purchaseReturn.purchaseReturnReturnNote ?? "N/A"),
                ]),
              ),
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("Supplier Info", [
                  _buildDetailRow(
                      "Name", purchaseReturn.supplier?.supplierName ?? ""),
                  _buildDetailRow(
                      "Phone", purchaseReturn.supplier?.supplierPhone ?? ""),
                  _buildDetailRow(
                      "Email", purchaseReturn.supplier?.supplierEmail ?? ""),
                  _buildDetailRow("Address",
                      "${purchaseReturn.supplier?.supplierAddress} ${purchaseReturn.supplier?.supplierCity}"),
                ]),
              ),
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("Warehouse Info", [
                  _buildDetailRow(
                      "Name", purchaseReturn.warehouse?.warehouseName ?? ""),
                  _buildDetailRow(
                      "Phone", purchaseReturn.warehouse?.warehousePhone ?? ""),
                  _buildDetailRow(
                      "Email", purchaseReturn.warehouse?.warehouseEmail ?? ""),
                  _buildDetailRow("Address",
                      "${purchaseReturn.warehouse?.warehouseAddress} ${purchaseReturn.warehouse?.warehouseCity}"),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Return Items",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildReturnItemsTable(purchaseReturn.purchaseReturnItems),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      "Total Return Amount: ${purchaseReturn.purchaseReturnReturnAmount}",
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

  Widget _buildReturnItemsTable(List<PurchaseReturnItem> items) {
    controller.tableHeight =
        ((controller.purchaseResponse.value!.purchaseReturnItems.length + 1) *
            50);
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
            DataCell(Text("${items[index].subTotal}")),
          ]),
        ),
      ),
    );
  }
}
