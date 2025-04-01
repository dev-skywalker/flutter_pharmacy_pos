import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/units/model/unit_model.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class UnitDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  UnitDataSourceAsync() {
    print('UnitDataSourceAsync created');
  }

  UnitDataSourceAsync.empty() {
    _empty = true;
    print('UnitDataSourceAsync.empty created');
  }

  UnitDataSourceAsync.error() {
    _errorCounter = 0;
    print('UnitDataSourceAsync.error created');
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

  final UnitWebService _repo = UnitWebService();

  // int? get delete => _delete;
  Future<void> deleteUnit(int? id) async {
    await _repo.deleteUnit(id!);
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
            () => UnitWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((unit) {
          //var nameList = unit.name?.split(",") ?? ["product name"];
          DateTime createdAt =
              DateTime.fromMillisecondsSinceEpoch(unit.createdAt!);
          DateTime updatedAt =
              DateTime.fromMillisecondsSinceEpoch(unit.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(unit.id),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(unit.id.toString())),
              DataCell(
                Text(unit.name),
              ),
              DataCell(Text(unit.description ?? "")),
              DataCell(Text(dateFormat.format(createdAt))),
              DataCell(Text(dateFormat.format(updatedAt))),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        //deleteProduct(product.id);
                        Get.toNamed(
                            "${Routes.app}${Routes.units}${Routes.update}/${unit.id}",
                            arguments: unit);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        deleteUnit(unit.id);
                      },
                      icon: const Icon(Icons.delete))
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

class UnitWebServiceResponse {
  UnitWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<Units> data;
}

class UnitWebService extends BaseApiService {
  Future<UnitWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/units', params: params);

    if (response != null && response.statusCode == 200) {
      List<Units> unitList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        unitList.add(Units(
          id: v['id'],
          name: v['name'],
          description: v['description'],
          createdAt: v['createdAt'],
          updatedAt: v['updatedAt'],
        ));
      }
      return UnitWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: unitList);
    } else {
      return UnitWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteUnit(int id) async {
    final response = await deleteRequest('/units', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
