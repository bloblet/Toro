import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'components/login.dart';
import 'components/signup.dart';
import 'components/trade.dart';
import 'components/welcome.dart';
import 'components/portfoliov2.dart';
import 'components/stockInfo.dart';
import 'components/summary.dart';

import 'models/stock.dart';
import 'models/user.dart';

void main() {
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

  Future<Box<User>> init(BuildContext context) async {
    if (!hasInitialized) {
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

      OneSignal.shared.init("f88e9b0e-3c0b-4706-a032-080871499e12");
      OneSignal.shared
          .setInFocusDisplayType(OSNotificationDisplayType.notification);
      OneSignal.shared
          .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
            final symbol = result.notification.payload.additionalData['symbol'];
          });
      // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
      // await OneSignal.shared
      //     .promptUserForPushNotificationPermission(fallbackToSettings: true);

      print('Initializing hive');
      await Hive.initFlutter();
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(StockAdapter());
      // If you need to test logging in, uncomment \/
      await Hive.deleteBoxFromDisk('me');
      me = await Hive.openBox<User>('me');
      hasInitialized = true;
      await Future.delayed(Duration(seconds: 1));
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
        'login': (_) => Welcome(),
        'loginScreen': (_) => LoginScreen(),
        'signupScreen': (_) => SignUpScreen(),
        'trade': (_) => TradeScreen(),
      },
      home: FutureBuilder<Box<User>>(
        future: initializer.init(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.get('me') == null) {
              return Welcome();
            } else {
              User me = snapshot.data.get('me');

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
