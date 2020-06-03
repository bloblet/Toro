import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stockSimulator/widgets/market.dart';

import 'portfoliov2.dart';

class TabScaffold extends StatelessWidget {
  final Widget body;
  final Widget appBar;
  final Widget fab;

  TabScaffold({
    this.fab,
    @required this.body,
    this.appBar,
    });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final hasNoPortfolioAncestry = context.findAncestorWidgetOfExactType<PortfolioV2>() == null;
    final hasNoMarketAncestry = context.findAncestorWidgetOfExactType<Market>() == null;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: fab,
        body: body,
        appBar: appBar,
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            FlatButton(
              child: Tab(
                icon: FaIcon(FontAwesomeIcons.shoppingBag),
              ),
              onPressed: () {
                if (hasNoPortfolioAncestry) {
                  Navigator.popAndPushNamed(context, 'portfolio');
                }
              },
            ),
            FlatButton(
              child: Tab(
                icon: FaIcon(FontAwesomeIcons.store),
              ),
              onPressed: () {
                if (hasNoMarketAncestry) {
                  Navigator.popAndPushNamed(context, 'market');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}