import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockSimulator/portfolio.dart';

import 'models/API.dart';

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
          primaryTextTheme: TextTheme(body1: TextStyle(fontFamily: 'Raleway')),
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: DefaultTabController(
          initialIndex: 1,
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                title: Text('\$0.00'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.moneyBill),
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.5),
                      builder: (BuildContext _) {
                        return (API.portfolioCache == null)
                            ? FutureBuilder(
                                future: API().getPortfolio(),
                                builder:
                                    (BuildContext _, AsyncSnapshot snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.done:
                                      {
                                        return Chart(snapshot.data);
                                      }

                                      break;
                                    default:
                                      {
                                        return Container(
                                            width: 100,
                                            height: 100,
                                            child: CircularProgressIndicator());
                                      }
                                  }
                                },
                              )
                            : Chart(API.portfolioCache);
                      },
                    ),
                  )
                ],
              ),
              body: TabBarView(
                children: <Widget>[
                  Portfolio(),
                  Text('Home'),
                  Text('Market')
                  //Home(),
                  //Market()
                ],
              ),
              bottomNavigationBar: TabBar(
                labelColor: Colors.blueGrey[400],
                tabs: <Widget>[
                  Tab(
                      icon: FaIcon(FontAwesomeIcons.shoppingBag),
                      child: Text('Portfolio')),
                  Tab(icon: FaIcon(FontAwesomeIcons.home), child: Text('Home')),
                  Tab(
                      icon: FaIcon(FontAwesomeIcons.exchangeAlt),
                      child: Text('Exchange')),
                ],
              )),
        ));
  }
}
