import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'serializer.dart';

class Stock {
  int avgVolume;
  double change;
  double changesPercentage;
  double dayHigh;
  double dayLow;
  String earningsAnnouncement;
  double eps;
  String exchange;
  double marketCap;
  String name;
  double openValue;
  double pe;
  double previousClose;
  double price;
  double priceAvg200;
  double priceAvg50;
  int sharesOutstanding;
  String symbol;
  int timestamp;
  int volume;
  double yearHigh;
  double yearLow;
  int quantity;
  DateTime fetched;
  Map<String, dynamic> raw;

  Stock(Map info) {
    this.raw = info;
    this.avgVolume = info['avgVolume'];
    this.change = double.tryParse(info['change'].toString());
    this.changesPercentage = info['changesPercentage'];
    this.dayHigh = info['dayHigh'];
    this.dayLow = info['dayLow'];
    this.earningsAnnouncement = info['earningsAnnouncement'];
    this.eps = info['eps'];
    this.exchange = info['exchange'];
    this.marketCap = info['marketCap'];
    this.name = info['name'];
    this.openValue = info['open'];
    this.pe = info['pe'];
    this.previousClose = info['previousClose'];
    this.price = info['price'];
    this.priceAvg200 = info['priceAvg200'];
    this.priceAvg50 = info['priceAvg50'];
    this.sharesOutstanding = info['sharesOutstanding'];
    this.symbol = info['symbol'];
    this.timestamp = info['timestamp'];
    this.volume = info['volume'];
    this.yearHigh = info['yearHigh'];
    this.yearLow = info['yearLow'];
    if (info.containsKey('quantity')) {
      this.quantity = info['quantity'];
    }
    if (info.containsKey('lastFetched')) {
      this.fetched = info['lastFetched'];
    }
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      var raw = prefs.getString('stocks');
      if (raw == null) {
        raw = '{}';
      }
    });
  }
}
