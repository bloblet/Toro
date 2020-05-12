import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../BLoC/portfolioBLoC.dart';
import '../models/stock.dart';
import '../BLoC/balanceBLoC.dart';
import 'tabScaffold.dart';

class PortfolioV2 extends StatelessWidget with ChangeNotifier {
  final ValueNotifier<AppBarButtons> sortMethod =
      ValueNotifier<AppBarButtons>(AppBarButtons.sortByAlpha);

  final Map<String, Bloc> bloc = {};

  getBloc(BuildContext context) {
    bloc.putIfAbsent('balanceBloc', () => context.bloc<BalanceBLoC>());
    bloc.putIfAbsent('portfolioBloc', () => context.bloc<PortfolioBLoC>());
  }

  BalanceBLoC get balanceBloc => bloc['balanceBloc'];
  PortfolioBLoC get portfolioBloc => bloc['portfolioBloc'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    getBloc(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<BalanceBLoC, double>(
          listener: (context, state) {},
        ),
        BlocListener<PortfolioBLoC, List<Stock>>(
          listener: (context, state) {},
        ),
      ],
      child: TabScaffold(
        body: StreamBuilder(
          stream: portfolioBloc.asBroadcastStream(),
          builder: (BuildContext context, AsyncSnapshot<List<Stock>> snapshot) {
            if (snapshot.hasData) {
              return PortfolioBody(data: snapshot.data, listenable: sortMethod);
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: StreamBuilder(
            stream: balanceBloc.asBroadcastStream(),
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.hasData) {
                final changeFunction = (AppBarButtons sortMethod) {
                  this.sortMethod.value = sortMethod;
                  this.sortMethod.notifyListeners();
                };
                return PortfolioAppBar(
                  amount: snapshot.data,
                  sortBy: (AppBarButtons sortMethod) {
                    this.sortMethod.value = sortMethod;
                    this.sortMethod.notifyListeners();
                  },
                );
              } else {
                return PortfolioAppBar(
                  amount: 0,
                  sortBy: (_) {},
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

enum AppBarButtons { sortByAlpha, sortByGains, sortByLoss }

class PortfolioAppBar extends StatelessWidget {
  final double amount;

  final Function(AppBarButtons) sortBy;

  PortfolioAppBar({@required this.amount, @required this.sortBy});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Text('\$${this.amount}'),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.pie_chart),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.sort_by_alpha),
          onPressed: () => this.sortBy(AppBarButtons.sortByAlpha),
        ),
        IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: () => this.sortBy(AppBarButtons.sortByGains),
        ),
        IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () => this.sortBy(AppBarButtons.sortByLoss),
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
    );
  }
}

class PortfolioBody extends StatelessWidget {
  final List<Stock> data;
  final ValueListenable<AppBarButtons> listenable;

  PortfolioBody({@required this.data, @required this.listenable});

  List<Widget> generate(sortMethod) {
    final List<Widget> widgets = [];

    if (sortMethod == AppBarButtons.sortByAlpha) {
      this.data.sort((Stock stock1, Stock stock2) =>
          stock1.symbol.compareTo(stock2.symbol));
    } else if (sortMethod == AppBarButtons.sortByGains) {
      this.data.sort((Stock stock1, Stock stock2) =>
          stock1.change.compareTo(stock2.change));
    } else if (sortMethod == AppBarButtons.sortByLoss) {
      this.data.sort((Stock stock1, Stock stock2) =>
          (stock1.change * -1).compareTo(stock2.change * -1));
    }

    for (Stock stock in this.data) {
      widgets.add(PortfolioStockElement(stock: stock));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppBarButtons>(
      builder: (BuildContext context, AppBarButtons value, Widget child) {
        return Column(
          children: this.generate(value),
        );
      },
      valueListenable: listenable,
    );
  }
}

class PortfolioStockElement extends StatelessWidget {
  final Stock stock;

  PortfolioStockElement({@required this.stock});

  OutlineInputBorder get border => (stock.change >= 0)
      ? OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: Colors.black87))
      : null;

  Color get color => (stock.changesPercentage >= 0) ? Colors.green : Colors.red;

  Color get shadow =>
      (stock.changesPercentage >= 0) ? null : Colors.black.withOpacity(0);

  IconData get icon => (stock.changesPercentage >= 0)
      ? Icons.arrow_upward
      : Icons.arrow_downward;

  double get elevation => (stock.changesPercentage >= 0) ? null : 0;

  String get change => (stock.changesPercentage >= 0)
      ? '+${stock.changesPercentage.toStringAsFixed(2)}%'
      : '-${stock.changesPercentage.toStringAsFixed(2)}%';

  void sell() {}

  void popUp() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Card(
      shape: border,
      elevation: elevation,
      shadowColor: shadow,
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
          radius: size.height / 37,
        ),
        title: Text(stock.symbol,
            style: theme.textTheme.headline6
                .copyWith(decoration: TextDecoration.underline)),
        subtitle: Text(change),
        trailing: Container(
          width: size.height / 18,
          child: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: popUp,
              ),
              Divider(),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.stackExchange),
                onPressed: sell,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
