import 'dart:math';
import 'dart:ui';

import 'package:Stocklet/bloc/API.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toro_models/toro_models.dart';

enum AppBarButtons { sortByAlpha, sortByGains, sortByLoss }

class PortfolioBody extends StatelessWidget {
  final Map<String, int> data;
  final ValueListenable<AppBarButtons> listenable;

  PortfolioBody({@required this.data, @required this.listenable});

  List<Widget> generate(sortMethod) {
    final List<Widget> widgets = [];

    for (String stock in data.keys) {
      widgets.add(PortfolioStockElement(stock: stock, quantity: data[stock]));
    }
    return widgets;
  }

  ListView generateColumn(value) {
    return ListView(
      children: generate(value),
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
  final String stock;
  final int quantity;

  PortfolioStockElement({@required this.stock, @required this.quantity});

  @override
  _PortfolioStockElementState createState() => _PortfolioStockElementState();
}

class _PortfolioStockElementState extends State<PortfolioStockElement> {
  Stock stock;

  void sell() {
    Navigator.pushNamed(context, 'displayStock', arguments: stock);
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
                  children: <Widget>[Text(this.widget.stock), Divider()],
                ),
                content: Container(
                  height: (MediaQuery.of(context).size.height / 2),
                  width: (MediaQuery.of(context).size.width / 3) * 2,
                  child: ListView(
                    children: [
                      Text(
                          'Today\'s Gain/Loss: ${((stock.change * stock.quantity).isNegative) ? "-" : "+"}\$${(stock.change * stock.quantity).abs().toStringAsFixed(2)}'),
                      SizedBox(height: 3),
                      Text(
                          'Price: \$${stock.price.toStringAsFixed(2)}'),
                      (stock.change.isNegative)
                          ? Text(
                              'Change: -\$${stock.change.toStringAsFixed(2)}')
                          : Text(
                              'Change: +\$${stock.change.toStringAsFixed(2)}'),
                      (stock.changePercentage.isNegative)
                          ? Text(
                              'Change percent: -\$${stock.changePercentage.toStringAsFixed(2)}')
                          : Text(
                              'Change percent: +\$${stock.changePercentage.toStringAsFixed(2)}'),
                      Text('Open: ${stock.open}'),
                      Text('Quantity: ${stock.quantity}'),
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
        pageBuilder: (context, animation1, animation2) => Container());
  }

  @override
  Widget build(BuildContext context) {
    if (stock == null) {
      return FutureProvider.value(
          value: API().getStock(widget.stock),
          builder: (BuildContext context, _) {
            stock = Provider.of<Stock>(context);
            return buildChild(context);
          });
    } else {
      return buildChild(context);
    }
  }

  Widget buildChild(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      color: (stock.changePercentage >= 0)
          ? Color(0xFFC4FFC5)
          : Color.fromRGBO(255, 209, 208, 1),
      child: ListTile(
        leading: CircleAvatar(
          child: Transform.rotate(
            angle: (stock.changePercentage.abs() >= 1.5)
                ? 0
                : (stock.changePercentage.abs() >= 0.01)
                    ? pi / 4
                    : pi / 2,
            child: Icon(
              (stock.changePercentage >= 0)
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: (stock.changePercentage >= 0)
                  ? Color(0xFFE7E7E7)
                  : Color(0xFFDFDFDF),
            ),
          ),
          backgroundColor:
              (stock.changePercentage >= 0) ? Colors.green : Colors.red,
          radius: size.height / 37,
        ),
        title: Text(
          stock.symbol,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            fontFeatures: [
              FontFeature.enable('lnum'),
            ],
          ),
        ),
        subtitle: Text('${stock.changePercentage.toStringAsFixed(2)}%',
            style: GoogleFonts.openSans()),
        trailing: Container(
          width: size.height / 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () => popUp(context),
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
