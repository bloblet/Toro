import 'package:flutter/material.dart';
import 'package:stockSimulator/portfolioCard.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
          children: <Widget>[
            PortfolioCard(
              
              child: ListTile(
                title: Container(color: Colors.black38, width: 2,),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text('AAPL'),
                  Text('Apple Inc.', style: TextStyle(fontSize: 11),)
                ]),
                trailing: Icon(Icons.arrow_drop_up, color: Colors.green),
              )
            ),

            SizedBox(height: 8),

            PortfolioCard(
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text('MSFT'),
                  Text('Microsoft Corporation', style: TextStyle(fontSize: 11),)
                ],),
                trailing: Icon(Icons.arrow_drop_down, color: Colors.red),
              )
            ),
          ]
        ),
    );
  }
}
