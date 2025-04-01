import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/product/model/product_model.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class ProductDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  ProductDataSourceAsync() {
    print('ProductDataSourceAsync created');
  }

  ProductDataSourceAsync.empty() {
    _empty = true;
    print('ProductDataSourceAsync.empty created');
  }

  ProductDataSourceAsync.error() {
    _errorCounter = 0;
    print('ProductDataSourceAsync.error created');
  }

  bool _empty = false;
  int? _errorCounter;

  String? _filter;

  int totalRecords = 0;

  String? get filter => _filter;
  set filter(String? search) {
    _filter = search;
    refreshDatasource();
  }

  final ProductWebService _repo = ProductWebService();

  // int? get delete => _delete;
  void deleteProduct(int? id) async {
    final res = await _repo.deleteProduct(id!);
    if (res == "success") {
      Get.snackbar("Success", "Product delete successfully.",
          snackPosition: SnackPosition.bottom);
    } else {
      Get.snackbar("Something Wrong", "Product already used other table.",
          snackPosition: SnackPosition.bottom);
    }
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

    assert(startIndex >= 0);

    // List returned will be empty is there're fewer items than startingAt
    var x = _empty
        ? await Future.delayed(const Duration(milliseconds: 2000),
            () => ProductWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);

    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((product) {
          var nameList = product.name.split(",");
          String? expire;
          if (product.expireDate != null) {
            DateTime? dt =
                DateTime.fromMillisecondsSinceEpoch(product.expireDate!);

            var date = DateFormat('dd/MM/yyyy').format(dt);
            expire = date;
          }

          return DataRow(
            key: ValueKey<int>(product.id),
            selected: false,
            onSelectChanged: null,
            cells: [
              DataCell(SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: product.imageUrl != ""
                      ? Image.network(
                          product.imageUrl.toString(),
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          "assets/images/m-placeholder.png",
                          fit: BoxFit.fill,
                        ),
                ),
              )),
              DataCell(
                Text(nameList[0]),
              ),
              DataCell(Text(product.unit.name)),
              DataCell(Text(product.productCost.toString())),
              DataCell(Text(product.productPrice.toString())),
              DataCell(Text(expire ?? "")),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(
                            "${Routes.app}${Routes.products}/details/${product.id}");
                      },
                      icon: const Icon(
                        Icons.content_paste,
                        color: Colors.teal,
                      )),
                  IconButton(
                      onPressed: () {
                        //deleteProduct(product.id);
                        Get.toNamed(
                            "${Routes.app}${Routes.products}${Routes.update}/${product.id}",
                            arguments: product);
                      },
                      icon: const Icon(
                        Icons.edit_square,
                        color: Colors.indigo,
                      )),
                  IconButton(
                      onPressed: () {
                        deleteProduct(product.id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
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

class ProductWebServiceResponse {
  ProductWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<ProductModel> data;
}

class ProductWebService extends BaseApiService {
  Future<ProductWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/products', params: params);

    if (response != null && response.statusCode == 200) {
      List<ProductModel> productList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        productList.add(ProductModel.fromJson(v));
      }
      return ProductWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: productList);
    } else {
      return ProductWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<String> deleteProduct(int id) async {
    print(id);
    final response = await deleteRequest('/products', id);
    print(response?.statusCode);
    print(response?.data);
    if (response != null && response.statusCode == 200) {
      return response.data['status'];
    } else {
      return "";
    }
  }
}
