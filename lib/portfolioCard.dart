import 'package:flutter/material.dart';

import 'models/stock.dart';

class PortfolioCard extends StatelessWidget {
  final Stock stock;

  PortfolioCard(this.stock);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ShapeDecoration(
          shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.grey[300],
        ),
        child: ListTile(
          title: Expanded(
            child: Container(
              color: Colors.black38,
              width: 2,
            ),
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('AAPL'),
              Text(
                'Apple Inc.',
                style: TextStyle(fontSize: 11),
              )
            ]),
          trailing: Icon(Icons.arrow_drop_up, color: Colors.green),
        ));
  }
}
