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
        Padding(
          padding: const EdgeInsets.all(12),
          child: Center(child: Text('Dashboard',style: TextStyle(fontSize: 35),),),
        ),
        Divider(thickness: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

          HomeTopCard([
            Center(child: Text('\$10,000,000', style: TextStyle(fontSize: 15),)),
            Divider(color: Colors.black38,),
            Center(child: Text('Available to Trade', style: TextStyle(fontSize: 13),),),
            Center(child: Text('\$1,000,000', style: TextStyle(fontSize: 15),))
          ]),
          HomeTopCard([
            Center(child: Text('Day Change')),
            Divider(color: Colors.black38,),
            Center(child: Text('\$349,509 (2.54%)', style: TextStyle(fontSize: 15)))            
          ]),
        ],),
        FutureBuilder(
          future: http.get('http://bloblet.com:4000/portfolio?id=${1}'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData) {
              return  Column(
                children: <Widget>[
                  HomeCard(),
                  HomeCard(),
                  HomeCard(),
                ],
              );
            }
            else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Container(
              height: MediaQuery.of(context).size.width/4, 
              width: MediaQuery.of(context).size.width/4, 
              child: CircularProgressIndicator());
          }
        ),
       
      ],)
    );
  }
}