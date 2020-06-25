import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pedantic/pedantic.dart';
import '../bloc/API.dart';
import 'datahive.dart';
import 'stock.dart';

part 'user.g.dart';

const updateInventoryInterval = const Duration(minutes: 1);
const updateBalanceInterval = const Duration(minutes: 1);

@HiveType(typeId: 0)
class User extends HiveObject {
  static User get me {
    final me = DataHive()?.me?.get('me');
    if (me == null) {
      print('Me is null');
      return User();
    } else {
      return me;
    }
  }

  User();

  @HiveField(0)
  String username;

  @HiveField(1)
  double balance;

  @HiveField(2)
  DateTime lastUpdatedBalance;

  @HiveField(3)
  Map<DateTime, double> balanceHistory;

  @HiveField(4)
  DateTime lastUpdatedBalanceHistory;

  @HiveField(5)
  List<Stock> inventory;

  @HiveField(6)
  DateTime lastUpdatedInventory;

  @HiveField(7)
  String firebaseToken;

  @HiveField(8)
  String avatarURL;

  @HiveField(9)
  String token;

  @HiveField(10)
  String email;

  @HiveField(11)
  double investedValue;

  @HiveField(12)
  double totalValue;

  String get formattedBalance {
    final f = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return f.format(balance);
  }

  double get change {
    final now = DateTime.now();
    final history = balanceHistory.keys.where((element) => now.day == element.month && now.month == element.month && now.year == element.year);
    final open = balanceHistory[history];
    return investedValue - open;
  }

  String get formattedChange {
    final f = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return f.format(change);
  }

  Future<void> updateInventory({bool force}) async {
    final now = DateTime.now();
    if (force == true ||
        now
                .difference(lastUpdatedInventory)
                .compareTo(updateInventoryInterval) >=
            0) {
      inventory = await API().fetchPortfolio(token, email);
      lastUpdatedInventory = now;
      investedValue = 0;

      for (Stock stock in inventory) {
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
      balance = await API().fetchBalance(token, email);
      lastUpdatedBalance = now;
      totalValue = investedValue + balance;
      unawaited(save());
    }
  }

  Future<void> getMissedBalanceHistory() async {
    final missedBalances = await API()
        .fetchBalanceHistory(lastUpdatedBalanceHistory, token, email);
    balanceHistory.addAll(missedBalances);
    List<DateTime> sorted = missedBalances.keys.toList()..sort();
    lastUpdatedInventory = sorted.last;
    unawaited(save());
  }

  static Future<bool> signIn(
      {@required String email, @required String password}) async {
    try {
      final user = await API().signIn(email, password);
      await DataHive().me.put('me', user);
      return true;
    } on APIError {
      return false;
    }
  }

  static Future<bool> signUp(
      {@required String email,
      @required String password,
      @required String username}) async {
    try {
      final user = await API().signUp(email, password, username);
      await DataHive().me.put('me', user);
      return true;
    } on APIError {
      return false;
    }
  }

  Future<void> sellStock(String symbol, int quantity) async {
    await API().sellStock(symbol, quantity, token, email);
    unawaited(updateBalance(force: true));
    unawaited(updateInventory(force: true));
    unawaited(getMissedBalanceHistory());
  }

  Future<void> buyStock(String symbol, int quantity) async {
    await API().buyStock(symbol, quantity, token, email);
    unawaited(updateBalance(force: true));
    unawaited(updateInventory(force: true));
    unawaited(getMissedBalanceHistory());
  }
}
