import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:stockSimulator/components/welcome_page_button.dart';
import 'package:stockSimulator/widgets/stock.dart';
import '../models/stock.dart';
import 'fadeOnScroll.dart';
import 'stockSimIcons.dart';
import 'tabScaffold.dart';
import 'stock.dart';
import 'zoomScaffold.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class PortfolioV2 extends StatelessWidget {
  final GlobalKey balanceEventKey = GlobalKey(debugLabel: 'balanceEventKey');
  final GlobalKey portfiolioEventKey =
      GlobalKey(debugLabel: 'portfiolioEventKey');

  @override
  Widget build(BuildContext _) {
    return TabScaffold(
      body: (zoomContext) => CustomScrollView(
        slivers: <Widget>[
          ListenableProvider.value(
            value: Hive.box<User>('me')
                .listenable(keys: ['balance', 'totalValue', 'investedValue']),
            key: balanceEventKey,
            // updateShouldNotify: (previous, current) {
            //   print('Update attempt...');
            //   if (previous.state != current.state) {
            //     print('rebuilding... (state changed)');
            //     return true;
            //   }
            //   if (previous.balance == current.balance &&
            //       previous.stockValue == current.stockValue) {
            //     print('values are the same, aborting');
            //     return false;
            //   }
            //   print('rebuilding');
            //   return true;
            // },
            builder: (balanceContext, child) {
              User user = Hive.box<User>('me').get('me');
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
                  '\$${user.totalValue.toStringAsFixed(2)}',
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
                            '\$${user.balance.toStringAsFixed(2)}',
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
                            '\$${user.investedValue.toStringAsFixed(2)}',
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
          ListenableProvider.value(
            key: portfiolioEventKey,
            value: Hive.box<User>('me').listenable(keys: ['inventory']),
            builder: (context, child) {
              User user = Hive.box<User>('me').get('me');
              final List<Widget> children = [];
              for (Stock stock in user.inventory) {
                children.add(PortfolioStockElement(stock: stock));
                children.add(PortfolioStockElement(stock: stock));
              }
              if (children.isEmpty) {
                children.add(SizedBox(height: 16));
                children.add(
                  Center(
                    child: WelcomePageButton(
                      text: 'No stocks yet.  Try going to Discover!',
                      color: Colors.green,
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, 'discover'),
                    ),
                  ),
                );
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
