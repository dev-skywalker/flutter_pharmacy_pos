import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ProductReportPage extends StatelessWidget {
  const ProductReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
            sm: 12, // 1 column on mobile
            md: 6, // 2 columns on tablet
            lg: 4, // 3 columns on desktop
            child: Container(
              height: 100,
              color: Colors.red,
              child: Center(child: Text('Column 1')),
            ),
          ),
          ResponsiveGridCol(
            sm: 12, // 1 column on mobile
            md: 6, // 2 columns on tablet
            lg: 4, // 3 columns on desktop
            child: Container(
              height: 130,
              color: Colors.green,
              child: Center(child: Text('Column 2')),
            ),
          ),
          ResponsiveGridCol(
            sm: 12, // 1 column on mobile
            md: 6, // 2 columns on tablet
            lg: 4, // 3 columns on desktop
            child: Container(
              height: 300,
              color: Colors.blue,
              child: Center(child: Text('Column 3')),
            ),
          ),
        ],
      ),
    );
  }
}
