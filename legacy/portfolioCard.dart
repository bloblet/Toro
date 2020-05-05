import 'package:flutter/material.dart';

import 'models/stock.dart';

class PortfolioCard extends StatelessWidget {
  final Stock stock;

  PortfolioCard(this.stock);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
          decoration: ShapeDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.grey[300],
          ),
          child: ListTile(
              
            title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Symbol
                  Text(this.stock.symbol),
                  Text(
                    // Name
                    this.stock.name,
                    style: TextStyle(fontSize: 11),
                  )
                ]),
            // Change indicator
            trailing: (this.stock.changesPercentage > 0)
                ? Icon(Icons.arrow_upward, color: Colors.green)
                : Icon(Icons.arrow_downward, color: Colors.red),
          )),
    );
  }
}
