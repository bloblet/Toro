import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/API.dart';

enum BalanceEvent {
  get
}

class BalanceBLoC extends Bloc<BalanceEvent, double> {
  @override
  double get initialState => 0;

  @override
  Stream<double> mapEventToState(BalanceEvent event) async* {
    yield await API().getBalance();
  }
}