import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/stock.dart';

const _token = 'T'
    'w'
    'r'
    'Y'
    'G'
    '2'
    '2'
    'x'
    'N'
    'B'
    'L'
    'B'
    'I'
    'm'
    '2'
    'E'
    'G'
    'Y'
    'B'
    'G'
    'i'
    'r'
    'l'
    'V'
    '7'
    'B'
    'X'
    'R'
    'a'
    'O'
    'i'
    'h'
    'J'
    'p'
    'Z'
    'G'
    'x'
    'O'
    '0'
    '-'
    'q'
    '8'
    'A'
    'N'
    'f'
    'C'
    'h'
    'C'
    'Q'
    'r'
    '1'
    'V'
    'U'
    '-'
    'm'
    'z'
    'w'
    'o'
    'e'
    't'
    'i'
    'l'
    'b'
    '_'
    'v'
    'Y'
    'i'
    'u'
    'r'
    'V'
    'S'
    'H'
    'g'
    'L'
    'u'
    'b'
    'G'
    'U'
    '-'
    'Y'
    'k'
    '4'
    'C'
    'M'
    'W'
    'Z'
    'Z'
    'o'
    '2'
    'h'
    'H'
    'M'
    'I'
    '8'
    '5'
    'O'
    'i'
    'a'
    'u'
    'H'
    'Y'
    'E'
    '5'
    '3'
    '_'
    'h'
    '0'
    'Q'
    'o'
    't'
    'm'
    'V'
    'F'
    '7'
    'A'
    '-'
    'e'
    'D'
    'g'
    'B'
    '7'
    'h'
    'T'
    't'
    '-'
    'z'
    'j'
    'Q'
    'D'
    'q'
    '1'
    '8'
    'T'
    'g'
    'p'
    '4'
    'b'
    'n'
    'g'
    'b'
    'N'
    'T'
    'J'
    '8'
    'u'
    '6'
    'j'
    'c'
    'N'
    'm'
    'k'
    'z'
    'r'
    'F'
    'V'
    'F'
    'W'
    'C'
    'O'
    'L'
    'q'
    'Y'
    'o'
    'b'
    'z'
    '-'
    'I'
    'p'
    'E'
    'j'
    'k';

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

  Future<http.Response> get(String url, {String body}) async {
    if (debug) {
      print('[INFO] Sending GET request to $url...');
    }
    final uri = Uri.parse(url);
    final request = http.Request('GET', uri);
    request.body = body;
    request.headers['Content-Type'] = 'application/json';
    request.headers['Token'] = _token;

    final start = DateTime.now();
    final _res = await request.send();

    if (debug && _res.statusCode > 200) {
      print(
          '[WARNING] > ${uri.path} Non 200/1 status code recieved! (${_res.statusCode}, Reason: ${_res.reasonPhrase})');
      print('[WARNING] > ${uri.path} Request body was $body');
    }

    final res = await http.Response.fromStream(_res);
    final end = DateTime.now();

    final diff = end.difference(start);
    if (debug) {
      if (diff.inSeconds >= 2) {
        print(
            '[WARNING] > ${uri.path} Request resolution took an unexpectedly long time (${diff.inMilliseconds}ms)!');
      } else {
        print('[INFO] > ${uri.path} Finished, took ${diff.inMilliseconds}ms!');
      }
    }

    return res;
  }

  Future<http.Response> put(String url, {String body}) async {
    if (debug) {
      print('[INFO] Sending PUT request to $url...');
    }
    final uri = Uri.parse(url);
    final request = http.Request('PUT', uri);
    request.body = body;
    request.headers['Content-Type'] = 'application/json';
    request.headers['Token'] = _token;

    final start = DateTime.now();
    final _res = await request.send();

    if (debug && _res.statusCode > 200) {
      print(
          '[WARNING] > ${uri.path} Non 200/1 status code recieved! (${_res.statusCode}, Reason: ${_res.reasonPhrase})');
      print('[WARNING] > ${uri.path} Request body was $body');
    }

    final res = await http.Response.fromStream(_res);
    final end = DateTime.now();

    final diff = end.difference(start);
    if (debug) {
      if (diff.inSeconds >= 2) {
        print(
            '[WARNING] > ${uri.path} Request resolution took an unexpectedly long time (${diff.inMilliseconds}ms)!');
      } else {
        print('[INFO] > ${uri.path} Finished, took ${diff.inMilliseconds}ms!');
      }
    }

    return res;
  }

  Future<http.Response> delete(String url, {String body}) async {
    if (debug) {
      print('[INFO] Sending DELETE request to $url...');
    }
    final uri = Uri.parse(url);
    final request = http.Request('DELETE', uri);
    request.body = body;
    request.headers['Content-Type'] = 'application/json';
    request.headers['Token'] = _token;

    final start = DateTime.now();
    final _res = await request.send();

    if (debug && _res.statusCode > 200) {
      print(
          '[WARNING] > ${uri.path} Non 200/1 status code recieved! (${_res.statusCode}, Reason: ${_res.reasonPhrase})');
      print('[WARNING] > ${uri.path} Request body was $body');
    }

    final res = await http.Response.fromStream(_res);
    final end = DateTime.now();

    final diff = end.difference(start);
    if (debug) {
      if (diff.inSeconds >= 2) {
        print(
            '[WARNING] > ${uri.path} Request resolution took an unexpectedly long time (${diff.inMilliseconds}ms)!');
      } else {
        print('[INFO] > ${uri.path} Finished, took ${diff.inMilliseconds}ms!');
      }
    }

    return res;
  }

  Future<http.Response> post(String url, {String body}) async {
    if (debug) {
      print('[INFO] Sending POST request to $url...');
    }
    final uri = Uri.parse(url);
    final request = http.Request('POST', uri);
    request.body = body;
    request.headers['Content-Type'] = 'application/json';
    request.headers['Token'] = _token;

    final start = DateTime.now();
    final _res = await request.send();

    if (debug && _res.statusCode > 200) {
      print(
          '[WARNING] > ${uri.path} Non 200/1 status code recieved! (${_res.statusCode}, Reason: ${_res.reasonPhrase})');
      print('[WARNING] > ${uri.path} Request body was $body');
    }

    final res = await http.Response.fromStream(_res);
    final end = DateTime.now();

    final diff = end.difference(start);
    if (debug) {
      if (diff.inSeconds >= 2) {
        print(
            '[WARNING] > ${uri.path} Request resolution took an unexpectedly long time (${diff.inMilliseconds}ms)!');
      } else {
        print('[INFO] > ${uri.path} Finished, took ${diff.inMilliseconds}ms!');
      }
    }

    return res;
  }

  Future<http.Response> patch(String url, {String body}) async {
    if (debug) {
      print('[INFO] Sending PATCH request to $url...');
    }
    final uri = Uri.parse(url);
    final request = http.Request('PATCH', uri);
    request.body = body;
    request.headers['Content-Type'] = 'application/json';
    request.headers['Token'] = _token;

    final start = DateTime.now();
    final _res = await request.send();

    if (debug && _res.statusCode > 200) {
      print(
          '[WARNING] > ${uri.path} Non 200/1 status code recieved! (${_res.statusCode}, Reason: ${_res.reasonPhrase})');
      print('[WARNING] > ${uri.path} Request body was $body');
    }

    final res = await http.Response.fromStream(_res);
    final end = DateTime.now();

    final diff = end.difference(start);
    if (debug) {
      if (diff.inSeconds >= 2) {
        print(
            '[WARNING] > ${uri.path} Request resolution took an unexpectedly long time (${diff.inMilliseconds}ms)!');
      } else {
        print('[INFO] > ${uri.path} Finished, took ${diff.inMilliseconds}ms!');
      }
    }

    return res;
  }

  void _checkResponse(http.Response res) {
    if (res.statusCode != 200 || res.statusCode != 201) {
      throw APIError(
          '[${res.statusCode}]: Reason: ${res.reasonPhrase ?? 'None'} Body: ${res.body ?? 'None'}');
    }
  }

  /// Queries the API for [symbol], and returns the corresponding stock.
  Future<Stock> fetchStock(String symbol) async {
    final response = await patch('${_apiEndpoint}stocks',
        body: jsonEncode({'symbol': symbol}));
    _checkResponse(response);

    return Stock.fromJson(jsonDecode(response.body));
  }

  /// Fetches the latest portfolio from the API and returns a sorted list of the stocks.
  Future<List<Stock>> fetchPortfolio(String token, String email) async {
    final List<Stock> stocks = [];
    final response = await get('${_apiEndpoint}stocks',
        body: jsonEncode({'token': token, 'email': email}));

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
      body: jsonEncode(
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
      body: jsonEncode({'token': token, 'email': email}),
    );
    _checkResponse(response);

    final balance = jsonDecode(response.body)['balance'];

    return balance;
  }

  Future<List<Stock>> sellStock(
      String symbol, int quantity, String token, String email) async {
    final response = await delete(
      '${_apiEndpoint}stocks',
      body: jsonEncode({
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
    final response = await put('${_apiEndpoint}buyStock',
        body: jsonEncode({
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
    final response = await get('${_apiEndpoint}search',
        body: jsonEncode({'token': _token, 'term': term}));

    _checkResponse(response);
    final body = jsonDecode(response.body);
    return body;
  }

  Future<User> signIn(String email, String password) async {
    final response = await get('${_apiEndpoint}me',
        body: jsonEncode(
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
    final response = await post('${_apiEndpoint}me',
        body: jsonEncode(
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
