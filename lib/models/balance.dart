import 'package:flutter/widgets.dart';

import '../bloc/API.dart';
import 'stock.dart';

class BalanceEvent {
  double balance;
  double totalValue;
  double stockValue;
  ConnectionState state;
  BalanceEvent(this.balance, this.totalValue, this.stockValue, this.state);

  static BalanceEvent cached() {
    double balance = API.balanceCache;
    if (balance == null) {
      return BalanceEvent(0, 0, 0, ConnectionState.none);
    }
    List<Stock> portfolio = API.portfolioCache;
    double totalValue = balance;

    for (Stock stock in portfolio) {
      totalValue += stock.price * stock.quantity;
    }
    return BalanceEvent(balance, totalValue, totalValue - balance, ConnectionState.none);
  }
  static Future<BalanceEvent> getBalance() async {
    double balance = await API().getBalance();
    double totalValue = await API().totalBalance();
    double stockValue = totalValue - balance;
    return BalanceEvent(balance, totalValue, stockValue, ConnectionState.done);
  }
}