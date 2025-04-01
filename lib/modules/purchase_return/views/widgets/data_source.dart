import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';
import '../../model/purchase_return_model.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class PurchaseReturnDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  PurchaseReturnDataSourceAsync() {
    print('PurchaseReturnDataSourceAsync created');
  }

  PurchaseReturnDataSourceAsync.empty() {
    _empty = true;
    print('PurchaseReturnDataSourceAsync.empty created');
  }

  PurchaseReturnDataSourceAsync.error() {
    _errorCounter = 0;
    print('PurchaseReturnDataSourceAsync.error created');
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

  final PurchaseReturnWebService _repo = PurchaseReturnWebService();

  // int? get delete => _delete;
  Future<void> deletePurchaseReturn(int? id) async {
    await _repo.deletePurchaseReturn(id!);
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
            () => PurchaseReturnWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((purchasereturn) {
          //var nameList = purchasereturn.name?.split(",") ?? ["product name"];
          DateTime date =
              DateTime.fromMillisecondsSinceEpoch(purchasereturn.date!);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(purchasereturn.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(purchasereturn.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(purchasereturn.id!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(purchasereturn.id.toString())),
              DataCell(
                Text(dateFormat.format(date)),
              ),
              DataCell(Text(purchasereturn.warehouse?.name ?? "")),
              DataCell(Text(purchasereturn.supplier?.name ?? "")),
              DataCell(Text(purchasereturn.amount.toString())),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(
                            "${Routes.app}${Routes.purchaseReturn}/details/${purchasereturn.id}");
                      },
                      icon: const Icon(
                        Icons.content_paste,
                        color: Colors.teal,
                      )),
                  // IconButton(
                  //     onPressed: () {
                  //       Get.toNamed(
                  //           "${Routes.app}${Routes.purchasereturn}${Routes.update}/${purchasereturn.id}",
                  //           arguments: purchasereturn);
                  //     },
                  //     icon: const Icon(Icons.edit)),
                  // IconButton(
                  //     onPressed: () {
                  //       deletePurchaseReturn(purchasereturn.id);
                  //     },
                  //     icon: const Icon(Icons.delete))
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

class PurchaseReturnWebServiceResponse {
  PurchaseReturnWebServiceResponse(
      {required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<PurchaseReturnModel> data;
}

class PurchaseReturnWebService extends BaseApiService {
  Future<PurchaseReturnWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/purchase_return', params: params);

    if (response != null && response.statusCode == 200) {
      List<PurchaseReturnModel> purchasereturnList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        purchasereturnList.add(PurchaseReturnModel(
          id: v['id'],
          date: v['date'],
          note: v['note'],
          status: v['status'],
          amount: v['amount'],
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
        ));
      }
      return PurchaseReturnWebServiceResponse(
          totalRecords: response.data['totalRecords'],
          data: purchasereturnList);
    } else {
      return PurchaseReturnWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deletePurchaseReturn(int id) async {
    final response = await deleteRequest('/purchasereturn', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
