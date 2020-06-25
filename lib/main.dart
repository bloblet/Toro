import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stockSimulator/models/datahive.dart';
import 'package:stockSimulator/widgets/welcome.dart';
// import './widgets/market.dart';
import './widgets/portfoliov2.dart';
import './widgets/stockInfo.dart';
import './widgets/summary.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/stock.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<Box<User>> init() async {
    try {
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(StockAdapter());
    } catch (_, __) {}

    await Hive.initFlutter('hive');
    return await Hive.openBox<User>('me');
  }

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
          'login': (_) => Welcome(),
        },
        home: FutureBuilder<Box<User>>(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // snapshot.data.put(
              //     'me',
              //     User()
              //       ..balance = 25000
              //       ..email = 'rastley@gmail.com'
              //       ..username = 'Rick Astley'
              //       ..token = '0MvQraAC6DxH0yB1wSsq4RCWO4m6g+cDmuzsafXqlDc='
              //       ..balanceHistory = {}
              //       ..inventory = []
              //       ..investedValue = 0
              //       ..lastUpdatedBalance =
              //           DateTime.fromMicrosecondsSinceEpoch(0)
              //       ..lastUpdatedBalanceHistory =
              //           DateTime.fromMicrosecondsSinceEpoch(0)
              //       ..lastUpdatedInventory =
              //           DateTime.fromMicrosecondsSinceEpoch(0)
              //       ..totalValue = 25000);
              snapshot.data.clear();
              if (snapshot.data.get('me') == null) {
                return Welcome();
              } else {
                User me = snapshot.data.get('me');

                // me.getMissedBalanceHistory();
                me.updateInventory();
                me.updateBalance();

                Timer.periodic(Duration(minutes: 1), (_) {
                  print('Updating');
                  me.updateInventory(force: true);
                  me.updateBalance(force: true);
                });

                return Summary();
              }
            } else {
              return Scaffold(
                body: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(),
                  ),
                ),
                appBar: AppBar(),
              );
            }
          },
        ),
      ),
    );
  }
}
