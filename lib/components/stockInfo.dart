import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:provider/provider.dart';
import 'package:toro_models/toro_models.dart';

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
  bool isInWatchList = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250))
          ..addListener(() {
            setState(() {});
          });
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 1, end: 0.7),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 100),
          curve: Curves.easeInOutExpo,
          tag: 'scale',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0.7, end: 1.4),
          from: const Duration(milliseconds: 100),
          to: const Duration(milliseconds: 150),
          curve: Curves.easeInOutExpo,
          tag: 'scale',
        )
        .addAnimatable(
            animatable: ColorTween(begin: Colors.grey[800], end: Colors.amber),
            from: const Duration(milliseconds: 100),
            to: const Duration(milliseconds: 200),
            tag: 'color',
            curve: Curves.elasticOut)
        .addAnimatable(
          animatable: Tween<double>(begin: 1.4, end: 1),
          from: const Duration(milliseconds: 150),
          to: const Duration(milliseconds: 250),
          curve: Curves.slowMiddle,
          tag: 'scale',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 1),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 250),
          curve: Curves.easeIn,
          tag: 'opacity',
        )
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: sequenceAnimation['scale'].value,
      child: IconButton(
        icon: Stack(children: [
          Opacity(
            opacity: 1 - sequenceAnimation['opacity'].value,
            child: Icon(
              Icons.star_border,
              color: sequenceAnimation['color'].value,
            ),
          ),
          Opacity(
            opacity: sequenceAnimation['opacity'].value,
            child: Icon(
              Icons.star,
              color: sequenceAnimation['color'].value,
            ),
          ),
        ]),
        onPressed: () async {
          // await for (Stock s in DatabaseValues().watchList) {
          //   print(s);
          // }
          if (isInWatchList) {
            isInWatchList = false;
            controller.reverse();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed from watch list'),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // TODO Remove
                    Scaffold.of(context).removeCurrentSnackBar();
                    controller.reverse();
                  },
                ),
              ),
            );
          } else {
            isInWatchList = true;
            controller.forward();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Added to watch list'),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // TODO Remove
                    Scaffold.of(context).removeCurrentSnackBar();
                    controller.reverse();
                  },
                ),
              ),
            );
          }
        },
      ),
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: Colors.black,
                  )),
              AnimatedStar()
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
