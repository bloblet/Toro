import 'package:flutter/material.dart';
import 'package:stockSimulator/widgets/portfoliov2.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int pos = 0;

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
