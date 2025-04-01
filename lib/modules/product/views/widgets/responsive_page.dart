import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  final Widget desktopScreen;
  final Widget tabletScreen;
  final Widget mobileScreen;

  const ResponsivePage(
      {super.key,
      required this.desktopScreen,
      required this.tabletScreen,
      required this.mobileScreen});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define breakpoints for different screen sizes
        print(constraints.maxWidth);
        if (constraints.maxWidth >= 1024) {
          // Desktop screen - 3 columns
          return desktopScreen;
        } else if (constraints.maxWidth >= 600) {
          // Tablet screen - 2 columns
          return tabletScreen;
        } else {
          // Mobile screen - 1 column
          return mobileScreen;
        }
      },
    );
  }
}
