import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive/hive.dart';
import 'widgets/login.dart';
import 'widgets/signup.dart';
import 'widgets/trade.dart';
import 'widgets/welcome.dart';
import 'widgets/portfoliov2.dart';
import 'widgets/stockInfo.dart';
import 'widgets/summary.dart';
import 'models/stock.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class HiveInitializer {
  static HiveInitializer _cache = HiveInitializer._();
  HiveInitializer._();
  factory HiveInitializer() {
    return _cache;
  }

  Box<User> me;
  static bool hasInitialized = false;
  static bool startedTimer = false;
  static Timer timer;

  void startTimer() {
    if (!startedTimer) {
      User user = me.get('me');
      print('Starting timer...');
      timer = Timer.periodic(Duration(minutes: 1), (_) {
        print('Updating');
        user.getMissedBalanceHistory();
        user.updateInventory(force: true);
        user.updateBalance(force: true);
      });
      startedTimer = true;
    }
  }

  Future<Box<User>> init() async {
    if (!hasInitialized) {
      print('Initializing hive');
      await Hive.initFlutter();
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(StockAdapter());
      // If you need to test logging in, uncomment \/
      // await Hive.deleteBoxFromDisk('me');
      me = await Hive.openBox<User>('me');
      hasInitialized = true;
      await Future.delayed(Duration(seconds: 1));
    }
    return me;
  }
}

class MyApp extends StatelessWidget {
  final HiveInitializer initializer = HiveInitializer();

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
          'loginScreen': (_) => LoginScreen(),
          'signupScreen': (_) => SignUpScreen(),
          'trade': (_) => TradeScreen(),
        },
        home: FutureBuilder<Box<User>>(
          future: initializer.init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.get('me') == null) {
                return Welcome();
              } else {
                User me = snapshot.data.get('me');

                me.getMissedBalanceHistory();
                me.updateInventory();
                me.updateBalance();
                HiveInitializer().startTimer();

                return Summary();
              }
            } else {
              return Scaffold(
                body: Center(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/temp_logo.png'),
                      height: 150.0,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
