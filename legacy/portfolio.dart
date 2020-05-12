import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockSimulator/models/API.dart';

import 'chart.dart';
import 'models/stock.dart';

class Chart extends StatelessWidget {
  final List<Stock> portfolio;
  Chart(this.portfolio);

  Map<String, double> calculate() {
    // Calculate the total price
    double totalValue = 0;
    for (Stock stock in this.portfolio) {
      totalValue += (stock.price * stock.quantity);
    }
    Map<String, double> chart = {};

    for (Stock stock in this.portfolio) {
      double valuePercent = (stock.price * stock.quantity) / totalValue;
      chart[stock.symbol] = valuePercent;
    }
    print(chart);
    return chart;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 5,
          child: CustomPieChart(this.portfolio),
        ),
        Divider()
      ],
    );
  }
}

class PortfolioElement extends StatelessWidget {
  final Widget child1;
  final Widget child2;
  PortfolioElement(this.child1, this.child2);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: (MediaQuery.of(context).size.width / 2),
          height: MediaQuery.of(context).size.width / 4,
          padding: EdgeInsets.only(left: 8, right: 4),
          child: Card(color: Colors.blueGrey[400], child: this.child1),
        ),
        Container(
          width: (MediaQuery.of(context).size.width / 2),
          height: MediaQuery.of(context).size.width / 4,
          padding: EdgeInsets.only(right: 8, left: 4),
          child: Card(color: Colors.blueGrey[300], child: this.child2),
        ),
      ],
    );
  }
}

class PortfolioElementSingle extends StatelessWidget {
  final Widget child;
  PortfolioElementSingle(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      height: MediaQuery.of(context).size.width / 4,
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Card(color: Colors.blueGrey[300], child: this.child),
    );
  }
}

class PortfolioStock extends StatelessWidget {
  final Stock stock;

  PortfolioStock(this.stock);

  popUp(BuildContext context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Advanced info'),
                content: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    children: <Widget>[
                      Text('Price: ${stock.price}'),
                      Text('Change: ${stock.change}'),
                      Text(
                          'Today\'s Gain/Loss: ${(stock.change * stock.price * stock.quantity).toStringAsFixed(2)}'),
                      Text('Open: ${stock.openValue}'),
                      Text('Previous Close: ${stock.previousClose}'),
                      Text('Day high: ${stock.dayHigh}'),
                      Text('Day low: ${stock.dayLow}'),
                      Text('52-Week High: ${stock.yearHigh}'),
                      Text('52-Week Low: ${stock.yearLow}')
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () => popUp(context),
      onLongPress: () => popUp(context),
      onTap: () => popUp(context),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundColor: (this.stock.change >= 0)
                  ? Colors.green[300]
                  : Colors.red[300],
              child: Text(this.stock.symbol,
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 90))),
              maxRadius: 30,
              minRadius: 20,
            ),
            title: Text('\$${this.stock.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            dense: true,
            subtitle: Text('x${this.stock.quantity}'),
          ),
          Text(
              '\$${(this.stock.price * this.stock.quantity).toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}

class Portfolio extends StatefulWidget {
  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  List<Stock> lastStocks;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: API.portfolioCache,
      future: API().getPortfolio(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                      itemCount: (snapshot.data.length / 2).ceil() + 2,
                      itemBuilder: (BuildContext context, int pos) {
                        if (pos == 0) {
                          List<Stock> data = [];
                          data.addAll(snapshot.data);
                          data.sort(
                              (Stock a, Stock b) => a.price.compareTo(b.price));

                          return Column(
                            children: <Widget>[
                              Center(
                                child: Text('Your top stock', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                              ),
                              Divider(
                                  color: Colors.black87,
                                  indent: 13,
                                  endIndent: 13),
                              PortfolioElementSingle(PortfolioStock(data[0])),
                              Divider(
                                  color: Colors.black54,
                                  indent: 13,
                                  endIndent: 13),
                            ],
                          );
                        }
                        --pos;
                        if (pos == (snapshot.data.length / 2).ceil()) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(),
                          );
                        }

                        if (snapshot.data.length.isOdd &&
                            (snapshot.data.length / 2).ceil() - 1 == pos) {
                          return PortfolioElementSingle(
                            PortfolioStock(snapshot.data[pos * 2]),
                          );
                        }
                        return PortfolioElement(
                          PortfolioStock(snapshot.data[pos * 2]),
                          PortfolioStock(snapshot.data[(pos * 2) + 1]),
                        );
                      }),
                );
              } else {
                return Text(snapshot.error.toString());
              }
            }

            break;
          default:
            {
              return Center(
                child: Container(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()),
              );
            }
            break;
        }
      },
    );
  }
}
