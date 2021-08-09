import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tab;
  final Widget desktop;

  const Responsive({Key key, this.mobile, this.tab, this.desktop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        if (constraints.maxWidth < 648) {
          return mobile;
        } else if (constraints.maxWidth < 1100) {
          return tab;
        } else {
          return desktop;
        }
      },
    );
  }
}
