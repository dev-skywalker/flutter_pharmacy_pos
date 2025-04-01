import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';
import '../../../purchase/model/purchase_model.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class PurchaseProductDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  PurchaseProductDataSourceAsync() {
    print('PurchaseProductDataSourceAsync created');
  }

  PurchaseProductDataSourceAsync.empty() {
    _empty = true;
    print('PurchaseProductDataSourceAsync.empty created');
  }

  PurchaseProductDataSourceAsync.error() {
    _errorCounter = 0;
    print('PurchaseProductDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String? filter;
  int? warehouseId;
  int? _startDate;
  int? _endDate;

  int totalRecords = 0;

  // String? get filter => _filter;
  // int? get warehouseId => _warehouseId;

  void filters(String? search, int? id, int? startDate, int? endDate) {
    filter = search;
    warehouseId = id;
    _startDate = startDate;
    _endDate = endDate;
    refreshDatasource();
  }

  final PurchaseProductWebService _repo = PurchaseProductWebService();

  // int? get delete => _delete;
  Future<void> deletePurchaseProduct(int? id) async {
    await _repo.deletePurchaseProduct(id!);
    refreshDatasource();
    //notifyListeners();
  }

  Future<Map<String, dynamic>> getPurchaseTotal(
      int startDate, int endDate, int warehouseId) async {
    return await _repo.getPurchaseTotal(startDate, endDate, warehouseId);
    //refreshDatasource();
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

    final now = DateTime.now();
    var sDate = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    var eDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
        .millisecondsSinceEpoch;

    // List returned will be empty is there're fewer items than startingAt
    var x = _empty
        ? await Future.delayed(const Duration(milliseconds: 2000),
            () => PurchaseProductWebServiceResponse(totalRecords: 0, data: []))
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
        x.data.map((purchase) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(purchase.date!);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(purchaseproduct.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(purchaseproduct.updatedAt!);
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
              //DataCell(Text(purchase.warehouse?.name ?? "")),
              DataCell(Text(purchase.warehouse?.name ?? "")),
              DataCell(Text(purchase.supplier?.name ?? "")),
              DataCell(
                  Text((purchase.amount! + purchase.shipping!).toString())),
              DataCell(Text(purchase.status! == 0 ? "Received" : "Pending")),
              DataCell(Text(purchase.paymentStatus! == 0 ? "Paid" : "Unpaid")),
              DataCell(
                IconButton(
                    onPressed: () {
                      Get.toNamed(
                          "${Routes.app}${Routes.purchaseProduct}/details/${purchase.id}");
                    },
                    tooltip: "Purchase Details",
                    icon: const Icon(
                      Icons.content_paste,
                      color: Colors.teal,
                    )),
              ),
              // DataCell(Row(
              //   children: [

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

class PurchaseProductWebServiceResponse {
  PurchaseProductWebServiceResponse(
      {required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<PurchaseModel> data;
}

class PurchaseProductWebService extends BaseApiService {
  Future<PurchaseProductWebServiceResponse> getData(
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

    final response = await getRequest('/reports/purchase', params: params);

    if (response != null && response.statusCode == 200) {
      List<PurchaseModel> purchaseproductList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        purchaseproductList.add(PurchaseModel(
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
      return PurchaseProductWebServiceResponse(
          totalRecords: response.data['totalRecords'],
          data: purchaseproductList);
    } else {
      return PurchaseProductWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deletePurchaseProduct(int id) async {
    final response = await deleteRequest('/purchaseproduct', id);
    print(response?.statusCode);
    print(response?.data);
  }

  Future<Map<String, dynamic>> getPurchaseTotal(
      int startDate, int endDate, int warehouseId) async {
    Map<String, dynamic> param = {
      "startDate": startDate,
      "endDate": endDate,
      "warehouseId": warehouseId
    };
    final response = await getRequest('/reports/purchase/total', params: param);
    print(response?.statusCode);
    //print(response?.data as );
    return response?.data;
  }
}
