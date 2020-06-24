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
                    children: [
                      Text(
            'Today\'s Gain/Loss: ${((this.widget.stock.change * this.widget.stock.quantity).isNegative) ? "-" : "+"}\$${(this.widget.stock.change * this.widget.stock.quantity).abs().toStringAsFixed(2)}'),
                      SizedBox(height: 3),
                      Text('Price: \$${this.widget.stock.price.toStringAsFixed(2)}'),
                      (this.widget.stock.change.isNegative)
                        ? Text('Change: -\$${this.widget.stock.change.toStringAsFixed(2)}')
                        : Text('Change: +\$${this.widget.stock.change.toStringAsFixed(2)}'),
                      (this.widget.stock.changesPercentage.isNegative) ?
                      Text('Change percent: -\$${this.widget.stock.changesPercentage.toStringAsFixed(2)}')
                      : Text('Change percent: +\$${this.widget.stock.changesPercentage.toStringAsFixed(2)}'),
                      Text('Open: ${this.widget.stock.open}'),
                      Text('Quantity: ${this.widget.stock.quantity}'),
                      SizedBox(height: 3),

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
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Card(
      color: (widget.stock.changesPercentage >= 0)
          ? Color(0xFFC4FFC5)
          : Color.fromRGBO(255, 209, 208, 1),
      child: ListTile(
        leading: CircleAvatar(
          child: Transform.rotate(
            angle: (widget.stock.changesPercentage.abs() >= 1.5)
                ? 0
                : (widget.stock.changesPercentage.abs() >= 0.01)
                    ? pi / 4
                    : pi / 2,
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
