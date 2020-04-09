import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockSimulator/portfolioCard.dart';
import 'package:http/http.dart' as http;
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
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          color: Colors.black38,
       ),
        child: ListTile(
         title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Current Portfolio Value')
            ],
          ),
        ),
      )
    );
  }
}