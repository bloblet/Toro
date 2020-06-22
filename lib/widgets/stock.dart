import 'dart:math';
import 'dart:ui';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stockSimulator/models/stock.dart';

enum AppBarButtons { sortByAlpha, sortByGains, sortByLoss }

class PortfolioBody extends StatelessWidget {
  final List<Stock> data;
  final ValueListenable<AppBarButtons> listenable;

  PortfolioBody({@required this.data, @required this.listenable});

  List<Widget> generate(sortMethod) {
    final List<Widget> widgets = [];

    if (sortMethod == AppBarButtons.sortByAlpha) {
      this.data.sort((Stock stock1, Stock stock2) =>
          stock1.symbol.compareTo(stock2.symbol));
    } else if (sortMethod == AppBarButtons.sortByGains) {
      this.data.sort((Stock stock1, Stock stock2) =>
          (stock1.changesPercentage * -1)
              .compareTo(stock2.changesPercentage * -1));
    } else if (sortMethod == AppBarButtons.sortByLoss) {
      this.data.sort((Stock stock1, Stock stock2) =>
          stock1.changesPercentage.compareTo(stock2.changesPercentage));
    }

    for (Stock stock in this.data) {
      widgets.add(PortfolioStockElement(stock: stock));
    }
    return widgets;
  }

  ListView generateColumn(value) {
    return ListView(
      children: this.generate(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppBarButtons>(
      builder: (BuildContext context, AppBarButtons value, Widget child) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: generateColumn(value),
        );
      },
      valueListenable: listenable,
    );
  }
}

class PortfolioStockElement extends StatefulWidget {
  final Stock stock;

  PortfolioStockElement({@required this.stock});

  @override
  _PortfolioStockElementState createState() => _PortfolioStockElementState();
}

class _PortfolioStockElementState extends State<PortfolioStockElement> {
  void sell() {
    Navigator.pushNamed(context, 'displayStock', arguments: widget.stock);
  }

  void popUp(BuildContext context) {
    const List<String> columnValues = [
      'price',
      'quantity',
      'dayHigh',
      'dayLow',
      'change',
      'changesPercentage',
      'eps',
      'exchange',
      'marketCap',
      'name',
      'openValue',
      'pe',
      'previousClose',
      'priceAvg200',
      'priceAvg50',
      'yearHigh',
      'yearLow',
    ];
    const List<String> columnNames = [
      'Price: ',
      'Quantiy: ',
      'Day High: ',
      'Day Low: ',
      'Change: ',
      'Changes Percentage: ',
      'EPS: ',
      'Exchange: ',
      'Market Cap: ',
      'Name: ',
      'Open Value: ',
      'PE: ',
      'Previous Close: ',
      'Price Avg 200: ',
      'Price Avg 50: ',
      'Year High: ',
      'Year Low: ',
    ];
    List<Widget> children = [];

    for (int pos in Iterable.generate(columnValues.length)) {
      String value = columnValues[pos];
      String name = columnNames[pos];
      if (this.widget.stock.raw[value] != null) {
        dynamic v = this.widget.stock.raw[value];
        switch (value) {
          case 'price':
            children.add(Text('$name\$$v'));
            break;
          case 'quantity':
            children.add(Text('$name$v'));
            break;
          case 'dayHigh':
            children.add(Text('$name\$$v'));
            break;
          case 'change':
            children
                .add(Text('$name${(v.isNegative) ? "-" : "+"}\$${v.abs()}'));
            break;
          case 'changesPercentage':
            children.add(Text('$name$v%'));
            break;
          case 'eps':
            children
                .add(Text('$name${(v.isNegative) ? "-" : "+"}\$${v.abs()}'));
            break;
          case 'exchange':
            children.add(Text('$name$v'));
            break;
          case 'marketCap':
            children.add(Text('$name\$$v'));
            break;
          case 'name':
            children.add(Text('$name$v'));
            break;
          case 'openValue':
            children.add(Text('$name\$$v'));
            break;
          case 'pe':
            children.add(Text('$name$v%'));
            break;
          case 'previousClose':
            children.add(Text('$name\$$v'));
            break;
          case 'priceAvg200':
            children.add(Text('$name\$$v'));
            break;
          case 'priceAvg50':
            children.add(Text('$name\$$v'));
            break;
          case 'yearHigh':
            children.add(Text('$name\$$v'));
            break;
          case 'yearLow':
            children.add(Text('$name\$$v'));
            break;

          default:
        }
        children.add(SizedBox(height: 3));
      }
    }

    children.insert(
        2,
        Text(
            'Today\'s Gain/Loss: ${((this.widget.stock.change * this.widget.stock.quantity).isNegative) ? "-" : "+"}\$${(this.widget.stock.change * this.widget.stock.quantity).abs().toStringAsFixed(2)}'));
    children.insert(3, SizedBox(height: 3));

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
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[Text(this.widget.stock.name), Divider()],
                ),
                content: Container(
                  height: (MediaQuery.of(context).size.height / 2),
                  width: (MediaQuery.of(context).size.width / 3) * 2,
                  child: ListView(
                    children: children,
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
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Card(
      color: (widget.stock.changesPercentage >= 0)
          ? Color(0xFFC4FFC5)
          : Color.fromRGBO(255, 209, 208, 1),
      child: ListTile(
        leading: CircleAvatar(
          child: Transform.rotate(
            angle: (widget.stock.changesPercentage.abs() >= 1.5) ? 0 : (widget.stock.changesPercentage.abs() >= 0.01) ? pi/4 : pi/2,
                      child: Icon(
              (widget.stock.changesPercentage >= 0)
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: (widget.stock.changesPercentage >= 0)
                  ? Color(0xFFE7E7E7)
                  : Color(0xFFDFDFDF),
            ),
          ),
          backgroundColor:
              (widget.stock.changesPercentage >= 0) ? Colors.green : Colors.red,
          radius: size.height / 37,
        ),
        title: Text(
          widget.stock.symbol,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            fontFeatures: [
              FontFeature.enable('lnum'),
            ],
          ),
        ),
        subtitle: Text('${widget.stock.changesPercentage.toStringAsFixed(2)}%',
            style: GoogleFonts.openSans()),
        trailing: Container(
          width: size.height / 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              DescribedFeatureOverlay(
                tapTarget: Icon(Icons.info_outline),
                featureId: 'infoButton',
                child: IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () => popUp(context),
                ),
                title: Text('Stock info'),
                description: Text(
                  'Shows a popup with all the info for the stock.  Try it!',
                ),
                backgroundColor: Colors.green[600],
              ),
              IconButton(
                icon: Icon(Icons.attach_money),
                onPressed: sell,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
