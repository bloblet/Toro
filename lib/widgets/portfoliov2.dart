import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stockSimulator/models/balance.dart';
import 'package:stockSimulator/models/portfolio.dart';
import 'package:stockSimulator/widgets/stock.dart';
import '../models/stock.dart';
import 'fadeOnScroll.dart';
import 'stockSimIcons.dart';
import 'tabScaffold.dart';
import 'stock.dart';
import 'zoomScaffold.dart';

class PortfolioV2 extends StatelessWidget {
  final GlobalKey balanceEventKey = GlobalKey(debugLabel: 'balanceEventKey');
  final GlobalKey portfiolioEventKey =
      GlobalKey(debugLabel: 'portfiolioEventKey');

  @override
  Widget build(BuildContext _) {
    return TabScaffold(
      body: (zoomContext) => CustomScrollView(
        slivers: <Widget>[
          FutureProvider<BalanceEvent>.value(
            key: balanceEventKey,
            updateShouldNotify: (previous, current) {
              print('Update attempt...');
              if (previous.state != current.state) {
                print('rebuilding... (state changed)');
                return true;
              }
              if (previous.balance == current.balance &&
                  previous.stockValue == current.stockValue) {
                print('values are the same, aborting');
                return false;
              }
              print('rebuilding');
              return true;
            },
            value: BalanceEvent.getBalance(),
            initialData: BalanceEvent.cached(),
            builder: (balanceContext, child) {
              BalanceEvent event = Provider.of<BalanceEvent>(balanceContext);
              return SliverAppBar(
                elevation: 0,
                floating: true,
                snap: true,
                expandedHeight: 200,
                centerTitle: true,
                pinned: true,
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Provider.of<MenuController>(zoomContext, listen: false)
                      ..toggle();
                  },
                ),
                title: Text(
                  '\$${event.totalValue.toStringAsFixed(2)}',
                  style: GoogleFonts.raleway(
                    fontSize: 25,
                    fontFeatures: [
                      FontFeature.enable('lnum'),
                    ],
                  ),
                ),
                flexibleSpace: FadeOnScroll(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            StockSimIcons.wallet,
                            color: Colors.black.withOpacity(0.78),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            '\$${event.balance.toStringAsFixed(2)}',
                            style: GoogleFonts.raleway(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              fontFeatures: [
                                FontFeature.enable('lnum'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(balanceContext).size.width / 6,
                        height: MediaQuery.of(balanceContext).size.height / 11,
                        child: Center(
                            child: VerticalDivider(
                          width: 2,
                          color: Colors.black.withOpacity(0.70),
                        )),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            StockSimIcons.layer_group,
                            color: Colors.black.withOpacity(0.78),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            '\$${event.stockValue.toStringAsFixed(2)}',
                            style: GoogleFonts.raleway(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              fontFeatures: [
                                FontFeature.enable('lnum'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          FutureProvider<PortfolioEvent>.value(
            key: portfiolioEventKey,
            value: PortfolioEvent.getPortfolio(),
            initialData: PortfolioEvent([], ConnectionState.waiting),
            builder: (context, child) {
              final portfolioEvent = Provider.of<PortfolioEvent>(context);
              if (portfolioEvent.state != ConnectionState.done) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
              final List<Widget> children = [];
              for (Stock stock in portfolioEvent.data) {
                children.add(PortfolioStockElement(stock: stock));
                children.add(PortfolioStockElement(stock: stock));
              }
              return SliverList(
                delegate: SliverChildListDelegate(children),
              );
            },
          ),
        ],
      ),
    );
  }
}
