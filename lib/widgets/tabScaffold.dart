import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'portfoliov2.dart';

class TabScaffold extends StatelessWidget {
  final Widget body;
  final Widget appBar;

  TabScaffold({
    @required this.body,
    @required this.appBar,
    });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final hasNoPortfolioAncestry = context.findAncestorWidgetOfExactType<PortfolioV2>() == null;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
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
          ],
        ),
      ),
    );
  }
}