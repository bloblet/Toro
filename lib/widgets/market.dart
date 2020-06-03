import 'package:flutter/material.dart';
import 'package:stockSimulator/models/API.dart';
import 'package:stockSimulator/models/stock.dart';
import 'package:stockSimulator/widgets/tabScaffold.dart';
import 'package:adv_fab/adv_fab.dart';

class Market extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context).settings.arguments;

    // return TabScaffold(
    //   body: StreamBuilder(
    //     stream: API().balanceStream.stream.asBroadcastStream(),
    //     builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
    //       if (snapshot.hasData) {
    final size = MediaQuery.of(context).size;

    return TabScaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          MarketReccomendedStocks(),
          SizedBox(height: 16),
          MarketGainLoss(),


        ],
      ),
    );

    //       } else {
    //         return MarketAppBar(
    //           amount: 0,
    //         );
    //       }
    //     },
    //   ),
    //   appBar: PreferredSize(
    //     preferredSize: AppBar().preferredSize,
    //     child: StreamBuilder(
    //       stream: API().balanceStream.stream,
    //       builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
    //         if (snapshot.hasData) {
    //           return MarketAppBar(amount: snapshot.data);
    //         } else {
    //           return MarketAppBar(
    //             amount: 0,
    //           );
    //         }
    //       },
    //     ),
    //   ),
    // );
  }
}

class MarketGainLoss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(

      elevation: 4,
      child: StreamBuilder<List<Stock>>(
        stream: API().getPortfolio().asStream(),
        builder: (BuildContext context, AsyncSnapshot<List<Stock>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: {

                return LinearProgressIndicator();
              }
              break;

            case ConnectionState.waiting: {
                return LinearProgressIndicator();
              }
              break;

            case ConnectionState.active: {
                return LinearProgressIndicator();
              }
              break;

            case ConnectionState.done: {
                double total = 0;
                for (Stock stock in snapshot.data) {
                  total += (stock.change * stock.quantity);
                }
                if (total.isNegative) {
                  return Column(
                    children: <Widget>[
                      Icon(Icons.monetization_on),
                      SizedBox(height: 8),
                      Text('You lost \$${total.abs().toStringAsFixed(2)}!'),
                    ],
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      Icon(Icons.monetization_on),
                      SizedBox(height: 8),
                      Text('You gained \$${total.abs().toStringAsFixed(2)} today!'),
                    ],
                  );
                }
              }
              break;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('')
            ],
          );


        }
      ),
    );
  }
}
class MarketReccomendedStocks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

        ],
      ),
    );
  }
}

class MarketAppBar extends StatelessWidget {
  final double amount;

  MarketAppBar({@required this.amount});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text('\$${amount.toStringAsFixed(2)}'),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})]);
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController =  TextEditingController();
  List<Map<String, dynamic>> terms = [];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration.collapsed(hintText: "Search"),
          onChanged: (value) async {
            terms = await API().search(value);
            setState((){});
          },
          controller: searchController,
        ),
      ),
      body: Center()
    );
  }
}