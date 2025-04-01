import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../model/stock_alert_model.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class StockAlertDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  StockAlertDataSourceAsync() {
    print('StockAlertDataSourceAsync created');
  }

  StockAlertDataSourceAsync.empty() {
    _empty = true;
    print('StockAlertDataSourceAsync.empty created');
  }

  StockAlertDataSourceAsync.error() {
    _errorCounter = 0;
    print('StockAlertDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String? filter;
  int? warehouseId;

  int totalRecords = 0;

  // String? get filter => _filter;
  // int? get warehouseId => _warehouseId;

  void filters(String? search, int? id) {
    filter = search;
    warehouseId = id;
    refreshDatasource();
  }

  final StockAlertWebService _repo = StockAlertWebService();

  // int? get delete => _delete;
  Future<void> deleteStockAlert(int? id) async {
    await _repo.deleteStockAlert(id!);
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
            () => StockAlertWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(startIndex, count, filter, _sortColumn,
            _sortAscending, warehouseId);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((stockalert) {
          // DateTime date =
          //     DateTime.fromMillisecondsSinceEpoch(stockalert.expireDate!);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(stockalert.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(stockalert.updatedAt!);
          //var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            //key: ValueKey<int>(stockalert.productId! + stockalert.warehouseId!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(stockalert.productId.toString())),
              DataCell(
                Text(stockalert.productName!.split(',')[0]),
              ),
              DataCell(Text(stockalert.quantity.toString())),
              DataCell(Text(stockalert.alertLevel.toString())),
              DataCell(Text(stockalert.unitName.toString())),
              DataCell(Text(stockalert.productCost.toString())),
              DataCell(Text(stockalert.productPrice.toString())),
              DataCell(Text(stockalert.warehouseName.toString())),
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

class StockAlertWebServiceResponse {
  StockAlertWebServiceResponse(
      {required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<StockAlertModel> data;
}

class StockAlertWebService extends BaseApiService {
  Future<StockAlertWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc, int? warehouseId) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc",
    };
    //print("Warehouse is $warehouseId");
    if (warehouseId != null && warehouseId != -1) {
      //print("work");
      params.addAll({"warehouseId": warehouseId});
    }

    final response = await getRequest('/reports/alerts', params: params);

    if (response != null && response.statusCode == 200) {
      List<StockAlertModel> stockalertList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        stockalertList.add(StockAlertModel(
          productId: v['productId'],
          productName: v['productName'],
          productCost: v['productCost'],
          productPrice: v['productPrice'],
          unitName: v['unitName'],
          quantity: v['quantity'],
          alertLevel: v['alertLevel'],
          warehouseName: v['warehouseName'],
          warehouseId: v['warehouseId'],
        ));
      }
      print(stockalertList.length);
      return StockAlertWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: stockalertList);
    } else {
      return StockAlertWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteStockAlert(int id) async {
    final response = await deleteRequest('/stockalert', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
