import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'tabScaffold.dart';
import 'zoomScaffold.dart';
import 'package:fl_chart/fl_chart.dart';

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
                          color: (!me.change.isNegative) ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                      Text(
                      me.formattedChange,
                        style: TextStyle(
                          color:  (!me.change.isNegative) ? Colors.green[700] : Colors.red[700],
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        'As of ' + DateFormat('jmz d/M/y').format(me.lastUpdatedBalance),
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
                  child: Divider(),
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
                      SummaryChart()
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

class SummaryChart extends StatefulWidget {
  @override
  _SummaryChartState createState() => _SummaryChartState();
}

class _SummaryChartState extends State<SummaryChart> {
  List<FlSpot> spots = [];
  double startMonth;
  final me = User.me;

  @override
  void initState() {
    // final balanceHistory = me.balanceHistory;

    // List<DateTime> balanceTimes = balanceHistory.keys.toList()..sort();

    // final firstTime = balanceTimes.first;

    // for (DateTime balanceTime in balanceTimes) {

    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: (spots.isEmpty)
          ? CircularProgressIndicator()
          : LineChart(
              LineChartData(
                lineBarsData: [LineChartBarData(spots: spots)],
                gridData: FlGridData(
                  show: false,
                ),
              ),
            ),
    );
  }
}
