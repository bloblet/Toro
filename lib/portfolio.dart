import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockSimulator/portfolioCard.dart';
import 'package:http/http.dart' as http;
import 'models/stock.dart';

class Portfolio extends StatelessWidget {
  String id;

  Portfolio() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      this.id = prefs.getString('id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Get returns a future that we can use, and this builds when it gets it.
      future: http.get('http://bloblet.com:4000/portfolio?id=${this.id}'),

      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // We can tell if the data isnt fully sent yet, since this is a somewhat large datapack, this is good.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }

        List<Stock> data = [];
        Map stocks = jsonDecode(snapshot.data.body);
        stocks.forEach((key, value) {
          data.add(Stock(value));
        });

        data.sort((Stock a, Stock b) => a.symbol.compareTo(b.symbol));

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int position) => PortfolioCard(data[position])
          )
        );
      }
    );
  }
}
