import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../routes/routes.dart';
import '../controllers/transfer_controller.dart';
import '../model/transfer_details_model.dart';

class TransferDetailsPage extends GetView<TransferController> {
  const TransferDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getTransfer(int.parse(id));

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Transfer Details"),
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.transfer}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Obx(() {
          if (controller.transferResponse.value == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildTransferDetails();
          }
        }),
      ),
    );
  }

  Widget _buildTransferDetails() {
    var transfer = controller.transferResponse.value!;
    var dateFormat = DateFormat('dd/MM/yyyy');
    DateTime date = DateTime.fromMillisecondsSinceEpoch(transfer.transferDate!);

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
                child: _buildDetailCard("Transfer Info", [
                  _buildDetailRow(
                      "Transfer Id", transfer.transferId.toString()),
                  _buildDetailRow("Transfer Date", dateFormat.format(date)),
                  _buildDetailRow("Status", transfer.transferStatus.toString()),
                  _buildDetailRow("Note", transfer.note ?? ""),
                ]),
              ),
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("From Warehouse Info", [
                  _buildDetailRow("Name", transfer.fromWarehouse?.name ?? ""),
                  _buildDetailRow("Phone", transfer.fromWarehouse?.phone ?? ""),
                  _buildDetailRow("Email", transfer.fromWarehouse?.email ?? ""),
                  _buildDetailRow("Address",
                      "${transfer.fromWarehouse?.address} ${transfer.fromWarehouse?.city}"),
                ]),
              ),
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("To Warehouse Info", [
                  _buildDetailRow("Name", transfer.toWarehouse?.name ?? ""),
                  _buildDetailRow("Phone", transfer.toWarehouse?.phone ?? ""),
                  _buildDetailRow("Email", transfer.toWarehouse?.email ?? ""),
                  _buildDetailRow("Address",
                      "${transfer.toWarehouse?.address} ${transfer.toWarehouse?.city}"),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Transfer Items",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildTransferItemsTable(transfer.transferItems),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Shipping: ${transfer.transferShipping}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text("Sub Total: ${transfer.transferAmount}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text(
                      "Total: ${transfer.transferShipping! + transfer.transferAmount!}",
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

  Widget _buildTransferItemsTable(List<TransferItem> items) {
    controller.tableHeight =
        ((controller.transferResponse.value!.transferItems.length + 1) * 50);
    return SizedBox(
      height: controller.tableHeight,
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
              label: Text('Unit Price'), size: ColumnSize.S, numeric: true),
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
            DataCell(Text("${items[index].productPrice}")),
            DataCell(Text("${items[index].subTotal}")),
          ]),
        ),
      ),
    );
  }
}
