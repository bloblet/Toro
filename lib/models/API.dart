import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './stock.dart';

class API {
  static API _cache = API._internal();
  static Map<String, Stock> _stockCache = {};
  static List<Stock> portfolioCache = [];
  static DateTime lastFetchedPortfolio = DateTime.fromMicrosecondsSinceEpoch(0);
  static int userID;

  factory API() {
    return _cache;
  }

  API._internal();

  Future<Stock> _fetchStock(String symbol) async {
    return Stock(jsonDecode((await http.get('http://bloblet.com')).body));
  }

  Future<void> _saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

  }

  Future<Stock> getStock(String symbol) async {
    if (_stockCache.containsKey(symbol) &&
        DateTime.now()
            .difference(_stockCache[symbol].fetched)
            .compareTo(Duration(minutes: 15))
            .isNegative) {
      return _stockCache[symbol];
    }
    return await this._fetchStock(symbol);
  }

  Future<List<Stock>> _fetchPortfolio() async {
    List<Stock> stocks = [];
    List<Object> body = jsonDecode(
        (await http.get('http://bloblet.com:4000/dummy/portfolio')).body);

    for (Map<String, Object> stock in body) {
      stocks.add(Stock(stock));
    }
    portfolioCache = stocks;
    lastFetchedPortfolio = DateTime.now();
    return stocks;
  }

  Future<List<Stock>> getPortfolio() async {
    // if (userID == null) {
    //   throw NotLoggedInError;
    // }
    if (portfolioCache == null ||
        !DateTime.now()
            .difference(lastFetchedPortfolio)
            .compareTo(Duration(minutes: 1))
            .isNegative) {
      return this._fetchPortfolio();
    } else {
      return portfolioCache;
    }
  }

  // Future<User> register(username, token) {
  //   http.post('http://bloblet.com',
  //       body: {'username': username, 'token': token});
  // }
}

class NotLoggedInError implements Exception {
  String cause;
  NotLoggedInError(this.cause);
}
