import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:stockSimulator/widgets/login.dart';
// import './widgets/market.dart';
import './widgets/portfoliov2.dart';
import './widgets/stockInfo.dart';
import './widgets/summary.dart';
import 'widgets/ensure_hive_initialized.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: MaterialApp(
        // navigatorObservers: [routeObserver],
        title: 'PyMarkets',
        theme: ThemeData(
            primaryColor: Colors.green,
            accentColor: Color.fromRGBO(175, 76, 171, 1),
            primaryTextTheme: TextTheme(),
            scaffoldBackgroundColor: Colors.white),
        routes: {
          'summary': (_) => Summary(),
          'portfolio': (_) => PortfolioV2(),
          // 'market': (_) => Market(),
          'displayStock': (_) => StockInfo(),
        },
        home: EnsureHiveInitialized(
          loader: Scaffold(
            appBar: AppBar(),
            body: Container(
              child: CircularProgressIndicator(),
              width: 100,
              height: 100,
            ),
          ),
          child: Login(),
        ),
      ),
    );
  }
}
