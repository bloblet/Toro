import 'stock.dart';
import '../bloc/API.dart';

class PortfolioEvent {
  List<Stock> data;

  PortfolioEvent(this.data);


  static Future<PortfolioEvent> getPortfolio() async {
    return PortfolioEvent(await API().getPortfolio());
  }
}