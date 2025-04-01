import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../model/stock_model.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class StocksDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  StocksDataSourceAsync() {
    print('StocksDataSourceAsync created');
  }

  StocksDataSourceAsync.empty() {
    _empty = true;
    print('StocksDataSourceAsync.empty created');
  }

  StocksDataSourceAsync.error() {
    _errorCounter = 0;
    print('StocksDataSourceAsync.error created');
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

  final StocksWebService _repo = StocksWebService();

  // int? get delete => _delete;
  Future<void> deleteStocks(int? id) async {
    await _repo.deleteStocks(id!);
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
            () => StocksWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(startIndex, count, filter, _sortColumn,
            _sortAscending, warehouseId);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((stocks) {
          DateTime date =
              DateTime.fromMillisecondsSinceEpoch(stocks.expireDate!);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(stocks.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(stocks.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(stocks.productId!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(stocks.productId.toString())),
              DataCell(
                Text(stocks.productName!.split(',')[0]),
              ),
              DataCell(Text(stocks.warehouseStock.toString())),
              DataCell(Text(stocks.unit!)),
              DataCell(Text(stocks.productCost.toString())),
              DataCell(Text(stocks.productPrice.toString())),
              DataCell(Text(dateFormat.format(date))),
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

class StocksWebServiceResponse {
  StocksWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<StockModel> data;
}

class StocksWebService extends BaseApiService {
  Future<StocksWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc, int? warehouseId) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc",
    };
    if (warehouseId != null) {
      params.addAll({"warehouseId": warehouseId});
    }

    final response = await getRequest('/products/stock', params: params);

    if (response != null && response.statusCode == 200) {
      List<StockModel> stocksList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        stocksList.add(StockModel(
          productId: v['productId'],
          productName: v['productName'],
          warehouseStock: v['warehouseStock'],
          unit: v['unit'],
          productCost: v['productCost'],
          productPrice: v['productPrice'],
          expireDate: v['expireDate'],
        ));
      }
      return StocksWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: stocksList);
    } else {
      return StocksWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteStocks(int id) async {
    final response = await deleteRequest('/stocks', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
