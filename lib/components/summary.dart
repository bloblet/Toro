import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'tabScaffold.dart';
import 'zoomScaffold.dart';
import 'package:fl_animated_linechart/main.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final me = User.me;

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
            title: Text('Summary'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.all(20),
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
                        me.formattedBalance,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        "Today's gain/loss",
                        style: TextStyle(
                          color: (!me.change.isNegative)
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                      Text(
                        me.formattedChange,
                        style: TextStyle(
                          color: (!me.change.isNegative)
                              ? Colors.green[700]
                              : Colors.red[700],
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        'As of ' +
                            DateFormat('h:m M/d/y')
                                .format(me.lastUpdatedBalance),
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
                  child: Divider(
                    thickness: 7,
                    color: Colors.grey[200],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Your Balance History",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: SummaryChart(),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                  child: Divider(
                    thickness: 7,
                    color: Colors.grey[200],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
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

class SummaryChart extends StatelessWidget{
  final Map<int, String> months = {
    DateTime.january: 'January',
    DateTime.february: 'February',
    DateTime.march: 'March',
    DateTime.april: 'April',
    DateTime.may: 'May',
    DateTime.june: 'June',
    DateTime.july: 'July',
    DateTime.august: 'August',
    DateTime.september: 'September',
    DateTime.october: 'October',
    DateTime.november: 'November',
    DateTime.december: 'December',
  };

  final me = User.me;
  Map<DateTime, double> getChartData() {
    final balanceHistory = me.balanceHistory;
    if (balanceHistory.length == 1) {
      balanceHistory[DateTime.now()] = 0;
    }
    return balanceHistory;
  }

  final summaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: (false)
          ? Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedLineChart(
                LineChart.fromDateTimeMaps(
                  [getChartData()],
                  [Colors.blue],
                  ['USD'],
                ),
                key: summaryKey,
              ),
            ),
    );
  }
}
