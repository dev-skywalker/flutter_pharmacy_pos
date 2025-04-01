import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../../widgets/custom_pager.dart';
import '../../../widgets/nav_helper.dart';
import 'widgets/data_source.dart';

// ignore_for_file: avoid_print

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  SalesPageState createState() => SalesPageState();
}

class SalesPageState extends State<SalesPage> {
  final int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  SalesDataSourceAsync? _dessertsDataSource;
  final PaginatorController _controller = PaginatorController();

  bool _dataSourceLoading = false;
  int _initialRow = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    _dessertsDataSource?.refreshDatasource();
    // initState is to early to access route options, context is invalid at that stage
    _dessertsDataSource ??= getCurrentRouteOption(context) == noData
        ? SalesDataSourceAsync.empty()
        : getCurrentRouteOption(context) == asyncErrors
            ? SalesDataSourceAsync.error()
            : SalesDataSourceAsync();

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
        label: const Text('Date'),
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Warehouse'),
        size: ColumnSize.L,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Customer'),
        size: ColumnSize.M,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Amount'),
        size: ColumnSize.M,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Status'),
        size: ColumnSize.S,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Payment Status'),
        size: ColumnSize.S,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Action'),
        size: ColumnSize.L,
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
        children: [
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
                        hintText: "Search Sales",
                        suffix: IconButton(
                            iconSize: 16,
                            color: Colors.red,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _dessertsDataSource!.filter = "";

                              //setState(() {
                              searchController.clear();
                              //});
                            },
                            icon: const Icon(
                              Icons.clear,
                            ))),
                    onChanged: (value) {
                      //setState(() {
                      _dessertsDataSource!.filter = value;
                      //});
                    },
                  ),
                ),
                Flexible(flex: isSmallScreen ? 3 : 0, child: Container()),
                const SizedBox(width: 8),
                SizedBox(
                  width: isSmallScreen ? 150 : 100,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(
                          '${Routes.app}${Routes.sales}${Routes.create}');
                    },
                    child: Container(
                      //height: 42,
                      // width: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          isSmallScreen ? "Create Sales" : "Create",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
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
                    minWidth: 1000,
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
                            child: const Text('No data'))),
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
                      pagerName: "Sales",
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
