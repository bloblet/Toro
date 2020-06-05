import 'package:flutter/material.dart';
import '../bloc/API.dart';
import 'package:stockSimulator/models/stock.dart';
import 'package:stockSimulator/widgets/tabScaffold.dart';
import 'dart:async';

final routeObserver = RouteObserver<PageRoute>();
final duration = const Duration(milliseconds: 300);

class Market extends StatefulWidget {
  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> with RouteAware {
  GlobalKey _fabKey = GlobalKey();
  bool _fabVisible = true;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  didPopNext() {
    // Show back the FAB on transition back ended
    Timer(duration, () {
      setState(() => _fabVisible = true);
    });
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size.width,
        height: size.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }

  _onFabTap(BuildContext context) {
    // Hide the FAB on transition start
    setState(() => _fabVisible = false);

    final RenderBox fabRenderBox = _fabKey.currentContext.findRenderObject();
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          SearchPage(),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(child, animation, fabSize, fabOffset),
    ));
  }

  Widget _buildFAB(context, {key}) => FloatingActionButton(
        key: key,
        onPressed: () => _onFabTap(context),
        backgroundColor: Color.fromRGBO(76, 175, 80, 1),
        child: Icon(Icons.search),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabScaffold(
      body: (context) => FutureBuilder(
          future: API().topGain(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final List<Widget> children = [
                  SizedBox(height: 8),
                  Text("Today's top gainers", style: theme.textTheme.headline5),
                  SizedBox(height: 8),
                  Divider(height: 3, color: Colors.grey[600], endIndent: 10),
                  SizedBox(height: 16),
                  // Container(
                  //   decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),

                  //   child: Image.network(
                  //     'https://unsplash.com/photos/uJhgEXPqSPk/download?force=true&w=1920',
                  //   ),
                  // ),
                ];
                for (Stock stock in snapshot.data) {
                  children.add(ListTile(
                      leading: Text(stock.symbol),
                      title: Text('\$${stock.price.toStringAsFixed(2)}'),
                      subtitle: Text(
                          '${(stock.change.isNegative) ? '-' : '+'}\$${stock.change.abs().toStringAsFixed(2)} today'),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.assessment),
                            onPressed: () {}
                          ),
                          IconButton(
                            icon: Icon(Icons.attach_money),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      dense: true));
                  if (snapshot.data.indexOf(stock) !=
                      snapshot.data.length - 1) {
                    children.add(Divider(height: 2, color: Colors.grey));
                  }
                }

                return ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: children,
                              mainAxisSize: MainAxisSize.min,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                break;
              default:
                return LinearProgressIndicator();
            }
          }),
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: StreamBuilder(
          stream: API().getBalance().asStream(),
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            if (snapshot.hasData) {
              return AppBar(title: Text('\$${snapshot.data.toStringAsFixed(2)}'));
            } else {
              return AppBar(title: Text('\$0'));
            }
          },
        ),
      ),
      fab: Visibility(
        visible: _fabVisible,
        child: _buildFAB(context, key: _fabKey),
      ),
    );
  }
}

class MarketGainLoss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: StreamBuilder<List<Stock>>(
          stream: API().getPortfolio().asStream(),
          builder: (BuildContext context, AsyncSnapshot<List<Stock>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                {
                  return LinearProgressIndicator();
                }
                break;

              case ConnectionState.waiting:
                {
                  return LinearProgressIndicator();
                }
                break;

              case ConnectionState.active:
                {
                  return LinearProgressIndicator();
                }
                break;

              case ConnectionState.done:
                {
                  double total = 0;
                  for (Stock stock in snapshot.data) {
                    total += (stock.change * stock.quantity);
                  }
                  if (total.isNegative) {
                    return Column(
                      children: <Widget>[
                        Icon(Icons.monetization_on),
                        SizedBox(height: 8),
                        Text('You lost \$${total.abs().toStringAsFixed(2)}!'),
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        Icon(Icons.monetization_on),
                        SizedBox(height: 8),
                        Text(
                            'You gained \$${total.abs().toStringAsFixed(2)} today!'),
                      ],
                    );
                  }
                }
                break;
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[Text('')],
            );
          }),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List terms = [];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration.collapsed(hintText: "Search"),
          onChanged: (value) async {
            terms = await API().search(value);
            print(terms);
            setState(() {});
          },
          controller: searchController,
        ),
      ),
      body: ListView.builder(
        itemCount: terms.length,
        itemBuilder: (context, index) {
          final stock = terms[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(stock['name']),
                subtitle: Text(stock['symbol']),
                trailing: Text(stock['price'].toString()),
              ),
              Divider(height: 2, color: Colors.grey)
            ],
          );
        },
      ),
    );
  }
}
