import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tabScaffold.dart';
import 'zoomScaffold.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      body: (zoomContext) => CustomScrollView(
        slivers: <Widget>[
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
            // Pretend this is a normal appbar
            title: Text(
              'Summary'
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Your Balance Details",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "\$1,234,567.27",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        "Today's gain/loss",
                        style: TextStyle(
                          color: Colors.green[700],//balance going up ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                      Text(
                        "+\$12,345.34",
                        style: TextStyle(
                          color: Colors.green[700],//balance going up ? Colors.green[700] : Colors.red[700],
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        "As of 12:10PM ET 6/22/20",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Your Balance History",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Container(
                        child: SfCartesianChart(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Top Gainers/Losers",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
