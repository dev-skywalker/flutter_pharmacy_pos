import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../../widgets/custom_pager.dart';
import '../../../widgets/nav_helper.dart';
import '../../warehouse/model/warehouse_model.dart';
import '../../warehouse/services/warehouse_services.dart';
import 'widgets/data_source.dart';

class StocksPage extends StatefulWidget {
  const StocksPage({super.key});

  @override
  StocksPageState createState() => StocksPageState();
}

class StocksPageState extends State<StocksPage> {
  final int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  StocksDataSourceAsync? _dessertsDataSource;
  final PaginatorController _controller = PaginatorController();

  bool _dataSourceLoading = false;
  int _initialRow = 0;
  WarehouseModel? _selectedWarehouse;
  final TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    _dessertsDataSource?.refreshDatasource();
    // initState is to early to access route options, context is invalid at that stage
    _dessertsDataSource ??= getCurrentRouteOption(context) == noData
        ? StocksDataSourceAsync.empty()
        : getCurrentRouteOption(context) == asyncErrors
            ? StocksDataSourceAsync.error()
            : StocksDataSourceAsync();

    if (getCurrentRouteOption(context) == goToLast) {
      _dataSourceLoading = true;
      _dessertsDataSource!.getTotalRecords().then((count) => setState(() {
            _initialRow = count - _rowsPerPage;
            _dataSourceLoading = false;
          }));
    }
    super.didChangeDependencies();
  }

  void sort(
    int columnIndex,
    bool ascending,
  ) {
    var columnName = "name";
    switch (columnIndex) {
      case 0:
        columnName = "id";
        break;
      case 1:
        columnName = "name";
        break;
      case 2:
        columnName = "qty";
        break;
    }
    _dessertsDataSource!.sort(columnName, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<DataColumn> get _columns {
    return [
      DataColumn2(
        size: ColumnSize.S,
        label: const Text('ID'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: const Text('Name'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Text('Qty'),
        size: ColumnSize.S,
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Unit'),
        size: ColumnSize.S,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Cost'),
        size: ColumnSize.M,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Price'),
        size: ColumnSize.M,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Expire Date'),
        size: ColumnSize.M,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width >= 980;
    // Last ppage example uses extra API call to get the number of items in datasource
    if (_dataSourceLoading) return const SizedBox();

    return Padding(
      padding: EdgeInsets.only(
          top: 12, left: isSmallScreen ? 20 : 8, right: isSmallScreen ? 20 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Warehouse : ",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: isSmallScreen ? 300 : 150,
                    child: DropdownSearch<WarehouseModel>(
                      popupProps: const PopupProps.menu(
                        constraints: BoxConstraints(maxHeight: 200),
                        searchDelay: Duration.zero,
                      ),
                      asyncItems: (String filter) async {
                        final WarehouseService warehouseService =
                            WarehouseService();
                        final response =
                            await warehouseService.getAllWarehouses();
                        if (response != null && response.statusCode == 200) {
                          List<dynamic> data =
                              response.data['data'] as List<dynamic>;

                          return data
                              .map((v) => WarehouseModel.fromJson(v))
                              .toList();
                        } else {
                          return [];
                        }
                      },
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "Select Warehouse",
                          // labelText: "Warehouse",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      selectedItem: _selectedWarehouse,
                      onChanged: (value) {
                        //setState(() {});
                        _selectedWarehouse = value;
                        _dessertsDataSource!
                            .filters('', _selectedWarehouse!.id);
                        //controller.selectedWarehouse.value = value!;
                      },
                      itemAsString: (WarehouseModel warehouse) =>
                          warehouse.name,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        //isDense: true,
                        //contentPadding: EdgeInsets.only(bottom: 36),
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(gapPadding: 0),
                        hintText: "Search Product",
                        suffix: IconButton(
                            iconSize: 16,
                            color: Colors.red,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _dessertsDataSource!
                                  .filters('', _selectedWarehouse!.id);

                              //setState(() {
                              searchController.clear();
                              //});
                            },
                            icon: const Icon(
                              Icons.clear,
                            ))),
                    onChanged: (value) {
                      //setState(() {
                      // _dessertsDataSource.warehouseId
                      _dessertsDataSource!
                          .filters(value, _selectedWarehouse!.id);
                      //_dessertsDataSource!.filter = value;
                      //});
                    },
                  ),
                ),
                //Spacer()
                Flexible(flex: isSmallScreen ? 4 : 0, child: Container()),
                // const SizedBox(width: 8),
                // SizedBox(
                //   width: isSmallScreen ? 200 : 120,
                //   child: DropdownSearch<WarehouseModel>(
                //     popupProps: const PopupProps.menu(
                //       constraints: BoxConstraints(maxHeight: 200),
                //       searchDelay: Duration.zero,
                //     ),
                //     asyncItems: (String filter) async {
                //       final WarehouseService warehouseService =
                //           WarehouseService();
                //       final response =
                //           await warehouseService.getAllWarehouses();
                //       if (response != null && response.statusCode == 200) {
                //         List<dynamic> data =
                //             response.data['data'] as List<dynamic>;
                //         return data
                //             .map((v) => WarehouseModel.fromJson(v))
                //             .toList();
                //       } else {
                //         return [];
                //       }
                //     },
                //     dropdownDecoratorProps: const DropDownDecoratorProps(
                //       dropdownSearchDecoration: InputDecoration(
                //         hintText: "Choose Warehouse",
                //         // labelText: "Warehouse",
                //         border: OutlineInputBorder(),
                //       ),
                //     ),
                //     selectedItem: _selectedWarehouse,
                //     onChanged: (value) {
                //       //setState(() {});
                //       _selectedWarehouse = value;
                //       _dessertsDataSource!.filters('', _selectedWarehouse!.id);
                //       //controller.selectedWarehouse.value = value!;
                //     },
                //     itemAsString: (WarehouseModel warehouse) => warehouse.name,
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Flexible(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Stack(alignment: Alignment.bottomCenter, children: [
                AsyncPaginatedDataTable2(
                    headingRowHeight: 50,
                    dataRowHeight: 50,
                    minWidth: 600,
                    horizontalMargin: 20,
                    checkboxHorizontalMargin: 12,
                    showCheckboxColumn: false,
                    columnSpacing: 30,
                    //columnSpacing: 0.0,
                    wrapInCard: false,
                    rowsPerPage: _rowsPerPage,
                    autoRowsToHeight:
                        getCurrentRouteOption(context) == autoRows,
                    // Default - do nothing, autoRows - goToLast, other - goToFirst
                    pageSyncApproach: getCurrentRouteOption(context) == dflt
                        ? PageSyncApproach.doNothing
                        : getCurrentRouteOption(context) == autoRows
                            ? PageSyncApproach.goToLast
                            : PageSyncApproach.goToFirst,
                    //minWidth: 450,
                    //fit: FlexFit.tight,
                    border: TableBorder(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                    onRowsPerPageChanged: null,
                    initialFirstRowIndex: _initialRow,
                    onPageChanged: (rowIndex) {
                      //print(rowIndex / _rowsPerPage);
                    },
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    sortArrowIcon: Icons.keyboard_arrow_up,
                    sortArrowAnimationDuration: const Duration(milliseconds: 0),
                    controller: _controller,
                    columns: _columns,
                    empty: Center(
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.grey[200],
                            child: Text(_selectedWarehouse != null
                                ? "No Data"
                                : 'Please Select Warehouse First'))),
                    loading: _Loading(),
                    errorBuilder: (e) => _ErrorAndRetry(e.toString(),
                        () => _dessertsDataSource!.refreshDatasource()),
                    source: _dessertsDataSource!),
                //if (getCurrentRouteOption(context) == custPager)
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomPager(
                      controller: _controller,
                      pagerName: "Stocks",
                    ))
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorAndRetry extends StatelessWidget {
  const _ErrorAndRetry(this.errorMessage, this.retry);

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 70,
            color: Colors.red,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Oops! $errorMessage',
                      style: const TextStyle(color: Colors.white)),
                  TextButton(
                      onPressed: retry,
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        Text('Retry', style: TextStyle(color: Colors.white))
                      ]))
                ])),
      );
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Colors.white.withAlpha(128),
        // at first show shade, if loading takes longer than 0,5s show spinner
        child: FutureBuilder(
            future:
                Future.delayed(const Duration(milliseconds: 500), () => true),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const SizedBox()
                  : Center(
                      child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(7),
                      width: 150,
                      height: 50,
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                            Text('Loading...')
                          ]),
                    ));
            }));
  }
}
