import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/brands/model/brand_model.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';

/// saync data fetching scenarious by paginated table (such as using Web API)
class BrandDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;

  BrandDataSourceAsync() {
    print('BrandDataSourceAsync created');
  }

  BrandDataSourceAsync.empty() {
    _empty = true;
    print('BrandDataSourceAsync.empty created');
  }

  BrandDataSourceAsync.error() {
    _errorCounter = 0;
    print('BrandDataSourceAsync.error created');
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

  final BrandWebService _repo = BrandWebService();

  // int? get delete => _delete;
  Future<void> deleteBrand(int? id) async {
    await _repo.deleteBrand(id!);
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
            () => BrandWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);

    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((brand) {
          //var nameList = brand.name?.split(",") ?? ["product name"];
          DateTime createdAt =
              DateTime.fromMillisecondsSinceEpoch(brand.createdAt!);
          DateTime updatedAt =
              DateTime.fromMillisecondsSinceEpoch(brand.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(brand.id),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(brand.id.toString())),
              DataCell(
                Text(brand.name),
              ),
              DataCell(Text(brand.description ?? "")),
              DataCell(Text(dateFormat.format(createdAt))),
              DataCell(Text(dateFormat.format(updatedAt))),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        //deleteProduct(product.id);
                        Get.toNamed(
                            "${Routes.app}${Routes.brands}${Routes.update}/${brand.id}",
                            arguments: brand);
                      },
                      icon: const Icon(
                        Icons.edit_square,
                        color: Colors.indigo,
                      )),
                  IconButton(
                      onPressed: () {
                        deleteBrand(brand.id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
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

class BrandWebServiceResponse {
  BrandWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<Brands> data;
}

class BrandWebService extends BaseApiService {
  Future<BrandWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/brands', params: params);

    if (response != null && response.statusCode == 200) {
      List<Brands> brandList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        brandList.add(Brands(
          id: v['id'],
          name: v['name'],
          description: v['description'],
          createdAt: v['createdAt'],
          updatedAt: v['updatedAt'],
        ));
      }
      return BrandWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: brandList);
    } else {
      return BrandWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteBrand(int id) async {
    final response = await deleteRequest('/brands', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
