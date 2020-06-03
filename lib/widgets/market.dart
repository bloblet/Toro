import 'package:flutter/material.dart';
import 'package:stockSimulator/models/API.dart';
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
    return TabScaffold(
      body: Container(),
      appBar: AppBar(),
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
            case ConnectionState.none: {

                return LinearProgressIndicator();
              }
              break;

            case ConnectionState.waiting: {
                return LinearProgressIndicator();
              }
              break;

            case ConnectionState.active: {
                return LinearProgressIndicator();
              }
              break;

            case ConnectionState.done: {
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
                      Text('You gained \$${total.abs().toStringAsFixed(2)} today!'),
                    ],
                  );
                }
              }
              break;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('')
            ],
          );


        }
      ),
    );
  }
}
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController =  TextEditingController();
  List<Map<String, dynamic>> terms = [];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration.collapsed(hintText: "Search"),
          onChanged: (value) async {
            terms = await API().search(value);
            print(terms);
            setState((){});
          },
          controller: searchController,
        ),
      ),
      body: Center()
    );
  }
}