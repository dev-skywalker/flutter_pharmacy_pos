import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:pharmacy_pos/modules/product/model/product_model.dart';
import 'package:pharmacy_pos/modules/units/model/unit_model.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';

class ProductDataSource extends DataTableSource {
  ProductDataSource.empty(this.context) {
    products = [];
  }

  ProductDataSource(this.context,
      [sortedByCalories = false,
      this.hasRowTaps = false,
      this.hasRowHeightOverrides = false,
      this.hasZebraStripes = false]);

  final BuildContext context;
  late List<ProductModel> products;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;
  //List<ProductModel> products = [];

  // void sort<T>(
  //     Comparable<T> Function(ProductModel d) getField, bool ascending) {
  //   products.sort((a, b) {
  //     final aValue = getField(a);
  //     final bValue = getField(b);
  //     return ascending
  //         ? Comparable.compare(aValue, bValue)
  //         : Comparable.compare(bValue, aValue);
  //   });
  //   notifyListeners();
  // }

  @override
  DataRow2 getRow(int index, [Color? color]) {
    // final format = NumberFormat.decimalPercentPattern(
    //   locale: 'en',
    //   decimalDigits: 0,
    // );
    assert(index >= 0);
    if (index >= products.length) throw 'index > _products.length';
    final product = products[index];
    return DataRow2.byIndex(
      index: index,
      selected: false,
      // specificRowHeight:
      //     hasRowHeightOverrides && product.fat >= 25 ? 100 : null,
      cells: [
        DataCell(SizedBox(
          width: 15,
          child: Text(product.id.toString()),
        )),
        DataCell(
          Text(product.name ?? ""),
        ),
        DataCell(Text(product.units?.name ?? "")),
        DataCell(Text(product.units?.name == "card"
            ? "${product.tabletOnCard}Tablets x ${product.cardOnBox}Tablets"
            : product.units?.name ?? "")),
        DataCell(Text(product.description ?? "")),
        DataCell(Text(product.isLocalProduct.toString())),
      ],
    );
  }

  @override
  int get rowCount => products.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  // void selectAll(bool? checked) {
  //   // for (final product in products) {
  //   //   product.selected = checked ?? false;
  //   // }
  //   _selectedCount = (checked ?? false) ? products.length : 0;
  //   notifyListeners();
  // }
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class ProductDataSourceAsync extends AsyncDataTableSource {
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
    //notifyListeners();
  }

  final ProductWebService _repo = ProductWebService();

  // int? get delete => _delete;
  void deleteProduct(int? id) {
    _repo.deleteProduct(id!);
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
            () => ProductWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((product) {
          var nameList = product.name?.split(",") ?? ["product name"];
          return DataRow(
            key: ValueKey<int>(product.id!),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: product.imageUrl != ""
                    ? Image.network(product.imageUrl.toString())
                    : Image.asset(
                        "assets/images/m-placeholder.png",
                        fit: BoxFit.fill,
                      ),
              )),
              DataCell(
                Text(nameList[0]),
              ),
              DataCell(Text(product.units?.name ?? "")),
              DataCell(Text(product.units?.name == "card"
                  ? "${product.tabletOnCard}Tablets x ${product.cardOnBox}Cards"
                  : product.units?.name ?? "")),
              DataCell(IconButton(
                  onPressed: () {
                    //deleteProduct(product.id);
                    Get.toNamed(
                        "${Routes.app}${Routes.products}${Routes.update}/${product.id}",
                        arguments: product);
                  },
                  icon: const Icon(Icons.edit))),
              DataCell(IconButton(
                  onPressed: () {
                    deleteProduct(product.id);
                  },
                  icon: const Icon(Icons.delete))),
            ],
          );
        }).toList());

    return r;
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
        productList.add(ProductModel(
          id: v['id'],
          name: v['name'],
          barcode: v['barcode'],
          description: v['description'],
          imageUrl: v['imageUrl'],
          tabletOnCard: v['tabletOnCard'],
          cardOnBox: v['cardOnBox'],
          isLocalProduct: v['isLocalProduct'],
          unitId: v['unitId'],
          createdAt: v['createdAt'],
          updatedAt: v['updatedAt'],
          units: Units(
              id: v['units']['id'],
              name: v['units']['name'],
              createdAt: v['units']['createdAt'],
              updatedAt: v['units']['updatedAt']),
        ));
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

  void deleteProduct(int id) async {
    final response = await deleteRequest('/products', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
