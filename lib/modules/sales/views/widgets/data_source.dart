import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/sales/model/sales_model.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class SalesDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  SalesDataSourceAsync() {
    print('SalesDataSourceAsync created');
  }

  SalesDataSourceAsync.empty() {
    _empty = true;
    print('SalesDataSourceAsync.empty created');
  }

  SalesDataSourceAsync.error() {
    _errorCounter = 0;
    print('SalesDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String? _filter;

  int totalRecords = 0;

  String? get filter => _filter;
  set filter(String? search) {
    _filter = search;
    refreshDatasource();
    //notifyListeners();
  }

  final SalesWebService _repo = SalesWebService();

  // int? get delete => _delete;
  Future<void> deleteSales(int? id) async {
    await _repo.deleteSales(id!);
    refreshDatasource();
    //notifyListeners();
  }

  String _sortColumn = "id";
  bool _sortAscending = false;

  void sort(String columnName, bool ascending) {
    _sortColumn = columnName;
    _sortAscending = ascending;
    refreshDatasource();
  }

  Future<int> getTotalRecords() {
    return Future<int>.delayed(
        const Duration(milliseconds: 0), () => totalRecords);
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    // print('getRows($startIndex, $count)');
    if (_errorCounter != null) {
      _errorCounter = _errorCounter! + 1;

      if (_errorCounter! % 2 == 1) {
        await Future.delayed(const Duration(milliseconds: 1000));
        throw 'Error #${((_errorCounter! - 1) / 2).round() + 1} has occured';
      }
    }

    // final format = NumberFormat.decimalPercentPattern(
    //   locale: 'en',
    //   decimalDigits: 0,
    // );
    assert(startIndex >= 0);

    // List returned will be empty is there're fewer items than startingAt
    var x = _empty
        ? await Future.delayed(const Duration(milliseconds: 2000),
            () => SalesWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((sales) {
          //var nameList = sales.name?.split(",") ?? ["product name"];
          DateTime date = DateTime.fromMillisecondsSinceEpoch(sales.date!);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(sales.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(sales.updatedAt!);
          // double taxAmount =
          //     (sales.amount! - sales.discount!) * (sales.taxPercent! / 100);

          // Calculate grand total
          // int saleAmount = sales.amount! +
          //     sales.shipping! -
          //     sales.discount! +
          //     sales.taxAmount!;

          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(sales.id!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(sales.id.toString())),
              DataCell(
                Text(dateFormat.format(date)),
              ),
              DataCell(Text(sales.warehouse?.name ?? "")),
              DataCell(Text(sales.customer?.name ?? "")),
              DataCell(Text(sales.totalAmount.toString())),
              DataCell(Text(sales.status == 0 ? "Received" : "Pending")),
              DataCell(Text(sales.paymentStatus == 0 ? "Paid" : "Unpaid")),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(
                            "${Routes.app}${Routes.sales}/return/${sales.id}");
                      },
                      tooltip: "Sale Return",
                      icon: const Icon(
                        Icons.settings_backup_restore,
                        color: Colors.blue,
                      )),
                  IconButton(
                      tooltip: "Update Sale",
                      onPressed: () {
                        //deleteProduct(product.id);
                        Get.toNamed(
                            "${Routes.app}${Routes.sales}${Routes.update}/${sales.id}");
                      },
                      icon: const Icon(
                        Icons.edit_square,
                        color: Colors.indigo,
                      )),
                  IconButton(
                      tooltip: "Sale Details",
                      onPressed: () {
                        //deleteProduct(product.id);

                        Get.toNamed(
                            "${Routes.app}${Routes.sales}/details/${sales.id}");
                      },
                      icon: const Icon(
                        Icons.content_paste,
                        color: Colors.teal,
                      )),
                ],
              )),
              // DataCell(Row(
              //   children: [
              //     PopupMenuButton<int>(
              //       itemBuilder: (context) => [
              //         PopupMenuItem(
              //           value: 1,
              //           onTap: () {
              //             Get.toNamed(
              //                 "${Routes.app}${Routes.sales}/details/${sales.id}");
              //           },
              //           child: const Text(
              //             "Sale Details",
              //             style: TextStyle(fontWeight: FontWeight.w700),
              //           ),
              //         ),
              //         PopupMenuItem(
              //           value: 2,
              //           onTap: () {
              //             Get.toNamed(
              //                 "${Routes.app}${Routes.sales}/return/${sales.id}");
              //           },
              //           child: const Text(
              //             "Create Sale Return",
              //             style: TextStyle(fontWeight: FontWeight.w700),
              //           ),
              //         ),
              //         PopupMenuItem(
              //           value: 3,
              //           onTap: () {
              //             Get.toNamed(
              //                 "${Routes.app}${Routes.sales}${Routes.update}/${sales.id}");
              //           },
              //           child: const Text(
              //             "Update Sale",
              //             style: TextStyle(fontWeight: FontWeight.w700),
              //           ),
              //         ),
              //         PopupMenuItem(
              //           value: 4,
              //           onTap: () {
              //             deleteSales(sales.id);
              //           },
              //           child: const Text(
              //             "Delete Sale",
              //             style: TextStyle(fontWeight: FontWeight.w700),
              //           ),
              //         ),
              //       ],
              //       icon: const Icon(Icons.library_add),
              //       offset: const Offset(0, 40),
              //     ),

              //   ],
              // )),
            ],
          );
        }).toList());

    return r;
  }

  @override
  void dispose() {
    _disposed = true; // Mark as disposed
    super.dispose();
  }
}

class SalesWebServiceResponse {
  SalesWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<SalesModel> data;
}

class SalesWebService extends BaseApiService {
  Future<SalesWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/sales', params: params);

    if (response != null && response.statusCode == 200) {
      List<SalesModel> salesList = [];
      // print(salesList.length);
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        salesList.add(SalesModel(
          id: v['id'],
          date: v['date'],
          note: v['note'],
          status: v['status'],
          amount: v['amount'],
          shipping: v['shipping'],
          warehouse: Customer(
              id: v['warehouse']['id'],
              name: v['warehouse']['name'],
              phone: v['warehouse']['phone'],
              email: v['warehouse']['email'],
              city: v['warehouse']['city'],
              address: v['warehouse']['address']),
          customer: Customer(
              id: v['customer']['id'],
              name: v['customer']['name'],
              phone: v['customer']['phone'],
              email: v['customer']['email'],
              city: v['customer']['city'],
              address: v['customer']['address']),
          createdAt: v['createdAt'],
          updatedAt: v['updatedAt'],
          discount: v['discount'],
          taxPercent: v['taxPercent'],
          taxAmount: v["taxAmount"],
          totalAmount: v["totalAmount"],
          paymentStatus: v['paymentStatus'],
        ));
      }
      return SalesWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: salesList);
    } else {
      return SalesWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteSales(int id) async {
    final response = await deleteRequest('/sales', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
