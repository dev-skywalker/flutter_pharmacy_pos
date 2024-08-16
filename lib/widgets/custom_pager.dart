import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class PageNumber extends StatefulWidget {
  const PageNumber({
    super.key,
    required PaginatorController controller,
  }) : _controller = controller;

  final PaginatorController _controller;

  @override
  PageNumberState createState() => PageNumberState();
}

class PageNumberState extends State<PageNumber> {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget._controller.addListener(update);
  }

  @override
  void dispose() {
    widget._controller.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Checking instance id to see if build is called
    // on different ones
    // Due to some reasons when using this widget
    // with AsyncPaginatedDatatable2 the widget is instatiotaed once
    // though it's state is created 3 times upon first loading
    // of the Custom pager example
    // print(identityHashCode(this));
    return Text(widget._controller.isAttached
        ? 'Page: ${1 + ((widget._controller.currentRowIndex + 1) / widget._controller.rowsPerPage).floor()} of '
            '${(widget._controller.rowCount / widget._controller.rowsPerPage).ceil()}'
        : 'Page: x of y');
  }
}

class CustomPager extends StatefulWidget {
  const CustomPager(
      {super.key, required this.pagerName, required this.controller});

  final PaginatorController controller;
  final String pagerName;

  @override
  CustomPagerState createState() => CustomPagerState();
}

class CustomPagerState extends State<CustomPager> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate current page
    int currentPage =
        (widget.controller.currentRowIndex ~/ widget.controller.rowsPerPage) +
            1;

    // Calculate total pages
    int totalPages =
        (widget.controller.rowCount + widget.controller.rowsPerPage - 1) ~/
            widget.controller.rowsPerPage;

    // Determine if buttons should be enabled
    bool isFirstPage = widget.controller.currentRowIndex == 0;
    bool isLastPage =
        widget.controller.currentRowIndex + widget.controller.rowsPerPage >=
            widget.controller.rowCount;

    // skip this build pass
    if (!widget.controller.isAttached) return const SizedBox();
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(-2, -2), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text("${widget.controller.rowCount} ${widget.pagerName}"),
          const Spacer(),
          IconButton(
            onPressed:
                isFirstPage ? null : () => widget.controller.goToFirstPage(),
            icon: const Icon(Icons.skip_previous),
            color: isFirstPage ? Colors.grey : Colors.black,
          ),
          IconButton(
            onPressed:
                isFirstPage ? null : () => widget.controller.goToPreviousPage(),
            icon: const Icon(Icons.chevron_left_sharp),
            color: isFirstPage ? Colors.grey : Colors.black,
          ),
          IconButton(
            onPressed:
                isLastPage ? null : () => widget.controller.goToNextPage(),
            icon: const Icon(Icons.chevron_right_sharp),
            color: isLastPage ? Colors.grey : Colors.black,
          ),
          IconButton(
            onPressed:
                isLastPage ? null : () => widget.controller.goToLastPage(),
            icon: const Icon(Icons.skip_next),
            color: isLastPage ? Colors.grey : Colors.black,
          ),
          const Spacer(),
          Text("Page $currentPage of $totalPages"),
        ],
      ),
    );
  }
}
