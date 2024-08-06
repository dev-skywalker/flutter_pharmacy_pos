import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget desktopLayout;
  final Widget tabletLayout;
  final Widget phoneLayout;
  const ResponsiveWidget(
      {super.key,
      required this.desktopLayout,
      required this.tabletLayout,
      required this.phoneLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return desktopLayout;
        } else if (constraints.maxWidth > 800 && constraints.maxWidth <= 1200) {
          return tabletLayout;
        } else {
          return phoneLayout;
        }
      },
    );
  }
}
