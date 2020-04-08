import 'package:flutter/material.dart';

class PortfolioCard extends StatelessWidget {
  final Widget child;

  PortfolioCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.grey[300],
      ),
      child: this.child,
    );
  }
}
