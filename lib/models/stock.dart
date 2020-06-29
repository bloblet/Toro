import 'package:hive/hive.dart';

import '../bloc/API.dart';

part 'stock.g.dart';

@HiveType(typeId: 1)
class Stock {
  @HiveField(0)
  double change;

  @HiveField(1)
  double changesPercentage;

  @HiveField(2)
  double dayHigh;

  @HiveField(3)
  double dayLow;

  @HiveField(4)
  String exchange;

  @HiveField(5)
  String name;

  @HiveField(6)
  double open;

  @HiveField(7)
  double price;

  @HiveField(8)
  String symbol;

  @HiveField(9)
  int quantity;

  Stock.fromJson(Map<String, dynamic> json) {
    change = json['change'];
    changesPercentage = json['changesPercentage'];
    dayHigh = json['dayHigh'];
    dayLow = json['dayLow'];
    exchange = json['exchange'];
    name = json['name'];
    open = json['open'];
    price = json['price'];
    symbol = json['symbol'];
    quantity = json['quantity'];
  }

  Stock();

  static Future<Stock> get(String symbol) async => API().fetchStock(symbol);
}
