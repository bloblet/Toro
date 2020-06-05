import 'package:bubble_chart/bubble_chart.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stockSimulator/widgets/stock.dart';
import '../bloc/API.dart';
import '../models/stock.dart';
import 'tabScaffold.dart';
import 'stock.dart';
import 'zoomScaffold.dart';

class PortfolioV2 extends StatelessWidget with ChangeNotifier {
  final ValueNotifier<AppBarButtons> sortMethod =
      ValueNotifier<AppBarButtons>(AppBarButtons.sortByAlpha);

  @override
  Widget build(BuildContext _) {
    return TabScaffold(
      body: (context) => MultiProvider(
        providers: [
          FutureProvider(
            create: (context) => API().getBalance(),
          ),
          FutureProvider(
            create: (context) => API().getBalance(),
          ),
        ],
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
            elevation: 0.0,
            leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  Provider.of<MenuController>(context, listen: false).toggle();
                }),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Card(child: Container(color: Colors.red, height: 100,),),
                Card(child: Container(color: Colors.orange, height: 100,),),
                Card(child: Container(color: Colors.amber, height: 100,),),
                Card(child: Container(color: Colors.yellow, height: 100,),),
                Card(child: Container(color: Colors.lightGreen, height: 100,),),
                Card(child: Container(color: Colors.green, height: 100,),),
                Card(child: Container(color: Colors.blue, height: 100,),),
                Card(child: Container(color: Colors.indigo, height: 100,),),
                Card(child: Container(color: Colors.purple, height: 100,),),
                Card(child: Container(color: Colors.deepPurple, height: 100,),),
              ]),
            )
          ],
        ),
      ),
    );

    // return TabScaffold(
    //   body: StreamBuilder(
    //     stream: API().getPortfolio().asStream(),
    //     builder: (BuildContext context, AsyncSnapshot<List<Stock>> snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.active:
    //           if (snapshot.hasData) {
    //             return PortfolioBody(
    //                 data: snapshot.data, listenable: sortMethod);
    //           }
    //           return LinearProgressIndicator();

    //         case ConnectionState.done:
    //           if (snapshot.hasData) {
    //             return PortfolioBody(
    //                 data: snapshot.data, listenable: sortMethod);
    //           }
    //           return Center(
    //               child: Text('No stocks yet!',
    //                   style: TextStyle(fontSize: 25, color: Colors.black45)));
    //         default:
    //           return LinearProgressIndicator();
    //       }
    //     },
    //   ),
    //   appBar: PreferredSize(
    //     preferredSize: AppBar().preferredSize,
    //     child: FutureProvider(
    //       create: (context) => API().getBalance(),
    //       builder: (context, child) => PortfolioAppBar(
    //             amount: Provider<double>.(create: null)
    //           ),
    //     ),
    //     // child: StreamBuilder(
    //     //   stream: API().getBalance().asStream(),
    //     //   builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
    //     //     if (snapshot.hasData) {
    //     //       return
    //     //     } else {
    //     //       return PortfolioAppBar(
    //     //         amount: 0,
    //     //         sortBy: (_) {},
    //     //       );
    //     //     }
    //     //   },
    //     // ),
    //   ),
    // );
  }
}

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

// class ChartHelpRoute extends MaterialPageRoute {
//   ChartHelpRoute() : super(builder: (BuildContext context) {

//     return
//   });
// }

// Because 600
