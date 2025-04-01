import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/transfer/model/transfer_model.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class TransferDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  TransferDataSourceAsync() {
    print('TransferDataSourceAsync created');
  }

  TransferDataSourceAsync.empty() {
    _empty = true;
    print('TransferDataSourceAsync.empty created');
  }

  TransferDataSourceAsync.error() {
    _errorCounter = 0;
    print('TransferDataSourceAsync.error created');
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

  final TransferWebService _repo = TransferWebService();

  // int? get delete => _delete;
  Future<void> deleteTransfer(int? id) async {
    await _repo.deleteTransfer(id!);
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
            () => TransferWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((transfer) {
          //var nameList = transfer.name?.split(",") ?? ["product name"];
          DateTime date = DateTime.fromMillisecondsSinceEpoch(transfer.date!);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(transfer.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(transfer.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(transfer.id!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(transfer.id.toString())),
              DataCell(
                Text(dateFormat.format(date)),
              ),
              DataCell(Text(transfer.fromWarehouseName!)),
              DataCell(Text(transfer.toWarehouseName!)),
              DataCell(Text(transfer.amount.toString())),
              DataCell(Text(transfer.shipping.toString())),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(
                            "${Routes.app}${Routes.transfer}/details/${transfer.id}",
                            arguments: transfer);
                      },
                      icon: const Icon(
                        Icons.content_paste,
                        color: Colors.teal,
                      )),
                  // IconButton(
                  //     onPressed: () {
                  //       Get.toNamed(
                  //           "${Routes.app}${Routes.transfer}${Routes.update}/${transfer.id}",
                  //           arguments: transfer);
                  //     },
                  //     icon: const Icon(Icons.edit)),
                  // IconButton(
                  //     onPressed: () {
                  //       deleteTransfer(transfer.id);
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

class TransferWebServiceResponse {
  TransferWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<TransferModel> data;
}

class TransferWebService extends BaseApiService {
  Future<TransferWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/transfers', params: params);

    if (response != null && response.statusCode == 200) {
      List<TransferModel> transferList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        transferList.add(TransferModel(
          id: v['id'],
          date: v['date'],
          note: v['note'],
          status: v['status'],
          amount: v['amount'],
          shipping: v['shipping'],
          fromWarehouseName: v['fromWarehouseName'],
          toWarehouseName: v['toWarehouseName'],
          createdAt: v['createdAt'],
          updatedAt: v['updatedAt'],
        ));
      }
      return TransferWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: transferList);
    } else {
      return TransferWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteTransfer(int id) async {
    final response = await deleteRequest('/transfer', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
