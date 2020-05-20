import 'package:bubble_chart/bubble_chart.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/API.dart';
import '../models/stock.dart';
import 'tabScaffold.dart';

class PortfolioV2 extends StatelessWidget with ChangeNotifier {
  final ValueNotifier<AppBarButtons> sortMethod =
      ValueNotifier<AppBarButtons>(AppBarButtons.sortByAlpha);

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      body: StreamBuilder(
        stream: API().getPortfolio().asStream(),
        builder: (BuildContext context, AsyncSnapshot<List<Stock>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              if (snapshot.hasData) {
                return PortfolioBody(data: snapshot.data, listenable: sortMethod);
              }
              return LinearProgressIndicator();

            case ConnectionState.done:
              if (snapshot.hasData) {
                return PortfolioBody(data: snapshot.data, listenable: sortMethod);
              }
              return Center(
                child: Text(
                  'No stocks yet!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black45
                  )
                )
              );
            default:
            return LinearProgressIndicator();
          }
        },
      ),
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: StreamBuilder(
          stream: API().getBalance().asStream(),
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            if (snapshot.hasData) {
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
    );
  }
}

enum AppBarButtons { sortByAlpha, sortByGains, sortByLoss }

class PortfolioAppBar extends StatefulWidget {
  final double amount;

  final Function(AppBarButtons) sortBy;

  PortfolioAppBar({@required this.amount, @required this.sortBy});

  @override
  _PortfolioAppBarState createState() => _PortfolioAppBarState();
}

class _PortfolioAppBarState extends State<PortfolioAppBar> {
  @override
  void initState() {
    // ...
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{'displayChart', 'alphaSort', 'gainSort', 'lossSort'},
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Text('\$${this.widget.amount}'),
      ),
      actions: <Widget>[
        DescribedFeatureOverlay(
          featureId: 'displayChart',
          tapTarget: Icon(Icons.bubble_chart),
          title: Text('Stock Chart'),
          backgroundColor: Colors.green[600],
          child: IconButton(
            icon: Icon(Icons.bubble_chart),
            onPressed: () {
              Navigator.push(context, ChartRoute());
              FeatureDiscovery.clearPreferences(
                context,
                const <String>{
                  'displayChart',
                  'alphaSort',
                  'gainSort',
                  'lossSort',
                  'infoButton'
                },
              );
            },
          ),
          description: Text('Shows a neat chart that shows all your stats.'),
        ),
        DescribedFeatureOverlay(
          featureId: 'alphaSort',
          tapTarget: Icon(Icons.sort_by_alpha),
          title: Text('Alphabetical sorting'),
          backgroundColor: Colors.green[600],
          child: IconButton(
            icon: Icon(Icons.sort_by_alpha),
            onPressed: () => this.widget.sortBy(AppBarButtons.sortByAlpha),
          ),
          description: Text('Sorts all your stocks alphabetically.'),
        ),
        DescribedFeatureOverlay(
          featureId: 'gainSort',
          tapTarget: Icon(Icons.arrow_upward),
          title: Text('Gain sorting'),
          backgroundColor: Colors.green[600],
          child: IconButton(
            icon: Icon(Icons.arrow_upward),
            onPressed: () => this.widget.sortBy(AppBarButtons.sortByGains),
          ),
          description:
              Text('Sorts all your stocks by the percent that they gained.'),
        ),
        DescribedFeatureOverlay(
          featureId: 'lossSort',
          tapTarget: Icon(Icons.arrow_downward),
          title: Text('Loss sorting'),
          backgroundColor: Colors.green[600],
          child: IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: () => this.widget.sortBy(AppBarButtons.sortByLoss),
          ),
          description:
              Text('Sorts all your stocks by the percent that they lost.'),
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
          (stock1.changesPercentage * -1)
              .compareTo(stock2.changesPercentage * -1));
    } else if (sortMethod == AppBarButtons.sortByLoss) {
      this.data.sort((Stock stock1, Stock stock2) =>
          stock1.changesPercentage.compareTo(stock2.changesPercentage));
    }

    for (Stock stock in this.data) {
      widgets.add(PortfolioStockElement(stock: stock));
    }
    return widgets;
  }

  Column generateColumn(value) {
    return Column(
      key: UniqueKey(),
      children: this.generate(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppBarButtons>(
      builder: (BuildContext context, AppBarButtons value, Widget child) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: generateColumn(value),
        );
      },
      valueListenable: listenable,
    );
  }
}

class PortfolioStockElement extends StatefulWidget {
  final Stock stock;

  PortfolioStockElement({@required this.stock});

  @override
  _PortfolioStockElementState createState() => _PortfolioStockElementState();
}

class _PortfolioStockElementState extends State<PortfolioStockElement> {
  @override
  void initState() {
    // ...
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{'infoButton'},
      );
    });
    super.initState();
  }

  void sell() {}

  void popUp(BuildContext context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(this.widget.stock.name),
                content: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    children: <Widget>[
                      Text('Price: ${this.widget.stock.price}'),
                      Text('Change: ${this.widget.stock.change}'),
                      Text(
                          'Today\'s Gain/Loss: ${(this.widget.stock.change * this.widget.stock.price * this.widget.stock.quantity).toStringAsFixed(2)}'),
                      Text('Open: ${this.widget.stock.openValue}'),
                      Text('Previous Close: ${this.widget.stock.previousClose}'),
                      Text('Day high: ${this.widget.stock.dayHigh}'),
                      Text('Day low: ${this.widget.stock.dayLow}'),
                      Text('52-Week High: ${this.widget.stock.yearHigh}'),
                      Text('52-Week Low: ${this.widget.stock.yearLow}')
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Card(
      // shape: (stock.changesPercentage >= 0)
      //     ? OutlineInputBorder(
      //         borderSide: BorderSide(width: 1.0, color: Colors.black87))
      //     : null,
      // elevation: (stock.changesPercentage >= 0) ? null : 0,
      // shadowColor: (stock.changesPercentage >= 0) ? null : Colors.black.withOpacity(0),
      color: (widget.stock.changesPercentage >= 0)
          ? Color(0xFFC4FFC5)
          : Color.fromRGBO(255, 209, 208, 1),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            (widget.stock.changesPercentage >= 0)
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: (widget.stock.changesPercentage >= 0)
                ? Color(0xFFE7E7E7)
                : Color(0xFFDFDFDF),
          ),
          backgroundColor:
              (widget.stock.changesPercentage >= 0) ? Colors.green : Colors.red,
          radius: size.height / 37,
        ),
        title: Text(widget.stock.symbol, style: theme.textTheme.headline6),
        subtitle: Text('${widget.stock.changesPercentage.toStringAsFixed(2)}%'),
        trailing: Container(
          width: size.height / 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              DescribedFeatureOverlay(
                tapTarget: Icon(Icons.info_outline),
                featureId: 'infoButton',
                child: IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () => popUp(context),
                ),
                title: Text('Stock info'),
                description: Text('Shows a popup with all the info for the stock.  Try it!'),
                backgroundColor: Colors.green[600],
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.moneyBill),
                onPressed: sell,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartRoute extends MaterialPageRoute {
  ChartRoute() : super(builder: (BuildContext context) => ChartPage());
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Stats'),
      ),
      body: AnimatedOpacity(
        opacity: animation.value,
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 200),
        child: ChartPage(),
      ),
    );
  }
}

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BubbleChart();
  }
}

class BubbleChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<Stock>>(
      stream: API().getPortfolio().asStream(),
      builder: (context, AsyncSnapshot<List<Stock>> snapshot) {
        if (snapshot.hasData) {
          final List<BubbleNode> bubbles = [];
          for (Stock stock in snapshot.data) {
            double changesPercentage = stock.changesPercentage.abs();
            Color color;

            if (stock.changesPercentage.isNegative) {
              if (changesPercentage <= 0.5) {
                color = Colors.red[100];
              } else if (changesPercentage <= 1) {
                color = Colors.red[200];
              } else if (changesPercentage <= 1.5) {
                color = Colors.red[300];
              } else if (changesPercentage <= 2) {
                color = Colors.red[400];
              } else if (changesPercentage <= 2.5) {
                color = Colors.red[500];
              } else if (changesPercentage <= 3) {
                color = Colors.red[600];
              } else {
                color = Colors.red[700];
              }
            } else {
              if (changesPercentage <= 0.5) {
                color = Colors.green[100];
              } else if (changesPercentage <= 1) {
                color = Colors.green[200];
              } else if (changesPercentage <= 1.5) {
                color = Colors.green[300];
              } else if (changesPercentage <= 2) {
                color = Colors.green[400];
              } else if (changesPercentage <= 2.5) {
                color = Colors.green[500];
              } else if (changesPercentage <= 3) {
                color = Colors.green[600];
              } else {
                color = Colors.green[700];
              }
            }

            bubbles.add(
              BubbleNode.leaf(
                options: BubbleOptions(
                  child: Text(
                    stock.symbol,
                    style: theme.textTheme.headline6
                      .copyWith(fontWeight: FontWeight.w400),
                  ),
                  color: color),
                value: stock.price,
              ),
            );
          }
          return BubbleChartLayout(
            root: BubbleNode.node(
              padding: 8,
              children: bubbles,
            ),
          );
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }
}

class ChartHelpRoute extends MaterialPageRoute {
  ChartHelpRoute() : super(builder: (BuildContext context) {

    return
  });
}
