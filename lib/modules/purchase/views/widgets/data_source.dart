import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/purchase/model/purchase_model.dart';
// import 'package:pharmacy_pos/modules/purchases/model/purchase_model.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class PurchaseDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  PurchaseDataSourceAsync() {
    print('PurchaseDataSourceAsync created');
  }

  PurchaseDataSourceAsync.empty() {
    _empty = true;
    print('PurchaseDataSourceAsync.empty created');
  }

  PurchaseDataSourceAsync.error() {
    _errorCounter = 0;
    print('PurchaseDataSourceAsync.error created');
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

  final PurchaseWebService _repo = PurchaseWebService();

  // int? get delete => _delete;
  Future<void> deletePurchase(int? id) async {
    await _repo.deletePurchase(id!);
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
            () => PurchaseWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((purchase) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(purchase.date!);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(purchase.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(purchase.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(purchase.id!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(purchase.id.toString())),
              DataCell(
                Text(dateFormat.format(date)),
              ),
              DataCell(Text(purchase.warehouse?.name ?? "")),
              DataCell(Text(purchase.supplier?.name ?? "")),
              DataCell(
                  Text((purchase.amount! + purchase.shipping!).toString())),
              DataCell(Text(purchase.status! == 0 ? "Received" : "Pending")),
              DataCell(Text(purchase.paymentStatus! == 0 ? "Paid" : "Unpaid")),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(
                            "${Routes.app}${Routes.purchases}/return/${purchase.id}");
                      },
                      tooltip: "Purchase Return",
                      icon: const Icon(
                        Icons.settings_backup_restore,
                        color: Colors.blue,
                      )),
                  IconButton(
                      tooltip: "Update Purchase",
                      onPressed: () {
                        //deleteProduct(product.id);
                        Get.toNamed(
                            "${Routes.app}${Routes.purchases}${Routes.update}/${purchase.id}",
                            arguments: purchase);
                      },
                      icon: const Icon(
                        Icons.edit_square,
                        color: Colors.indigo,
                      )),
                  IconButton(
                      tooltip: "Purchase Details",
                      onPressed: () {
                        //deleteProduct(product.id);

                        Get.toNamed(
                            "${Routes.app}${Routes.purchases}/details/${purchase.id}",
                            arguments: purchase);
                      },
                      icon: const Icon(
                        Icons.content_paste,
                        color: Colors.teal,
                      )),
                ],
              )),
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

class PurchaseWebServiceResponse {
  PurchaseWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<PurchaseModel> data;
}

class PurchaseWebService extends BaseApiService {
  Future<PurchaseWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/purchases', params: params);

    if (response != null && response.statusCode == 200) {
      List<PurchaseModel> purchaseList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        purchaseList.add(PurchaseModel(
          id: v['id'],
          date: v['date'],
          refCode: v['refCode'],
          note: v['note'],
          status: v['status'],
          amount: v['amount'],
          shipping: v['shipping'],
          warehouse: Supplier(
              id: v['warehouse']['id'],
              name: v['warehouse']['name'],
              phone: v['warehouse']['phone'],
              email: v['warehouse']['email'],
              city: v['warehouse']['city'],
              address: v['warehouse']['address']),
          supplier: Supplier(
              id: v['supplier']['id'],
              name: v['supplier']['name'],
              phone: v['supplier']['phone'],
              email: v['supplier']['email'],
              city: v['supplier']['city'],
              address: v['supplier']['address']),
          createdAt: v['createdAt'],
          updatedAt: v['updatedAt'],
          paymentStatus: v['paymentStatus'],
        ));
      }
      return PurchaseWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: purchaseList);
    } else {
      return PurchaseWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deletePurchase(int id) async {
    final response = await deleteRequest('/purchases', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
