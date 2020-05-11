import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import './stock.dart';

/// Factory API class, no need to store it anywhere.
/// For now, this is all a dummy API, uncomment the lines prefixed by
/// `// DUMMY`, and it will be a fully working API,as long as the counterpart is...
class API {
  /// Cache of the API.  I don't want to worry about passing this around in the
  /// widget tree, so this will stay.
  static API _cache = API._();

  /// Cache of the stocks we know of.
  /// To not call the API every other milisecond, we ought to cache stocks,
  /// especially since I plan to add ratelimits to the other API soon.
  /// Renews every 15 minutes, if it is requested.
  static const Duration _stockCacheRenewTime = Duration(minutes: 15);
  static Map<String, Stock> _stockCache = {};

  /// Cache of our portfolio, the stocks that the user owns.
  /// Renews every 15 minutes.
  static const Duration _portfolioCacheRenewTime = Duration(minutes: 15);
  static List<Stock> _portfolioCache;
  static DateTime _lastFetchedPortfolio =
      DateTime.fromMicrosecondsSinceEpoch(0);

  /// Cache of our balance.
  /// Arguably, this is more important than stocks or our portfolio, and could change faster.
  /// Renews every 1 minute.
  ///
  static const Duration _balanceCacheRenewTime = Duration(minutes: 15);
  static double _balanceCache;
  static DateTime _lastFetchedBalance = DateTime.fromMicrosecondsSinceEpoch(0);

  /// Current location of the stocks API
  static const String _apiEndpoint = 'http://bloblet.com/';

  // UserID to get stocks for.
  // DUMMY
  // static int userID;

  // Token to authenticate [userID] for.
  // DUMMY
  // static String token;

  /// Default factory constructor for the singleton class
  factory API() {
    return _cache;
  }

  /// This is a constructor, so we can initialize our class in the static member [_cache]
  API._();

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

  /// Queries the API for [symbol], and returns the corresponding stock.
  Future<Stock> _fetchStock(String symbol) async {
    final response = await http.get('${_apiEndpoint}stock');
    _checkResponse(response);

    return Stock(jsonDecode(response.body));
  }

  /// Fetches the latest portfolio from the API and returns a sorted list of the stocks.
  Future<List<Stock>> _fetchPortfolio() async {
    final List<Stock> stocks = [];
    // DUMMY
    // final response = await http.post('${_apiEndpoint}portfolio', body:
    //   jsonEncode({
    //     'userID': _userID,
    //     'token': _token,
    //   }),
    // );
    final response = await http.get('${_apiEndpoint}dummy/portfolio');
    _checkResponse(response);

    _lastFetchedPortfolio = DateTime.now();

    final List<dynamic> body = jsonDecode(response.body);
    body.sort((stock1, stock2) => stock1['symbol'].compareTo(stock2['symbol']));

    for (Map<String, Object> stock in body) {
      stocks.add(Stock(stock));
    }

    _portfolioCache = stocks;
    return stocks;
  }

  /// Fetches the user's latest balance from the server.
  Future<double> _fetchBalance() async {
    // DUMMY
    // final response = await http.post(
    //   '${_apiEndpoint}balance',
    //   body: jsonEncode({
    //     'userID': _userID,
    //     'token': _token,
    //   }),
    // );
    final response = await http.get('${_apiEndpoint}dummy/balance');
    _checkResponse(response);
    return double.parse(response.body);
  }

  /// Gets a stock by its symbol.
  ///
  /// [symbol] - String Symbol of the stock to fetch.
  ///
  /// Returns a Stock.
  ///
  /// Throws APIError if the [userID] is not registered, the [token] not valid for the [userID],
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
    if (_portfolioCache == null ||
        _shouldFetch(_lastFetchedPortfolio,
            duration: _portfolioCacheRenewTime)) {
      return await _fetchPortfolio();
    } else {
      return _portfolioCache;
    }
  }

  /// Gets a user's balance.
  ///
  /// Returns a double.
  ///
  /// Throws APIError if the [userID] is not registered, the [token] not valid for the [userID],
  /// or the symbol is invalid.
  Future<double> getBalance() async {
    if (_balanceCache == null || _shouldFetch(_lastFetchedBalance, duration: _balanceCacheRenewTime)) {
      return await _fetchBalance();
    } else {
      return _balanceCache;
    }
  }
}

/// Thrown when the API returns an error.
class APIError implements Exception {
  String cause;
  APIError(this.cause);
}
