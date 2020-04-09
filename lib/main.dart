import 'package:flutter/material.dart';
import 'settings.dart';
import 'tabs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PyMarkets',
        theme: ThemeData(
          primaryTextTheme: TextTheme(body1: TextStyle(fontFamily: 'Raleway')),
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Tabs(),
    );
  }
}
