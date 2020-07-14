import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'components/login.dart';
import 'components/signup.dart';
import 'components/trade.dart';
import 'components/portfoliov2.dart';
import 'components/stockInfo.dart';
import 'components/summary.dart';
import 'components/intro.dart';

import 'initializer.dart';
import 'models/user.dart';
import 'utils.dart';

void main() {
  runApp(MyApp());
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
            if (snapshot.data?.get('me') == null) {
              log('No user stored, going to login...');
              return Intro();
            } else {
              log('Found user!');
              User me = snapshot.data.get('me');
              initializer.initOnesignal(me);

              log('Updating info');
              me.getMissedBalanceHistory();
              me.updateInventory();
              me.updateBalance();

              initializer.startTimer();

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
