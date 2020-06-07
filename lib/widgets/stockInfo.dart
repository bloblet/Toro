import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:provider/provider.dart';
import '../models/stock.dart';

import 'fadeOnScroll.dart';
import 'tabScaffold.dart';
import 'zoomScaffold.dart';

class AnimatedStar extends StatefulWidget {
  @override
  _AnimatedStarState createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<AnimatedStar>
    with TickerProviderStateMixin {
  AnimationController controller;
  SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 1, end: 0.7),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 100),
          curve: Curves.easeInOutExpo,
          tag: 'shrink',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0.7, end: 1.4),
          from: const Duration(milliseconds: 100),
          to: const Duration(milliseconds: 150),
          curve: Curves.easeInOutExpo,
          tag: 'scale',
        )
        .addAnimatable(
            animatable: Tween<Color>(begin: Colors.grey, end: Colors.amber),
            from: const Duration(milliseconds: 100),
            to: const Duration(milliseconds: 200),
            tag: '',
            curve: Curves.elasticOut)
        .addAnimatable(
          animatable: Tween<double>(begin: 1.4, end: 1),
          from: const Duration(milliseconds: 150),
          to: const Duration(milliseconds: 250),
          curve: Curves.slowMiddle,
          tag: 'shrink',
        )
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.star_border,
        color: Colors.grey,
      ),
      onPressed: () async {
        controller.forward();

        // TODO Add to the watchlist in the db...
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to watch list'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Remove',
              onPressed: () {
                // TODO Remove
                Scaffold.of(context).removeCurrentSnackBar();
                controller.reverse();
              },
            ),
          ),
        );
      },
    );
  }
}

class StockInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Stock stock = ModalRoute.of(context).settings.arguments;

    return TabScaffold(
      body: (zoomContext) => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            floating: true,
            expandedHeight: 200,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                Icons.share,
                color: Colors.black,
              )),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () =>
                  Provider.of<MenuController>(zoomContext, listen: false)
                    ..toggle(),
            ),
            title: Text(stock.name, style: TextStyle(fontSize: 25)),
            flexibleSpace: FadeOnScroll(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.attach_money),
                  SizedBox(
                    height: 16,
                  ),
                  Text('\$${stock.price.toStringAsFixed(2)} USD'),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[],
            ),
          ),
        ],
      ),
    );
  }
}
