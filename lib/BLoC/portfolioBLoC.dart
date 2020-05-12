import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/stock.dart';
import '../models/API.dart';

enum PortfolioEvent {
  get
}

class PortfolioBLoC extends Bloc<PortfolioEvent, List<Stock>> {
  @override
  List<Stock> get initialState => <Stock>[];

  @override
  Stream<List<Stock>> mapEventToState(PortfolioEvent event) async* {
    yield await API().getPortfolio();
  }
}