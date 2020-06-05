import 'stock.dart';
import '../bloc/API.dart';

class TopGainEvent {
  List<Stock> data;

  TopGainEvent(this.data);


  static Future<TopGainEvent> getTopGain() async {
    return TopGainEvent(await API().topGain());
  }
}