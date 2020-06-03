import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:stockSimulator/widgets/market.dart';
// import 'package:stockSimulator/widgets/portfoliov2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return FeatureDiscovery(
    //   child:
    return MaterialApp(
        title: 'PyMarkets',
        theme: ThemeData(
          primaryColor: Colors.green,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Market());
  }
}
