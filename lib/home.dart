import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockSimulator/portfolioCard.dart';
import 'package:http/http.dart' as http;
import 'homeCard.dart';
import 'homeTopCard.dart';
import 'models/stock.dart';

class Home extends StatelessWidget {
  String id;

  Home(){
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      // For right now, this will be null.
      this.id = prefs.getString('id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          HomeTopCard(),
        ],),
        HomeCard(),
        HomeCard(),
        HomeCard(),
      ],)
    );
  }
}