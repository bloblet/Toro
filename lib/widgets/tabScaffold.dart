import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stockSimulator/widgets/market.dart';

import 'menuPage.dart';
import 'portfoliov2.dart';
import 'zoomScaffold.dart';

class TabScaffold extends StatefulWidget {
  final Widget Function(BuildContext) body;
  final Widget appBar;
  final Widget fab;

  TabScaffold({
    this.fab,
    @required this.body,
    this.appBar,
  });

  @override
  _TabScaffoldState createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold>
    with TickerProviderStateMixin {
  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
      builder: (_, child) => child,
      value: menuController,
      child: ZoomScaffold(
        menuScreen: MenuScreen(),
        contentScreen: Layout(
          
          contentBuilder: widget.body,
        ),
      ),
    );
  }
}
