import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/stock.dart';
import '../utils.dart';

/// Factory API class, no need to store it anywhere.
/// For now, this is all a dummy API, uncomment the lines prefixed by
/// `// DUMMY`, and it will be a fully working API, as long as the counterpart is...
class API {
  /// Cache of the API.  I don't want to worry about passing this around in the
  /// widget tree, so this will stay.
  static API _cache = API._();

  /// Current location of the stocks API
  String _apiEndpoint = 'http://40.114.0.32/';

  static const debug = true;

  /// Default factory constructor for the singleton class
  factory API() {
    return _cache;
  }

  /// This is a constructor, so we can initialize our class in the static member [_cache]
  /// This should only run once, at the start of our app.
  API._();
  Future<http.Response> _request(String url, String method,
      {Map<String, String> headers, String body}) async {
    log('Sending $method request to $url...');
    final uri = Uri.parse(url);
    final request = http.Request(method, uri);
    request.body = body;
    request.headers['Content-Type'] = 'application/json';
    request.headers['Key'] = '';
    request.headers.addAll(headers ?? {});
    final start = DateTime.now();
    final _res = await request.send();

    if (_res.statusCode > 201) {
      log('[${uri.path}] Non 200/1 status code recieved! (${_res.statusCode}, Reason: ${_res.reasonPhrase})',
          type: Severity.error);
      log('[${uri.path}] Request body was $body', type: Severity.error);
    }

    final res = await http.Response.fromStream(_res);
    final end = DateTime.now();

    final diff = end.difference(start);
    if (diff.inSeconds >= 2) {
      log('[${uri.path}] Request resolution took an unexpectedly long time (${diff.inMilliseconds}ms)!',
          type: Severity.warning);
    } else {
      if (!(_res.statusCode > 201)) {
        log('[${uri.path} ]Finished, took ${diff.inMilliseconds}ms!',
            type: Severity.success);
      } else {
        log('[${uri.path} ]Finished, took ${diff.inMilliseconds}ms, completed with status code ${_res.statusCode}',
            type: Severity.error);
      }
    }

    return res;
  }

  Future<http.Response> post(String url,
          {String body, Map<String, String> headers}) =>
      _request(url, 'POST', body: body, headers: headers);

  Future<http.Response> get(String url,
          {String body, Map<String, String> headers}) =>
      _request(url, 'GET', body: body, headers: headers);

  Future<http.Response> put(String url,
          {String body, Map<String, String> headers}) =>
      _request(url, 'PUT', body: body, headers: headers);

  Future<http.Response> delete(String url,
          {String body, Map<String, String> headers}) =>
      _request(url, 'DELETE', body: body, headers: headers);

  void _checkResponse(http.Response res) {
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw APIError(
          '[${res.statusCode}]: Reason: ${res.reasonPhrase ?? 'None'} Body: ${res.body ?? 'None'}');
    }
  }

  /// Queries the API for [symbol], and returns the corresponding stock.
  Future<Stock> fetchStock(String symbol) async {
    final response = await get('${_apiEndpoint}stocks',
        body: jsonEncode({'symbol': symbol}));
    _checkResponse(response);

    return Stock.fromJson(jsonDecode(response.body));
  }

  /// Fetches the latest portfolio from the API and returns a sorted list of the stocks.
  Future<Map<String, Stock>> fetchPortfolio(String token, String id) async {
    final Map<String, Stock> stocks = {};
    final response =
        await get('${_apiEndpoint}user/$id/stocks', headers: {'Token': token});

    _checkResponse(response);

    final Map body = jsonDecode(response.body);

    if (body.length == 0) {
      return {};
    } else if (body.length == 1) {
      return {body.keys.first: Stock.fromJson(body.values.first)};
    }

    final symbols = body.keys
        .toList()
        .sort((symbol1, symbol2) => symbol1.compareTo(symbol2)) as List<String>;

    for (String stock in symbols) {
      stocks[stock] = (Stock.fromJson(body[stock]));
    }

    return stocks;
  }

  Future<Map<DateTime, double>> fetchBalanceHistory(
      DateTime lastFetched, String token, String id) async {
    final response = await get(
      '${_apiEndpoint}balanceHistory',
      body: jsonEncode(
        {
          'token': token,
          'id': id,
          'lastBalance': lastFetched.toIso8601String(),
        },
      ),
    );

    _checkResponse(response);
    final Map body = jsonDecode(response.body);

    final Map<DateTime, double> missedBalances = {};
    for (String date in body.keys) {
      missedBalances[DateTime.parse(date)] = body[date];
    }

    return missedBalances;
  }

  /// Fetches the user's latest balance from the server.
  Future<double> fetchBalance(String token, String id) async {
    final response =
        await get('${_apiEndpoint}user/$id', headers: {'Token': token});
    _checkResponse(response);

    final balance = jsonDecode(response.body)['balance'];

    return balance;
  }

  Future<List<Stock>> sellStock(
      String symbol, int quantity, String token, String id) async {
    final response = await delete(
      '${_apiEndpoint}user/$id/stocks/$symbol/$quantity',
      headers: {'Token': token},
    );

    _checkResponse(response);

    final body = jsonDecode(response.body);
    final parsedStocks = [];

    for (final stock in body) {
      parsedStocks.add(Stock.fromJson(stock));
    }

    return parsedStocks;
  }

  Future<List<Stock>> buyStock(
      String symbol, int quantity, String token, String id) async {
    final response = await post(
        '${_apiEndpoint}users/$id/stocks/$symbol/$quantity',
        headers: {'Token': token});

    _checkResponse(response);

    final body = jsonDecode(response.body);
    final parsedStocks = [];

    for (final stock in body) {
      parsedStocks.add(Stock.fromJson(stock));
    }

    return parsedStocks;
  }

  // Future<List<Stock>> topGain() async {
  //   final response = await http.post('${_apiEndpoint}topGain',
  //       body: jsonEncode({'token': _token}));
  //   _checkResponse(response);
  //   List<Stock> stocks = [];
  //   List body = jsonDecode(response.body);
  //   for (var stock in body) {
  //     stocks.add(Stock.fromJson(stock));
  //   }
  //   return stocks;
  // }

  // Future<List> trending() async {
  //   final response = await http.post('${_apiEndpoint}trending',
  //       body: jsonEncode({'token': _token}));
  //   _checkResponse(response);
  //   return jsonDecode(response.body);
  // }

  Future<List> search(String term) async {
    // final response =
    // await get('${_apiEndpoint}search', jsonEncode({'term': term}));

    // _checkResponse(response);
    // final body = jsonDecode(response.body);
    // return body;
  }

  Future<User> signIn(String id, String password) async {
    final response = await get('${_apiEndpoint}me',
        body: jsonEncode(
          {
            'id': id,
            'password': password,
          },
        ));

    _checkResponse(response);

    final body = jsonDecode(response.body);
    final now = DateTime.now();

    return User()
      ..username = body['username']
      ..balance = body['balance']
      ..balanceHistory = {now: body['balance']}
      ..id = body['id']
      ..token = body['token']
      ..inventory = body['stocks']
      ..lastUpdatedBalance = now
      ..lastUpdatedBalanceHistory = now
      ..lastUpdatedInventory = now;
  }

  Future<User> signUp(String username) async {
    final response = await post('${_apiEndpoint}users',
        body: jsonEncode(
          {'username': username},
        ));
    _checkResponse(response);

    final body = jsonDecode(response.body);
    final now = DateTime.now();

    return User()
      ..balance = body['balance']
      ..balanceHistory = {now: 0}
      ..id = body['id']
      ..token = body['token']
      ..inventory = {}
      ..lastUpdatedBalance = now
      ..lastUpdatedBalanceHistory = now
      ..lastUpdatedInventory = now
      ..investedValue = 0
      ..totalValue = body['balance']
      ..username = username
      ..portfolioChanges = Map<String, int>.from(body['portfolioChanges']);
  }

  // Future<double> totalBalance() async {
  //   double balance = await getBalance();
  //   final portfolio = await getPortfolio();
  //   portfolio.forEach((element) => balance += element.price * element.quantity);

  //   return balance;
  // }

  // Future<double> totalChange() async {
  //   double change = 0;
  //   final portfolio = await getPortfolio();
  //   portfolio.forEach((element) => change += element.change * element.quantity);

  //   return change;
  // }

  // Future<double> changePercent() async {
  //   final totalBalance = await this.totalBalance();
  //   final portfolio = await getPortfolio();
  //   double open = 0;
  //   portfolio
  //       .forEach((element) => open += element.openValue * element.quantity);
  //   if (open == 0) {
  //     return 0;
  //   }
  //   return totalBalance / open;
  // }
}

/// Thrown when the API returns an error.
class APIError implements Exception {
  String cause;
  APIError(this.cause);
}
