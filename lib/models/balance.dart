import '../bloc/API.dart';

class BalanceEvent {
  double data;

  BalanceEvent(this.data);


  static Future<BalanceEvent> getBalance() async {
    return BalanceEvent(await API().getBalance());
  }
}