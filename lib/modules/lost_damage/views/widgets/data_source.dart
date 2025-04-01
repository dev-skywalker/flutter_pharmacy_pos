import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../model/lost_damage_model.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class LostDamageDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  LostDamageDataSourceAsync() {
    print('LostDamageDataSourceAsync created');
  }

  LostDamageDataSourceAsync.empty() {
    _empty = true;
    print('LostDamageDataSourceAsync.empty created');
  }

  LostDamageDataSourceAsync.error() {
    _errorCounter = 0;
    print('LostDamageDataSourceAsync.error created');
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

  final LostDamageWebService _repo = LostDamageWebService();

  // int? get delete => _delete;
  Future<void> deleteLostDamage(int? id) async {
    await _repo.deleteLostDamage(id!);
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
            () => LostDamageWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((lostdamage) {
          //var nameList = lostdamage.name?.split(",") ?? ["product name"];
          // DateTime date = DateTime.fromMillisecondsSinceEpoch(lostdamage.date);
          // DateTime createdAt =
          //     DateTime.fromMillisecondsSinceEpoch(lostdamage.createdAt!);
          // DateTime updatedAt =
          //     DateTime.fromMillisecondsSinceEpoch(lostdamage.updatedAt!);
          // var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(lostdamage.id!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(lostdamage.id.toString())),
              DataCell(
                Text(lostdamage.productName!.split(',')[0]),
              ),
              DataCell(Text(lostdamage.quantity.toString())),
              DataCell(Text(lostdamage.amount.toString())),
              DataCell(Text(lostdamage.warehouseName ?? "")),
              DataCell(Text(lostdamage.reason ?? "")),
              // DataCell(Text(dateFormat.format(createdAt))),
              // DataCell(Text(dateFormat.format(updatedAt))),
              // DataCell(Row(
              //   children: [
              //     IconButton(
              //         onPressed: () {
              //           Get.toNamed(
              //               "${Routes.app}${Routes.lostDamage}/details/${lostdamage.id}",
              //               arguments: lostdamage);
              //         },
              //         icon: const Icon(Icons.preview)),
              //     // IconButton(
              //     //     onPressed: () {
              //     //       Get.toNamed(
              //     //           "${Routes.app}${Routes.lostdamage}${Routes.update}/${lostdamage.id}",
              //     //           arguments: lostdamage);
              //     //     },
              //     //     icon: const Icon(Icons.edit)),
              //     IconButton(
              //         onPressed: () {
              //           deleteLostDamage(lostdamage.id);
              //         },
              //         icon: const Icon(Icons.delete))
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

class LostDamageWebServiceResponse {
  LostDamageWebServiceResponse(
      {required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<LostDamageModel> data;
}

class LostDamageWebService extends BaseApiService {
  Future<LostDamageWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/lost_damage', params: params);

    if (response != null && response.statusCode == 200) {
      List<LostDamageModel> lostdamageList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        lostdamageList.add(LostDamageModel(
          id: v['id'],
          productName: v['productName'],
          quantity: v['quantity'],
          reason: v['reason'],
          amount: v['amount'],
          warehouseName: v['warehouseName'],
          createdAt: v['createdAt'],
          updatedAt: v['updatedAt'],
        ));
      }
      return LostDamageWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: lostdamageList);
    } else {
      return LostDamageWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteLostDamage(int id) async {
    final response = await deleteRequest('/lostdamage', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
