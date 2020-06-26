import 'package:flutter/material.dart';

class FadeOnScroll extends StatefulWidget {
  final Widget child;
  FadeOnScroll({@required this.child});

  @override
  _FadeOnScrollState createState() => _FadeOnScrollState();
}

class _FadeOnScrollState extends State<FadeOnScroll> {
  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        top = constraints.biggest.height;
        return FlexibleSpaceBar(
          centerTitle: true,
          title: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: (150 >= top) ? 0.0 : 1,
            child: widget.child,
          ),
        );
      },
    );
  }
}
