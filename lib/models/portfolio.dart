import 'package:flutter/cupertino.dart';

import 'stock.dart';
import '../bloc/API.dart';

class PortfolioEvent {
  List<Stock> data;
  ConnectionState state;
  PortfolioEvent(this.data, this.state);


  static Future<PortfolioEvent> getPortfolio() async {
    return PortfolioEvent(await API().getPortfolio(), ConnectionState.done);
  }
}