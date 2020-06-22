import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tabScaffold.dart';
import 'zoomScaffold.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      body: (zoomContext) => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            floating: true,
            snap: true,
            expandedHeight: 200,
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
            // Pretend this is a normal appbar
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // and this is like a listView
              ],
            ),
          ),
        ],
      ),
    );
  }
}
