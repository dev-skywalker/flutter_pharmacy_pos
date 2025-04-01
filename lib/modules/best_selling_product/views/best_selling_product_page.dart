import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../widgets/custom_pager.dart';
import '../../../widgets/nav_helper.dart';
import '../../warehouse/model/warehouse_model.dart';
import '../../warehouse/services/warehouse_services.dart';
import 'widgets/data_source.dart';

class BestSellingProductPage extends StatefulWidget {
  const BestSellingProductPage({super.key});

  @override
  BestSellingProductPageState createState() => BestSellingProductPageState();
}

class BestSellingProductPageState extends State<BestSellingProductPage> {
  final int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool _sortAscending = true;
  int? _sortColumnIndex;
  BestSellingProductDataSourceAsync? _dessertsDataSource;
  final PaginatorController _controller = PaginatorController();

  bool _dataSourceLoading = false;
  int _initialRow = 0;
  late WarehouseModel _selectedWarehouse = WarehouseModel(id: -1, name: "ALL");
  final TextEditingController searchController = TextEditingController();

  String? selectedRange = "Today";
  DateTime? startDate;
  DateTime? endDate;
  Map<String, dynamic>? response;

  // @override
  // void initState() {
  //   _getBestSellingTotal();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    // print("Workkkkkkkkkkkkkkks");
    //_getBestSellingTotal();
    //_dessertsDataSource?.refreshDatasource();
    // initState is to early to access route options, context is invalid at that stage
    _dessertsDataSource ??= getCurrentRouteOption(context) == noData
        ? BestSellingProductDataSourceAsync.empty()
        : getCurrentRouteOption(context) == asyncErrors
            ? BestSellingProductDataSourceAsync.error()
            : BestSellingProductDataSourceAsync();

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
        label: const Text('Unit'),
        size: ColumnSize.S,
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      DataColumn2(
        label: const Text('Qty'),
        size: ColumnSize.S,
        onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      const DataColumn2(
        label: Text('Amount'),
        size: ColumnSize.S,
        //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      ),
      // const DataColumn2(
      //   label: Text('Cost'),
      //   size: ColumnSize.M,
      //   //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      // ),
      // const DataColumn2(
      //   label: Text('profit'),
      //   size: ColumnSize.M,
      //   //onSort: (columnIndex, ascending) => sort(columnIndex, ascending),
      // ),
    ];
  }

  // void _getBestSellingTotal() async {
  //   final now = DateTime.now();
  //   var sDate = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  //   var eDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999)
  //       .millisecondsSinceEpoch;
  //   final bestsellingService = BestSellingProductService();
  //   final res = await bestsellingService.getBestSellingProductTotal(
  //       startDate?.millisecondsSinceEpoch ?? sDate,
  //       endDate?.millisecondsSinceEpoch ?? eDate,
  //       _selectedWarehouse.id);
  //   //print("Hey Now");
  //   //print(_dessertsDataSource);
  //   // var res = await _dessertsDataSource?.getBestSellingTotal(
  //   //     );
  //   response = res?.data;
  //   setState(() {});
  //   print(response);
  // }

  void _calculateDateRange(String? range) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    //setState(() {
    switch (range) {
      case 'Today':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        break;
      case 'This Week':
        startDate = DateTime(
            firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
        endDate = DateTime(lastDayOfWeek.year, lastDayOfWeek.month,
            lastDayOfWeek.day, 23, 59, 59, 999);
        // startDate = firstDayOfWeek;
        // endDate = lastDayOfWeek;
        break;
      case 'This Month':
        startDate = DateTime(
            firstDayOfMonth.year, firstDayOfMonth.month, firstDayOfMonth.day);
        endDate = DateTime(lastDayOfMonth.year, lastDayOfMonth.month,
            lastDayOfMonth.day, 23, 59, 59, 999);

        break;
      case 'Custom Date Range':
        _selectCustomDateRange();
        break;
      default:
        startDate = null;
        endDate = null;
    }
    //});
    print("start");
    print(startDate);
    print(endDate);
    print(_selectedWarehouse.id);
    _dessertsDataSource!.filters('', _selectedWarehouse.id,
        startDate?.millisecondsSinceEpoch, endDate?.millisecondsSinceEpoch);
  }

  Future<void> _selectCustomDateRange() async {
    final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Column(
            children: [
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 400.0, minHeight: 300),
                child: child,
              )
            ],
          );
        });

    if (picked != null) {
      // setState(() {
      startDate =
          DateTime(picked.start.year, picked.start.month, picked.start.day);
      endDate = DateTime(
          picked.end.year, picked.end.month, picked.end.day, 23, 59, 59, 999);
      //});
      //

      _dessertsDataSource!.filters('', _selectedWarehouse.id,
          startDate?.millisecondsSinceEpoch, endDate?.millisecondsSinceEpoch);
      //_getBestSellingTotal();
    }
  }

  // String _formatMilliseconds(DateTime? date) {
  //   if (date == null) return '';
  //   return date.millisecondsSinceEpoch.toString();
  // }

  @override
  Widget build(BuildContext context) {
    //_getBestSellingTotal();
    //print("Build");
    bool isSmallScreen = MediaQuery.of(context).size.width >= 980;
    var dateFormat = DateFormat('dd/MM/yyyy');
    // Last ppage example uses extra API call to get the number of items in datasource
    if (_dataSourceLoading) return const SizedBox();
    //_getBestSellingTotal();
    return Padding(
      padding: EdgeInsets.only(
          top: 12, left: isSmallScreen ? 20 : 8, right: isSmallScreen ? 20 : 8),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Warehouse : ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
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
                            if (response != null &&
                                response.statusCode == 200) {
                              List<dynamic> data =
                                  response.data['data'] as List<dynamic>;
                              var all = {"id": -1, "name": "ALL"};
                              List<dynamic> warehouseList = [all, ...data];

                              return warehouseList
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
                            _selectedWarehouse = value!;
                            selectedRange = "Today";
                            _calculateDateRange("Today");
                            //_getSaleTotal();
                            //controller.selectedWarehouse.value = value!;
                          },
                          itemAsString: (WarehouseModel warehouse) =>
                              warehouse.name,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Date : ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: isSmallScreen ? 300 : 150,
                        child: DropdownSearch<String>(
                          dropdownBuilder: (context, selectedItem) {
                            //print(selectedItem);
                            return Text(startDate != null
                                ? selectedItem == "Today"
                                    ? "Today"
                                    : "${dateFormat.format(startDate!)} - ${dateFormat.format(endDate!)}"
                                : selectedItem!);
                          },
                          popupProps: const PopupProps.menu(
                            showSelectedItems: true,
                            constraints: BoxConstraints(maxHeight: 200),
                            searchDelay: Duration.zero,
                          ),
                          items: const [
                            'Today',
                            'This Week',
                            'This Month',
                            'Custom Date Range'
                          ],
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Choose",
                              // labelText: "Warehouse",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          selectedItem: selectedRange,

                          onChanged: (value) {
                            //final now = DateTime.now();
                            //setState(() {});
                            //_selectedWarehouse = value;
                            selectedRange = value;
                            _calculateDateRange(value);
                            //_g();
                            // startDate = DateTime(now.year, now.month, now.day);
                            // endDate = DateTime(
                            //     now.year, now.month, now.day, 23, 59, 59, 999);

                            // _dessertsDataSource!.filters(
                            //     '',
                            //     _selectedWarehouse!.id,
                            //     startDate?.millisecondsSinceEpoch,
                            //     endDate?.millisecondsSinceEpoch);
                            //controller.selectedWarehouse.value = value!;
                          },
                          //itemAsString: (WarehouseModel warehouse) => warehouse.name,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (response != null)
            SizedBox(
              height: 80,
              child: ResponsiveGridRow(children: [
                ResponsiveGridCol(
                  sm: 12,
                  md: 6,
                  lg: 3,
                  child: Card(
                    child: Text(
                        "totalBestSellingsAmount ${response?['totalBestSellingsAmount']}"),
                  ),
                ),
                ResponsiveGridCol(
                  sm: 12,
                  md: 6,
                  lg: 3,
                  child: Card(
                    child: Text(
                        "totalShippingAmount ${response?['totalShippingAmount'] ?? 0}"),
                  ),
                ),
                ResponsiveGridCol(
                  sm: 12,
                  md: 6,
                  lg: 3,
                  child: Card(
                    child: Text(
                        "totalQuantitySold ${response?['totalQuantitySold'] ?? 0}"),
                  ),
                ),
                ResponsiveGridCol(
                  sm: 12,
                  md: 6,
                  lg: 3,
                  child: Card(
                    child: Text("totalProfit ${response?['totalProfit'] ?? 0}"),
                  ),
                )
              ]),
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
                              _dessertsDataSource!.filters(
                                  '',
                                  _selectedWarehouse.id,
                                  startDate?.millisecondsSinceEpoch,
                                  endDate?.millisecondsSinceEpoch);

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
                      _dessertsDataSource!.filters(
                          value,
                          _selectedWarehouse.id,
                          startDate?.millisecondsSinceEpoch,
                          endDate?.millisecondsSinceEpoch);
                      //_dessertsDataSource!.filter = value;
                      //});
                    },
                  ),
                ),
                Flexible(flex: isSmallScreen ? 3 : 0, child: Container()),
                //const SizedBox(width: 8),
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
                            child: const Text("No Data"))),
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
                      pagerName: "BestSellingProduct",
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
