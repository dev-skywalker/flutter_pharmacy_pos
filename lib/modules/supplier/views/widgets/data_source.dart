import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/supplier/model/supplier_model.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class SupplierDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  SupplierDataSourceAsync() {
    print('SupplierDataSourceAsync created');
  }

  SupplierDataSourceAsync.empty() {
    _empty = true;
    print('SupplierDataSourceAsync.empty created');
  }

  SupplierDataSourceAsync.error() {
    _errorCounter = 0;
    print('SupplierDataSourceAsync.error created');
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

  final SupplierWebService _repo = SupplierWebService();

  // int? get delete => _delete;
  Future<void> deleteSupplier(int? id) async {
    await _repo.deleteSupplier(id!);
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
            () => SupplierWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((supplier) {
          //var nameList = supplier.name?.split(",") ?? ["product name"];
          DateTime createdAt =
              DateTime.fromMillisecondsSinceEpoch(supplier.createdAt!);
          DateTime updatedAt =
              DateTime.fromMillisecondsSinceEpoch(supplier.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(supplier.id),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(supplier.id.toString())),
              DataCell(
                Text(supplier.name),
              ),
              DataCell(Text(supplier.phone ?? "")),
              DataCell(Text(dateFormat.format(createdAt))),
              DataCell(Text(dateFormat.format(updatedAt))),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(
                            "${Routes.app}${Routes.suppliers}${Routes.update}/${supplier.id}",
                            arguments: supplier);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        deleteSupplier(supplier.id);
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

class SupplierWebServiceResponse {
  SupplierWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<SupplierModel> data;
}

class SupplierWebService extends BaseApiService {
  Future<SupplierWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/suppliers', params: params);

    if (response != null && response.statusCode == 200) {
      List<SupplierModel> supplierList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        supplierList.add(SupplierModel(
          id: v['id'],
          name: v['name'],
          phone: v['phone'],
          email: v['email'],
          city: v['city'],
          address: v['address'],
          createdAt: v['createdAt'],
          updatedAt: v['updatedAt'],
        ));
      }
      return SupplierWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: supplierList);
    } else {
      return SupplierWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteSupplier(int id) async {
    final response = await deleteRequest('/suppliers', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
