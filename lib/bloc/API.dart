import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/stock.dart';
import 'package:hive/hive.dart';
class HistoryStock {}
/// Factory API class, no need to store it anywhere.
/// For now, this is all a dummy API, uncomment the lines prefixed by
/// `// DUMMY`, and it will be a fully working API, as long as the counterpart is...
class API {
  /// Cache of the API.  I don't want to worry about passing this around in the
  /// widget tree, so this will stay.
  static API _cache = API._();

  /// Cache of the stocks we know of.
  /// To not call the API every other milisecond, we ought to cache stocks,
  /// especially since I plan to add ratelimits to the other API soon.
  /// Renews every 15 minutes, if it is requested.
  static const Duration _stockCacheRenewTime = Duration(minutes: 8);
  static Map<String, Stock> _stockCache = {};

  /// Cache of our portfolio, the stocks that the user owns.
  /// Renews every 15 minutes.
  static const Duration _portfolioCacheRenewTime = Duration(minutes: 8);
  static List<Stock> portfolioCache;
  static DateTime _lastFetchedPortfolio =
      DateTime.fromMicrosecondsSinceEpoch(0);

  /// Cache of our balance.
  /// Arguably, this is more important than stocks or our portfolio, and could change faster.
  /// Renews every 1 minute.
  ///
  static const Duration _balanceCacheRenewTime = Duration(minutes: 1);
  static double balanceCache;
  static DateTime _lastFetchedBalance = DateTime.fromMicrosecondsSinceEpoch(0);

  LazyBox<Map<DateTime, HistoryStock>> historyStockBox;

  /// Current location of the stocks API
  String _apiEndpoint = 'http://pn.bloblet.com:9876/';

  // Token to authenticate [userID] for.
  String _token =
      "kS+RLoGUsPw5STYBFmzY0Q8Zz0pIgh5YIGByNZ0VYEw=";

  String email = 'fpiesquared@gmail.com';

  /// Default factory constructor for the singleton class
  factory API() {
    return _cache;
  }

  /// This is a constructor, so we can initialize our class in the static member [_cache]
  /// This should only run once, at the start of our app.
  API._() {
    init();
  }

  Future<void> init() async {
    final path = await getApplicationSupportDirectory();
    Hive.init(path.path);
    initStockHistory();
  }

  void _checkResponse(http.Response res) {
    if (res.statusCode != 200) {
      throw APIError(
          '[${res.statusCode}]: Reason: ${res.reasonPhrase ?? 'None'} Body: ${res.body ?? 'None'}');
    }
  }

  /// Checks dateTime to see if whatever thing we are comparing should be fetched.
  bool _shouldFetch(
    DateTime dateTime, {
    Duration duration = const Duration(minutes: 15),
  }) {
    return !DateTime.now().difference(dateTime).compareTo(duration).isNegative;
  }


  /// Gets the stock history box
  Future<void> initStockHistory() async {
    historyStockBox = await Hive.openLazyBox('stockHistory');
  }

  /// Queries the API for [symbol], and returns the corresponding stock.
  Future<Stock> _fetchStock(String symbol) async {
    final response = await http.get('${_apiEndpoint}stock');
    _checkResponse(response);

    return Stock(jsonDecode(response.body));
  }

  /// Fetches the latest portfolio from the API and returns a sorted list of the stocks.
  Future<List<Stock>> _fetchPortfolio() async {
    final List<Stock> stocks = [];
    final response = await http.post(
      '${_apiEndpoint}portfolio',
      body: jsonEncode({
        'token': _token,
        'email': email
      }),
      headers: {'Content-Type': 'application/json'}
    );
    _checkResponse(response);

    _lastFetchedPortfolio = DateTime.now();

    final List body = jsonDecode(response.body);
    if (body.length == 0){
      return [];
    } else if (body.length == 1) {
      return [Stock(body[0])];
    }

    body.sort((stock1, stock2) => stock1['symbol'].compareTo(stock2['symbol']));

    for (Map<String, Object> stock in body) {
      stocks.add(Stock(stock));
    }

    return stocks;
  }

  Future<void> updatePortfolioGraph() {

  }

  /// Fetches the user's latest balance from the server.
  Future<double> _fetchBalance() async {
    final response = await http.post(
      '${_apiEndpoint}balance',
      body: jsonEncode({
        'token': _token,
        'email': email
      }),
      headers: {'Content-Type': 'application/json'}
    );
    _checkResponse(response);
    final balance = double.parse(response.body);

    return balance;
  }

  /// Gets a stock.
  ///
  /// [symbol] - Target stock's symbol.
  ///
  /// Returns a Stock
  ///
  /// Throws APIError if
  /// Gets a stock by its symbol.
  ///
  /// [symbol] - String Symbol of the stock to fetch.
  ///
  /// Returns a Stock.
  ///
  /// Throws APIError if the [token] is not valid,
  /// or the symbol is invalid.
  Future<Stock> getStock(String symbol) async {
    if (!_stockCache.containsKey(symbol) ||
        _shouldFetch(_stockCache[symbol].fetched,
            duration: _stockCacheRenewTime)) {
      return await _fetchStock(symbol);
    }
    return _stockCache[symbol];
  }

  /// Gets a user's portfolio.
  ///
  /// Returns an ordered list of Stocks, sorted alphabetically.
  ///
  /// Throws APIError if the [userID] is not registered, the [token] not valid for the [userID],
  /// or the symbol is invalid.
  Future<List<Stock>> getPortfolio() async {
    if (portfolioCache == null ||
        _shouldFetch(_lastFetchedPortfolio,
            duration: _portfolioCacheRenewTime)) {
      return await _fetchPortfolio();
    } else {
      return portfolioCache;
    }
  }

  /// Gets a user's balance.
  ///
  /// Returns a double.
  ///
  /// Throws APIError if the [userID] is not registered, the [token] not valid for the [userID],
  /// or the symbol is invalid.
  Future<double> getBalance() async {
    if (balanceCache == null ||
        _shouldFetch(_lastFetchedBalance, duration: _balanceCacheRenewTime)) {
      return await _fetchBalance();
    } else {
      return balanceCache;
    }
  }

  Future buyStock(String symbol, int quantity) async {
    final response = await http.post('${_apiEndpoint}buyStock',
      body: jsonEncode({
        'token': _token,
        'symbol': symbol,
        'quantity': quantity
      })
    );

    _checkResponse(response);
    await _fetchBalance();
    await _fetchPortfolio();
  }

  Future sellStock(String symbol, int quantity) async {
    final response = await http.post('${_apiEndpoint}sellStock',
      body: jsonEncode({
        'token': _token,
        'symbol': symbol,
        'quantity': quantity
      })
    );

    _checkResponse(response);
    await _fetchBalance();
    await _fetchPortfolio();
  }

  Future<List<Stock>> topGain() async {
    final response = await http.post('${_apiEndpoint}topGain',
      body: jsonEncode({
        'token': _token
      })
    );
    _checkResponse(response);
    List<Stock> stocks = [];
    List body = jsonDecode(response.body);
    for (var stock in body) {
      stocks.add(Stock(stock));
    }
    return stocks;
  }

  Future<List> trending() async {
    final response = await http.post('${_apiEndpoint}trending',
      body: jsonEncode({
        'token': _token
      })
    );
    _checkResponse(response);
    return jsonDecode(response.body);
  }

  Future<List> search(String term) async {
    final response = await http.post('${_apiEndpoint}search',
    body: jsonEncode({
      'token': _token,
      'term': term
    }));

    _checkResponse(response);
    final body = jsonDecode(response.body);
    return body;
  }

  Future<double> totalBalance() async {
    double balance = await getBalance();
    final portfolio = await getPortfolio();
    portfolio.forEach((element) => balance += element.price * element.quantity);

    return balance;
  }

  Future<double> totalChange() async {
    double change = 0;
    final portfolio = await getPortfolio();
    portfolio.forEach((element) => change += element.change * element.quantity);

    return change;
  }

  Future<double> changePercent() async {
    final totalBalance = await this.totalBalance();
    final portfolio = await getPortfolio();
    double open = 0;
    portfolio.forEach((element) => open += element.openValue * element.quantity);
    if (open == 0) {
      return 0;
    }
    return totalBalance/open;
  }
}

/// Thrown when the API returns an error.
class APIError implements Exception {
  String cause;
  APIError(this.cause);
}
