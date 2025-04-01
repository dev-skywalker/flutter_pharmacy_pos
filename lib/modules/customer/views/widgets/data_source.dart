import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_pos/modules/customer/model/customer_model.dart';
import 'package:pharmacy_pos/services/base_api_service.dart';

import '../../../../routes/routes.dart';

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class CustomerDataSourceAsync extends AsyncDataTableSource {
  bool _disposed = false;
  CustomerDataSourceAsync() {
    print('CustomerDataSourceAsync created');
  }

  CustomerDataSourceAsync.empty() {
    _empty = true;
    print('CustomerDataSourceAsync.empty created');
  }

  CustomerDataSourceAsync.error() {
    _errorCounter = 0;
    print('CustomerDataSourceAsync.error created');
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

  final CustomerWebService _repo = CustomerWebService();

  // int? get delete => _delete;
  Future<void> deleteCustomer(int? id) async {
    await _repo.deleteCustomer(id!);
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
            () => CustomerWebServiceResponse(totalRecords: 0, data: []))
        : await _repo.getData(
            startIndex, count, _filter, _sortColumn, _sortAscending);
    if (_disposed) return AsyncRowsResponse(totalRecords, []);
    totalRecords = x.totalRecords;

    var r = AsyncRowsResponse(
        x.totalRecords,
        x.data.map((customer) {
          //var nameList = customer.name?.split(",") ?? ["product name"];
          DateTime createdAt =
              DateTime.fromMillisecondsSinceEpoch(customer.createdAt!);
          DateTime updatedAt =
              DateTime.fromMillisecondsSinceEpoch(customer.updatedAt!);
          var dateFormat = DateFormat('dd/MM/yyyy');
          return DataRow(
            key: ValueKey<int>(customer.id),
            selected: false,

            onSelectChanged: null,
            // onSelectChanged: (value) {
            //   if (value != null) {
            //     setRowSelection(ValueKey<int>(product.id), value);
            //   }
            // },
            cells: [
              DataCell(Text(customer.id.toString())),
              DataCell(
                Text(customer.name),
              ),
              DataCell(Text(customer.phone ?? "")),
              DataCell(Text(dateFormat.format(createdAt))),
              DataCell(Text(dateFormat.format(updatedAt))),
              DataCell(Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed(
                            "${Routes.app}${Routes.customers}${Routes.update}/${customer.id}",
                            arguments: customer);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        deleteCustomer(customer.id);
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

class CustomerWebServiceResponse {
  CustomerWebServiceResponse({required this.totalRecords, required this.data});

  /// THe total ammount of records on the server, e.g. 100
  final int totalRecords;

  /// One page, e.g. 10 reocrds
  final List<CustomerModel> data;
}

class CustomerWebService extends BaseApiService {
  Future<CustomerWebServiceResponse> getData(int startingAt, int count,
      String? filter, String sortedBy, bool sortedAsc) async {
    final Map<String, dynamic> params = {
      "filter": filter,
      "limit": count,
      "offset": startingAt,
      "sortBy": sortedBy,
      "sortOrder": sortedAsc ? "asc" : "desc"
    };
    final response = await getRequest('/customers', params: params);

    if (response != null && response.statusCode == 200) {
      List<CustomerModel> customerList = [];
      final data = response.data['data'] as List<dynamic>;
      for (var v in data) {
        customerList.add(CustomerModel(
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
      return CustomerWebServiceResponse(
          totalRecords: response.data['totalRecords'], data: customerList);
    } else {
      return CustomerWebServiceResponse(totalRecords: 0, data: []);
    }

    // return Future.delayed(const Duration(milliseconds: 400), () {
    //   var result = _productsX3;

    //   //result.sort(_getComparisonFunction(sortedBy, sortedAsc));

    // });
  }

  Future<void> deleteCustomer(int id) async {
    final response = await deleteRequest('/customers', id);
    print(response?.statusCode);
    print(response?.data);
  }
}
