import 'package:flutter/material.dart';
import 'settings.dart';
import 'tabs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Tabs());
  }
}
