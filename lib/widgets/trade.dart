import 'package:flutter/material.dart';
import 'package:stockSimulator/widgets/tabScaffold.dart';
import 'zoomScaffold.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class TradeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final me = User.me;

    return TabScaffold(
        body: (zoomContext) => CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                floating: true,
                snap: true,
                expandedHeight: 50,
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
                title: Text('Trade Stocks/ETFs'),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Cash Available to Trade',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '\$12,345.67',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Cash Committed to Open Orders',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '\$2,345.67',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Settled Cash',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '\$15,345.67',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      child: Divider(
                        thickness: 6,
                        color: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
              ),
            ]));
  }
}
