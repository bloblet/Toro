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
      padding: const EdgeInsets.all(4),
      child:
        Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

          HomeTopCard([
            Center(child: Text('\$1,000,000 cash')),
            Divider(color: Colors.black38,),
            Center(child: Text('\$10,000,000 total')),
          ]),
          HomeTopCard([
            Center(child: Text('Days Change')),
            
          ]),
        ],),
        HomeCard(),
        HomeCard(),
        HomeCard(),
      ],)
    );
  }
}