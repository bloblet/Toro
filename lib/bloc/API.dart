import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/stock.dart';
import '../utils.dart';

final _a = String.fromCharCodes([
  0x54,
  0x77,
  0x72,
  0x59,
  0x47,
  0x32,
  0x32,
  0x78,
  0x4e,
  0x42,
  0x4c,
  0x42,
  0x49,
  0x6d,
  0x32,
  0x45,
  0x47,
  0x59,
  0x42,
  0x47,
  0x69,
  0x72,
  0x6c,
  0x56,
  0x37,
  0x42,
  0x58,
  0x52,
  0x61,
  0x4f,
  0x69,
  0x68,
  0x4a,
  0x70,
  0x5a,
  0x47,
  0x78,
  0x4f,
  0x30,
  0x2d,
  0x71,
  0x38,
  0x41,
  0x4e,
  0x66,
  0x43,
  0x68,
  0x43,
  0x51,
  0x72,
  0x31,
  0x56,
  0x55,
  0x2d,
  0x6d,
  0x7a,
  0x77,
  0x6f,
  0x65,
  0x74,
  0x69,
  0x6c,
  0x62,
  0x5f,
  0x76,
  0x59,
  0x69,
  0x75,
  0x72,
  0x56,
  0x53,
  0x48,
  0x67,
  0x4c,
  0x75,
  0x62,
  0x47,
  0x55,
  0x2d,
  0x59,
  0x6b,
  0x34,
  0x43,
  0x4d,
  0x57,
  0x5a,
  0x5a,
  0x6f,
  0x32,
  0x68,
  0x48,
  0x4d,
  0x49,
  0x38,
  0x35,
  0x4f,
  0x69,
  0x61,
  0x75,
  0x48,
  0x59,
  0x45,
  0x35,
  0x33,
  0x5f,
  0x68,
  0x30,
  0x51,
  0x6f,
  0x74,
  0x6d,
  0x56,
  0x46,
  0x37,
  0x41,
  0x2d,
  0x65,
  0x44,
  0x67,
  0x42,
  0x37,
  0x68,
  0x54,
  0x74,
  0x2d,
  0x7a,
  0x6a,
  0x51,
  0x44,
  0x71,
  0x31,
  0x38,
  0x54,
  0x67,
  0x70,
  0x34,
  0x62,
  0x6e,
  0x67,
  0x62,
  0x4e,
  0x54,
  0x4a,
  0x38,
  0x75,
  0x36,
  0x6a,
  0x63,
  0x4e,
  0x6d,
  0x6b,
  0x7a,
  0x72,
  0x46,
  0x56,
  0x46,
  0x57,
  0x43,
  0x4f,
  0x4c,
  0x71,
  0x59,
  0x6f,
  0x62,
  0x7a,
  0x2d,
  0x49,
  0x70,
  0x45,
  0x6a,
  0x6b
]);

/// Factory API class, no need to store it anywhere.
/// For now, this is all a dummy API, uncomment the lines prefixed by
/// `// DUMMY`, and it will be a fully working API, as long as the counterpart is...
class API {
  /// Cache of the API.  I don't want to worry about passing this around in the
  /// widget tree, so this will stay.
  static API _cache = API._();

  /// Current location of the stocks API
  String _apiEndpoint = 'https://pn.bloblet.com/';

  static const debug = true;

  /// Default factory constructor for the singleton class
  factory API() {
    return _cache;
  }

  /// This is a constructor, so we can initialize our class in the static member [_cache]
  /// This should only run once, at the start of our app.
  API._();
  Future<http.Response> _request(String url, String method,
      [String body]) async {
    log('Sending $method request to $url...');
    final uri = Uri.parse(url);
    final request = http.Request(method, uri);
    request.body = body;
    request.headers['Content-Type'] = 'application/json';
    request.headers['Token'] = _a;

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

  Future<http.Response> get(String url, [String body]) =>
      _request(url, 'GET', body);

  Future<http.Response> put(String url, [String body]) =>
      _request(url, 'PUT', body);

  Future<http.Response> delete(String url, [String body]) =>
      _request(url, 'DELETE', body);

  Future<http.Response> post(String url, [String body]) =>
      _request(url, 'POST', body);

  Future<http.Response> patch(String url, [String body]) =>
      _request(url, 'PATCH', body);

  void _checkResponse(http.Response res) {
    if (res.statusCode != 200 || res.statusCode != 201) {
      throw APIError(
          '[${res.statusCode}]: Reason: ${res.reasonPhrase ?? 'None'} Body: ${res.body ?? 'None'}');
    }
  }
  
  /// Queries the API for [symbol], and returns the corresponding stock.
  Future<Stock> fetchStock(String symbol) async {
    final response =
        await patch('${_apiEndpoint}stocks', jsonEncode({'symbol': symbol}));
    _checkResponse(response);

    return Stock.fromJson(jsonDecode(response.body));
  }

  /// Fetches the latest portfolio from the API and returns a sorted list of the stocks.
  Future<List<Stock>> fetchPortfolio(String token, String email) async {
    final List<Stock> stocks = [];
    final response = await get(
        '${_apiEndpoint}stocks', jsonEncode({'token': token, 'email': email}));

    _checkResponse(response);

    final List body = jsonDecode(response.body);

    if (body.length == 0) {
      return [];
    } else if (body.length == 1) {
      return [Stock.fromJson(body[0])];
    }

    body.sort((stock1, stock2) => stock1['symbol'].compareTo(stock2['symbol']));

    for (Map<String, dynamic> stock in body) {
      stocks.add(Stock.fromJson(stock));
    }

    return stocks;
  }

  Future<Map<DateTime, double>> fetchBalanceHistory(
      DateTime lastFetched, String token, String email) async {
    final response = await get(
      '${_apiEndpoint}balanceHistory',
      jsonEncode(
        {
          'token': token,
          'email': email,
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
  Future<double> fetchBalance(String token, String email) async {
    final response = await get(
      '${_apiEndpoint}me',
      jsonEncode({'token': token, 'email': email}),
    );
    _checkResponse(response);

    final balance = jsonDecode(response.body)['balance'];

    return balance;
  }

  Future<List<Stock>> sellStock(
      String symbol, int quantity, String token, String email) async {
    final response = await delete(
      '${_apiEndpoint}stocks',
      jsonEncode({
        'token': token,
        'email': email,
        'symbol': symbol,
        'quantity': quantity
      }),
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
      String symbol, int quantity, String token, String email) async {
    final response = await put(
        '${_apiEndpoint}buyStock',
        jsonEncode({
          'token': token,
          'email': email,
          'symbol': symbol,
          'quantity': quantity
        }));

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
    final response = await get(
        '${_apiEndpoint}search', jsonEncode({'term': term}));

    _checkResponse(response);
    final body = jsonDecode(response.body);
    return body;
  }

  Future<User> signIn(String email, String password) async {
    final response = await get(
        '${_apiEndpoint}me',
        jsonEncode(
          {
            'email': email,
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
      ..email = body['email']
      ..token = body['token']
      ..inventory = []
      ..lastUpdatedBalance = now
      ..lastUpdatedBalanceHistory = now
      ..lastUpdatedInventory = now;
  }

  Future<User> signUp(String email, String password, String username) async {
    final response = await post(
        '${_apiEndpoint}me',
        jsonEncode(
          {'email': email, 'password': password, 'username': username},
        ));
    _checkResponse(response);

    final body = jsonDecode(response.body);
    final now = DateTime.now();

    return User()
      ..balance = body['balance']
      ..balanceHistory = {now: 0}
      ..email = body['email']
      ..token = body['token']
      ..inventory = body['stocks']
      ..lastUpdatedBalance = now
      ..lastUpdatedBalanceHistory = now
      ..lastUpdatedInventory = now
      ..investedValue = 0
      ..totalValue = body['balance']
      ..username = username;
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
