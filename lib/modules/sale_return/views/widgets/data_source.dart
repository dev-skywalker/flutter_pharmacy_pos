import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';
import '../../model/sale_return_model.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class SaleReturnDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  SaleReturnDataSourceAsync() {
    print('SaleReturnDataSourceAsync created');
  }

  SaleReturnDataSourceAsync.empty() {
    _empty = true;
    print('SaleReturnDataSourceAsync.empty created');
  }

  SaleReturnDataSourceAsync.error() {
    _errorCounter = 0;
    print('SaleReturnDataSourceAsync.error created');
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

  final SaleReturnWebService _repo = SaleReturnWebService();

  // int? get delete => _delete;
  Future<void> deleteSaleReturn(int? id) async {
    await _repo.deleteSaleReturn(id!);
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
            () => SaleReturnWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((salereturn) {
          //var nameList = salereturn.name?.split(",") ?? ["product name"];
          DateTime date = DateTime.fromMillisecondsSinceEpoch(salereturn.date!);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(salereturn.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(salereturn.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(salereturn.id!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(salereturn.id.toString())),
              DataCell(
                Text(dateFormat.format(date)),
              ),
              DataCell(Text(salereturn.warehouse?.name ?? "")),
              DataCell(Text(salereturn.customer?.name ?? "")),
              DataCell(Text(salereturn.amount.toString())),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(
                            "${Routes.app}${Routes.saleReturn}/details/${salereturn.id}");
                      },
                      icon: const Icon(
                        Icons.content_paste,
                        color: Colors.teal,
                      )),
                  // IconButton(
                  //     onPressed: () {
                  //       Get.toNamed(
                  //           "${Routes.app}${Routes.salereturn}${Routes.update}/${salereturn.id}",
                  //           arguments: salereturn);
                  //     },
                  //     icon: const Icon(Icons.edit)),
                  // IconButton(
                  //     onPressed: () {
                  //       deleteSaleReturn(salereturn.id);
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

class SaleReturnWebServiceResponse {
  SaleReturnWebServiceResponse(
      {required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<SaleReturnModel> data;
}

class SaleReturnWebService extends BaseApiService {
  Future<SaleReturnWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/sale_return', params: params);

    if (response != null && response.statusCode == 200) {
      List<SaleReturnModel> salereturnList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        salereturnList.add(SaleReturnModel(
          id: v['id'],
          date: v['date'],
          note: v['note'],
          status: v['status'],
          amount: v['amount'],
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
        ));
      }
      return SaleReturnWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: salereturnList);
    } else {
      return SaleReturnWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteSaleReturn(int id) async {
    final response = await deleteRequest('/salereturn', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
