import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';
import '../../model/category_model.dart';

/// saync data fetching scenarious by paginated table (such as using Web API)
class CategoryDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;

  CategoryDataSourceAsync() {
    print('CategoryDataSourceAsync created');
  }

  CategoryDataSourceAsync.empty() {
    _empty = true;
    print('CategoryDataSourceAsync.empty created');
  }

  CategoryDataSourceAsync.error() {
    _errorCounter = 0;
    print('CategoryDataSourceAsync.error created');
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

  final CategoryWebService _repo = CategoryWebService();

  // int? get delete => _delete;
  Future<void> deleteCategory(int? id) async {
    await _repo.deleteCategory(id!);
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
            () => CategoryWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);

    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((category) {
          //var nameList = category.name?.split(",") ?? ["product name"];
          DateTime createdAt =
              DateTime.fromMillisecondsSinceEpoch(category.createdAt!);
          DateTime updatedAt =
              DateTime.fromMillisecondsSinceEpoch(category.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(category.id),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(category.id.toString())),
              DataCell(
                Text(category.name),
              ),
              DataCell(Text(category.description ?? "")),
              DataCell(Text(dateFormat.format(createdAt))),
              DataCell(Text(dateFormat.format(updatedAt))),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(
                            "${Routes.app}${Routes.category}${Routes.update}/${category.id}",
                            arguments: category);
                      },
                      icon: const Icon(
                        Icons.edit_square,
                        color: Colors.indigo,
                      )),
                  IconButton(
                      onPressed: () {
                        deleteCategory(category.id);
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

class CategoryWebServiceResponse {
  CategoryWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<Category> data;
}

class CategoryWebService extends BaseApiService {
  Future<CategoryWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/category', params: params);

    if (response != null && response.statusCode == 200) {
      List<Category> categoryList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        categoryList.add(Category(
          id: v['id'],
          name: v['name'],
          description: v['description'],
          createdAt: v['createdAt'],
          updatedAt: v['updatedAt'],
        ));
      }
      return CategoryWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: categoryList);
    } else {
      return CategoryWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteCategory(int id) async {
    final response = await deleteRequest('/category', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
