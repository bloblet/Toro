import 'package:toro_models/toro_models.dart' as models;

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pedantic/pedantic.dart';
import 'package:toro_models/toro_models.dart' hide User;
import '../bloc/API.dart';
import '../initializer.dart';
import '../main.dart';

const updateInventoryInterval = const Duration(minutes: 1);
const updateBalanceInterval = const Duration(minutes: 1);

class User extends models.User {
  static DateTime lastUpdatedBalance;
  FetchCache get fetchCache => AppInitializer?.fetchCache?.get('fetchCache');
  static double investedValue;
  static double totalValue;

  static User get me {
    final me = AppInitializer?.me?.get('me');
    if (me == null) {
      print('Me is null');
      return User();
    } else {
      return me;
    }
  }

  String get formattedBalance {
    final f = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return f.format(balance);
  }

  double get change {
    // final now = DateTime.now();
    // final history = balanceHistory.keys.where((element) => now.day == element.month && now.month == element.month && now.year == element.year);
    // final open = balanceHistory[history];
    return 1;
  }

  String get formattedChange {
    final f = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return f.format(change);
  }

  DateTime get lastUpdatedStocks => fetchCache.lastUpdatedStocks;

  set lastUpdatedStocks(DateTime newValue) {
    final f = fetchCache;
    f.lastUpdatedStocks = newValue;
    f.save();
  }

  Future<void> updateInventory({bool force}) async {
    final now = DateTime.now();
    if (force == true ||
        now.difference(lastUpdatedStocks).compareTo(updateInventoryInterval) >=
            0) {
      final unparsedStocks = await API().fetchPortfolio(token, id);
      final stocks = {};

      for (String stock in unparsedStocks.keys) {
        stocks[stock] = unparsedStocks[stock].quantity;
      }

      lastUpdatedStocks = now;
      investedValue = 0;

      for (Stock stock in unparsedStocks.values) {
        investedValue += stock.price * stock.quantity;
      }
      totalValue = balance + investedValue;
      unawaited(save());
    }
  }

  Future<void> updateBalance({bool force}) async {
    final now = DateTime.now();
    if (force == true ||
        now.difference(lastUpdatedBalance).compareTo(updateBalanceInterval) >=
            0) {
      balance = await API().fetchBalance(token, id);
      lastUpdatedBalance = now;
      totalValue = investedValue + balance;
      unawaited(save());
    }
  }

  Future<void> getMissedBalanceHistory() async {
    // final missedBalances = await API()
    //     .fetchBalanceHistory(lastUpdatedBalanceHistory, token, id);
    // balanceHistory.addAll(missedBalances);
    // if (missedBalances.length == 0) {
    //   lastUpdatedInventory = DateTime.now();
    // } else {
    //   List<DateTime> sorted = missedBalances.keys.toList()..sort();

    //   lastUpdatedInventory = sorted.last;
    // }
    // unawaited(save());
  }

  static Future<bool> signIn(
      {@required String email, @required String password}) async {
    try {
      final user = await API().signIn(email, password);
      await AppInitializer.me.put('me', user);
      AppInitializer().startTimer();
      return true;
    } on APIError {
      return false;
    }
  }

  static Future<bool> signUp({@required String username}) async {
    try {
      final user = await API().signUp(username);
      await AppInitializer.me.put('me', user);
      AppInitializer().startTimer();
      return true;
    } on APIError {
      return false;
    }
  }

  Future<void> sellStock(String symbol, int quantity) async {
    await API().sellStock(symbol, quantity, token, id);
    unawaited(updateBalance(force: true));
    unawaited(updateInventory(force: true));
    unawaited(getMissedBalanceHistory());
  }

  Future<void> buyStock(String symbol, int quantity) async {
    await API().buyStock(symbol, quantity, token, id);
  }
}
