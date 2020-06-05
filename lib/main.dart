import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:stockSimulator/widgets/market.dart';
import 'package:stockSimulator/widgets/portfoliov2.dart';
// import 'package:stockSimulator/widgets/portfoliov2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
        child: MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'PyMarkets',
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        'portfolio': (_) => PortfolioV2(),
        'market': (_) => Market()
      },

      home: PortfolioV2(),
    ));
  }
}
