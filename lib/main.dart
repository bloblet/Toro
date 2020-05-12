import 'package:flutter/material.dart';
import 'package:stockSimulator/widgets/portfoliov2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PyMarkets',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: PortfolioV2()
    );
  }
}
