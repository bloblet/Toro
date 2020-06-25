import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stockSimulator/models/user.dart';
import '../models/stock.dart';

/// Factory API class, no need to store it anywhere.
/// For now, this is all a dummy API, uncomment the lines prefixed by
/// `// DUMMY`, and it will be a fully working API, as long as the counterpart is...
class API {
  /// Cache of the API.  I don't want to worry about passing this around in the
  /// widget tree, so this will stay.
  static API _cache = API._();

  /// Current location of the stocks API
  String _apiEndpoint = 'http://pn.bloblet.com:9876/';

  // Token to authenticate [userID] for.
  String _token = "kS+RLoGUsPw5STYBFmzY0Q8Zz0pIgh5YIGByNZ0VYEw=";

  String email = 'fpiesquared@gmail.com';

  /// Default factory constructor for the singleton class
  factory API() {
    return _cache;
  }

  /// This is a constructor, so we can initialize our class in the static member [_cache]
  /// This should only run once, at the start of our app.
  API._();

  void _checkResponse(http.Response res) {
    if (res.statusCode != 200) {
      throw APIError(
          '[${res.statusCode}]: Reason: ${res.reasonPhrase ?? 'None'} Body: ${res.body ?? 'None'}');
    }
  }

  /// Queries the API for [symbol], and returns the corresponding stock.
  Future<Stock> fetchStock(String symbol) async {
    final response = await http.get('${_apiEndpoint}stock');
    _checkResponse(response);

    return Stock.fromJson(jsonDecode(response.body));
  }

  /// Fetches the latest portfolio from the API and returns a sorted list of the stocks.
  Future<List<Stock>> fetchPortfolio(String token, String email) async {
    final List<Stock> stocks = [];
    final response = await http.post('${_apiEndpoint}portfolio',
        body: jsonEncode({'token': token, 'email': email}),
        headers: {'Content-Type': 'application/json'});
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
    final response = await http.post('${_apiEndpoint}balanceHistory',
        body: jsonEncode({
          'token': token,
          'email': email,
          'lastFetched': lastFetched.toIso8601String(),
        }),
        headers: {'Content-Type': 'application/json'});
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
    final response = await http.post('${_apiEndpoint}balance',
        body: jsonEncode({'token': token, 'email': email}),
        headers: {'Content-Type': 'application/json'});
    _checkResponse(response);
    final balance = double.parse(response.body);

    return balance;
  }

  Future sellStock(
      String symbol, int quantity, String token, String email) async {
    final response = await http.post('${_apiEndpoint}sellStock',
        body: jsonEncode({
          'token': token,
          'email': email,
          'symbol': symbol,
          'quantity': quantity
        }));

    _checkResponse(response);
  }

  Future buyStock(
      String symbol, int quantity, String token, String email) async {
    final response = await http.post('${_apiEndpoint}buyStock',
        body: jsonEncode({
          'token': token,
          'email': email,
          'symbol': symbol,
          'quantity': quantity
        }));

    _checkResponse(response);
  }

  Future<List<Stock>> topGain() async {
    final response = await http.post('${_apiEndpoint}topGain',
        body: jsonEncode({'token': _token}));
    _checkResponse(response);
    List<Stock> stocks = [];
    List body = jsonDecode(response.body);
    for (var stock in body) {
      stocks.add(Stock.fromJson(stock));
    }
    return stocks;
  }

  Future<List> trending() async {
    final response = await http.post('${_apiEndpoint}trending',
        body: jsonEncode({'token': _token}));
    _checkResponse(response);
    return jsonDecode(response.body);
  }

  Future<List> search(String term) async {
    final response = await http.post('${_apiEndpoint}search',
        body: jsonEncode({'token': _token, 'term': term}));

    _checkResponse(response);
    final body = jsonDecode(response.body);
    return body;
  }

  Future<User> signIn(String email, String password) async {
    final response = await http.post(
      '${_apiEndpoint}login',
      body: jsonEncode(
        {
          'email': email,
          'password': password,
        },
      ),
    );
    _checkResponse(response);

    final body = jsonDecode(response.body);
    final now = DateTime.now();

    return User()
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
    final response = await http.post(
      '${_apiEndpoint}signUp',
      body: jsonEncode(
        {'email': email, 'password': password, 'username': username},
      ),
    );

    _checkResponse(response);

    final body = jsonDecode(response.body);
    final now = DateTime.now();

    return User()
      ..balance = body['balance']
      ..balanceHistory = {now: body['balance']}
      ..email = body['email']
      ..token = body['token']
      ..inventory = body['stocks']
      ..lastUpdatedBalance = now
      ..lastUpdatedBalanceHistory = now
      ..lastUpdatedInventory = now;
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
