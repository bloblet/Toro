import 'package:flutter/material.dart';
import 'tabScaffold.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabScaffold(
          body: Container(
        child: Text('Testing coolness'),
      ),
    );
  }
}