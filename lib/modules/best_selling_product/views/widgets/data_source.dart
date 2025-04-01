import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../model/best_selling_product_model.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class BestSellingProductDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  BestSellingProductDataSourceAsync() {
    print('BestSellingsDataSourceAsync created');
  }

  BestSellingProductDataSourceAsync.empty() {
    _empty = true;
    print('BestSellingsDataSourceAsync.empty created');
  }

  BestSellingProductDataSourceAsync.error() {
    _errorCounter = 0;
    print('BestSellingsDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String? filter;
  int? warehouseId;
  int? _startDate;
  int? _endDate;

  int totalRecords = 0;

  //String? get filter => _filter;
  void filters(String? search, int? id, int? startDate, int? endDate) {
    filter = search;
    warehouseId = id;

    _startDate = startDate;
    _endDate = endDate;
    refreshDatasource();
    //notifyListeners();
  }

  // Future<Map<String, dynamic>> getBestSellingTotal(
  //     int? startDate, int? endDate, int? warehouseId) async {
  //   final now = DateTime.now();
  //   var sDate = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  //   var eDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
  //       .millisecondsSinceEpoch;
  //   print("GGG");
  //   return await _repo.getBestSellingTotal(
  //       startDate ?? sDate, endDate ?? eDate, warehouseId);
  //   //refreshDatasource();
  //   //notifyListeners();
  // }

  final BestSellingsWebService _repo = BestSellingsWebService();

  // int? get delete => _delete;
  Future<void> deleteBestSellings(int? id) async {
    await _repo.deleteBestSellings(id!);
    refreshDatasource();
    //notifyListeners();
  }

  String _sortColumn = "qty";
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
    final now = DateTime.now();
    var sDate = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    var eDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
        .millisecondsSinceEpoch;
    var x = _empty
        ? await Future.delayed(const Duration(milliseconds: 2000),
            () => BestSellingsWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex,
            count,
            filter,
            _sortColumn,
            _sortAscending,
            warehouseId,
            _startDate ?? sDate,
            _endDate ?? eDate);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((bestsellings) {
          //var nameList = bestsellings.name?.split(",") ?? ["product name"];
          //DateTime date = DateTime.fromMillisecondsSinceEpoch(bestsellings.date!);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(bestsellings.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(bestsellings.updatedAt!);
          // double taxAmount =
          //     (bestsellings.amount! - bestsellings.discount!) * (bestsellings.taxPercent! / 100);

          // Calculate grand total
          // int bestsellingAmount = bestsellings.amount! +
          //     bestsellings.shipping! -
          //     bestsellings.discount! +
          //     bestsellings.taxAmount!;

          //var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(bestsellings.productId!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(bestsellings.productId.toString())),
              // DataCell(
              //   Text(dateFormat.format(date)),
              // ),
              //DataCell(Text(bestsellings.note)),
              DataCell(Text(bestsellings.productName!.split(',')[0])),
              DataCell(Text(bestsellings.productUnit ?? "")),
              DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color.fromARGB(255, 77, 221, 163)
                        .withOpacity(0.3),
                  ),
                  child: Text(
                    "${bestsellings.productQuantitySold} Sold",
                    style:
                        const TextStyle(color: Color.fromARGB(255, 8, 88, 59)),
                  ))),
              //DataCell(Text(bestsellings.productSalesAmount.toString())),
              DataCell(Text(bestsellings.totalProfit.toString())),
              // DataCell(
              //   IconButton(
              //       onPressed: () {
              //         Get.toNamed(
              //             "${Routes.app}${Routes.bestsellingProduct}/details/${bestsellings.id}");
              //       },
              //       icon: const Icon(Icons.preview)),
              // ),
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

class BestSellingsWebServiceResponse {
  BestSellingsWebServiceResponse(
      {required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<BestSellingProductModel> data;
}

class BestSellingsWebService extends BaseApiService {
  Future<BestSellingsWebServiceResponse> getData(
      int startingAt,
      int count,
      String? filter,
      String sortedBy,
      bool sortedAsc,
      int? warehouseId,
      int startDate,
      int endDate) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc",
    };

    if (warehouseId == null || warehouseId == -1) {
      params.addAll({
        //"warehouseId": warehouseId,
        "startDate": startDate,
        "endDate": endDate
      });
    } else {
      params.addAll({
        "warehouseId": warehouseId,
        "startDate": startDate,
        "endDate": endDate
      });
    }
    final response =
        await getRequest('/reports/sales/products', params: params);

    if (response != null && response.statusCode == 200) {
      List<BestSellingProductModel> bestsellingsList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        bestsellingsList.add(BestSellingProductModel(
          productId: v['productId'],
          productName: v['productName'],
          productUnit: v['productUnit'],
          productQuantitySold: v['productQuantitySold'],
          productSalesAmount: v['productSalesAmount'],
          totalProfit: v['totalProfit'],
        ));
      }
      return BestSellingsWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: bestsellingsList);
    } else {
      return BestSellingsWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteBestSellings(int id) async {
    final response = await deleteRequest('/bestsellings', id);
    print(response?.statusCode);
    print(response?.data);
  }

  // Future<Map<String, dynamic>> getBestSellingTotal(
  //     int startDate, int endDate, int? warehouseId) async {
  //   print("EEL");
  //   Map<String, dynamic> params = {};
  //   if (warehouseId == null || warehouseId == -1) {
  //     params.addAll({
  //       //"warehouseId": warehouseId,
  //       "startDate": startDate,
  //       "endDate": endDate
  //     });
  //   } else {
  //     params.addAll({
  //       "warehouseId": warehouseId,
  //       "startDate": startDate,
  //       "endDate": endDate
  //     });
  //   }

  //   final response = await getRequest('/reports/bestsellings/total', params: params);
  //   print(response?.statusCode);
  //   //print(response?.data as );
  //   return response?.data;
  // }
}
