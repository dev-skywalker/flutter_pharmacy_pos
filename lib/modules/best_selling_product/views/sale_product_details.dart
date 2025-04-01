import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../routes/routes.dart';
import '../../sales/model/sale_details_model.dart';
import '../controllers/best_selling_product_controller.dart';

class SaleProductDetailsPage extends GetView<SaleProductController> {
  const SaleProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters['id'] ?? '';
    controller.getSales(int.parse(id), false, false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Sales Details"),
        leading: IconButton(
          onPressed: () {
            Get.rootController.rootDelegate.canBack
                ? Get.back()
                : Get.offAllNamed('${Routes.app}${Routes.sales}');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Obx(() {
          if (controller.salesResponse.value == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildSaleDetails();
          }
        }),
      ),
    );
  }

  Widget _buildSaleDetails() {
    var sale = controller.salesResponse.value!;
    var dateFormat = DateFormat('dd/MM/yyyy');
    DateTime date = DateTime.fromMillisecondsSinceEpoch(sale.date!);
    // double taxPercent =
    //     (sale.taxPercent! / (sale.amount! - sale.discount!)) * 100;
    // double taxAmount =
    //     (sale.amount! - sale.discount!) * (sale.taxPercent! / 100);
    //taxValue.value = taxAmount.round();
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
                child: _buildDetailCard("Sale Info", [
                  _buildDetailRow("Sale Id", sale.id.toString()),
                  _buildDetailRow("Sale Date", dateFormat.format(date)),
                  _buildDetailRow("Status", sale.status.toString()),
                  _buildDetailRow("Note", sale.note ?? ""),
                ]),
              ),
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("Customer Info", [
                  _buildDetailRow("Name", sale.customer?.name ?? ""),
                  _buildDetailRow("Phone", sale.customer?.phone ?? ""),
                  _buildDetailRow("Email", sale.customer?.email ?? ""),
                  _buildDetailRow("Address",
                      "${sale.customer?.address} ${sale.customer?.city}"),
                ]),
              ),
              ResponsiveGridCol(
                sm: 12,
                md: 6,
                lg: 4,
                child: _buildDetailCard("Warehouse Info", [
                  _buildDetailRow("Name", sale.warehouse?.name ?? ""),
                  _buildDetailRow("Phone", sale.warehouse?.phone ?? ""),
                  _buildDetailRow("Email", sale.warehouse?.email ?? ""),
                  _buildDetailRow("Address",
                      "${sale.warehouse?.address} ${sale.warehouse?.city}"),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Sale Items",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildSaleItemsTable(sale.saleItems),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Order Tax: ${sale.taxAmount}(${sale.taxPercent}%)",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text("Discount: ${sale.discount}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text("Shipping: ${sale.shipping}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text("Sub Total: ${sale.amount}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text("Total: ${sale.totalAmount}",
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

  Widget _buildSaleItemsTable(List<SaleItem> items) {
    return SizedBox(
      height: 220,
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
          DataColumn2(label: Text('Profit'), size: ColumnSize.S, numeric: true),
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
            DataCell(Text("${items[index].profit}")),
            DataCell(Text("${items[index].subTotal}")),
          ]),
        ),
      ),
    );
  }
}
