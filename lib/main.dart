import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:device_info/device_info.dart';

import 'components/login.dart';
import 'components/signup.dart';
import 'components/trade.dart';
import 'components/portfoliov2.dart';
import 'components/stockInfo.dart';
import 'components/summary.dart';

import 'models/stock.dart';
import 'models/user.dart';
import 'utils.dart';

void main() {
  // Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

// TODO move to its own file
class AppInitializer {
  static AppInitializer _cache = AppInitializer._();
  AppInitializer._();
  factory AppInitializer() {
    return _cache;
  }

  Box<User> me;
  static bool hasInitialized = false;
  static bool startedTimer = false;
  static Timer timer;

  void startTimer() {
    if (!startedTimer) {
      User user = me.get('me');
      log('Starting timer');
      timer = Timer.periodic(Duration(minutes: 1), (_) {
        log('Updating');
        user.getMissedBalanceHistory();
        user.updateInventory(force: true);
        user.updateBalance(force: true);
      });
      startedTimer = true;
    }
  }

  Future<Box<User>> init(BuildContext context) async {
    if (!hasInitialized) {
      final id = await DeviceInfoPlugin().androidInfo;

      log('ID is ${id.androidId}');

      final start = DateTime.now();
      log('Starting initialization');
      FirebaseAdMob.instance
          .initialize(appId: "ca-app-pub-6084013412591482~5356667331")
          .then(
              (v) => log('Firebase done... ${msDiff(DateTime.now(), start)}ms'));

      final partsOfOneSignal = [];

      OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
        // TODO
        final symbol = result.notification.payload.additionalData['symbol'];
      });

      OneSignal.shared
          .setLogLevel(OSLogLevel.fatal, OSLogLevel.none)
          .then((value) {
        partsOfOneSignal.add(true);
        if (partsOfOneSignal.length == 3) {
          log('OneSignal done... ${msDiff(DateTime.now(), start)}ms');
        }
      });

      OneSignal.shared
          .init("f88e9b0e-3c0b-4706-a032-080871499e12")
          .then((value) {
        partsOfOneSignal.add(true);
        if (partsOfOneSignal.length == 3) {
          log('OneSignal done... ${msDiff(DateTime.now(), start)}ms');
        }
      });
      OneSignal.shared
          .setInFocusDisplayType(OSNotificationDisplayType.notification)
          .then((value) {
        partsOfOneSignal.add(true);
        if (partsOfOneSignal.length == 3) {
          log('OneSignal done... ${msDiff(DateTime.now(), start)}ms');
        }
      });

      await Hive.initFlutter();
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(StockAdapter());
      // If you need to test logging in, uncomment the next two lines
      // await Hive.deleteBoxFromDisk('me');
      // log('Deleted me box', type: Severity.warning);

      me = await Hive.openBox<User>('me');
      log('Hive done... ${msDiff(DateTime.now(), start)}ms');
      hasInitialized = true;
    }
    return me;
  }
}

class MyApp extends StatelessWidget {
  final AppInitializer initializer = AppInitializer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PyMarkets',
      theme: ThemeData(
          primaryColor: Colors.green,
          accentColor: Color.fromRGBO(175, 76, 171, 1),
          primaryTextTheme: TextTheme(),
          scaffoldBackgroundColor: Colors.white,
          cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
      routes: {
        // TODO use static methods on widgets for routes
        'summary': (_) => Summary(),
        'portfolio': (_) => PortfolioV2(),
        'displayStock': (_) => StockInfo(),
        'loginScreen': (_) => LoginScreen(),
        'signupScreen': (_) => SignUpScreen(),
        'trade': (_) => TradeScreen(),
      },
      // TODO Pack into a page
      home: FutureBuilder<Box<User>>(
        future: initializer.init(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.get('me') == null) {
              log('No user stored, going to login...');
              return SignUpScreen();
            } else {
              log('Found user!');
              User me = snapshot.data.get('me');
              log('Updating info');
              me.getMissedBalanceHistory();
              me.updateInventory();
              me.updateBalance();

              AppInitializer().startTimer();

              return Summary();
            }
          } else {
            return Scaffold(
              body: Center(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('assets/images/temp_logo.png'),
                    height: 150.0,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
