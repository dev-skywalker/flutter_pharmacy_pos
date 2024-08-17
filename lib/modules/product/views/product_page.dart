import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_pager.dart';
import '../../../widgets/nav_helper.dart';
import 'widgets/data_sources.dart';

// ignore_for_file: avoid_print

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  final int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  ProductDataSourceAsync? _dessertsDataSource;
  final PaginatorController _controller = PaginatorController();

  bool _dataSourceLoading = false;
  int _initialRow = 0;
  final TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    _dessertsDataSource?.refreshDatasource();
    // initState is to early to access route options, context is invalid at that stage
    _dessertsDataSource ??= getCurrentRouteOption(context) == noData
        ? ProductDataSourceAsync.empty()
        : getCurrentRouteOption(context) == asyncErrors
            ? ProductDataSourceAsync.error()
            : ProductDataSourceAsync();

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
    _dessertsDataSource!.dispose();
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
      const DataColumn2(
        label: Text('Unit'),
        size: ColumnSize.S,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Presentation'),
        size: ColumnSize.L,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Description'),
        size: ColumnSize.M,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        size: ColumnSize.S,
        label: Text('Action'),
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Last ppage example uses extra API call to get the number of items in datasource
    if (_dataSourceLoading) return const SizedBox();

    return Container(
      //color: Colors.white,
      margin: const EdgeInsets.only(top: 0.4),
      child: Stack(alignment: Alignment.bottomCenter, children: [
        AsyncPaginatedDataTable2(
            horizontalMargin: 20,
            checkboxHorizontalMargin: 12,
            showCheckboxColumn: false,
            columnSpacing: 30,
            //columnSpacing: 0.0,
            wrapInCard: false,
            header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: TextField(
                      //range: const RangeValues(150, 200),
                      decoration: InputDecoration(
                          hintText: "Search",
                          suffix: IconButton(
                              onPressed: () {
                                _dessertsDataSource!.filter = "";
                                searchController.clear();
                              },
                              icon: const Icon(Icons.clear))),
                      controller: searchController,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _dessertsDataSource!.filter = searchController.text;
                      },
                      child: const Text("Search")),
                  if (kDebugMode && getCurrentRouteOption(context) == custPager)
                    Row(children: [
                      OutlinedButton(
                          onPressed: () => _controller.goToPageWithRow(25),
                          child: const Text('Go to row 25')),
                      OutlinedButton(
                          onPressed: () => _controller.goToRow(5),
                          child: const Text('Go to row 5'))
                    ]),
                  if (getCurrentRouteOption(context) == custPager)
                    PageNumber(controller: _controller)
                ]),
            rowsPerPage: _rowsPerPage,
            autoRowsToHeight: getCurrentRouteOption(context) == autoRows,
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
            errorBuilder: (e) => _ErrorAndRetry(
                e.toString(), () => _dessertsDataSource!.refreshDatasource()),
            source: _dessertsDataSource!),
        //if (getCurrentRouteOption(context) == custPager)
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPager(
              controller: _controller,
              pagerName: "Product",
            ))
      ]),
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
