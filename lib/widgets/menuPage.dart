import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockSimulator/widgets/stockSimIcons.dart';

import 'zoomScaffold.dart';

class CircularImage extends StatelessWidget {
  final double _width, _height;
  final ImageProvider image;

  CircularImage(this.image, {double width = 40, double height = 40})
      : _width = width,
        _height = height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: image),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black45,
            )
          ]),
    );
  }
}

class MenuScreen extends StatelessWidget {
  final String imageUrl =
      "https://scontent-ort2-2.xx.fbcdn.net/v/t1.0-9/1915547_202232795153_5948859_n.jpg?_nc_cat=104&_nc_sid=e007fa&_nc_ohc=5kx_BQ11ZwkAX8mSZQr&_nc_ht=scontent-ort2-2.xx&oh=53d4028f6c3eb6d2791aede4bc494abe&oe=5F00BB26";

  final List<MenuItem> options = [
    MenuItem(Icons.assessment, 'Summary', 'summary'),
    MenuItem(StockSimIcons.layer_group, 'Portfolio', 'portfolio'),
    MenuItem(Icons.trending_up, 'Market', 'market'),
    MenuItem(Icons.search, 'Discover', 'search'),
    MenuItem(Icons.bookmark, 'News', 'news'),
    MenuItem(Icons.group, 'Friends', 'friends'),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MenuController>(context, listen: false).toggle();
        }
      },
      child: Container(
        padding: EdgeInsets.only(
            top: 62,
            left: 32,
            bottom: 8,
            right: MediaQuery.of(context).size.width / 2.9),
        // color: Color(0xff454dff),
        // color: Color(0xffAF4CABff),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(175, 76, 171, 1),
              Color.fromRGBO(204, 103, 199, 1),
              Color.fromRGBO(233, 130, 227, 1),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircularImage(NetworkImage(imageUrl)),
                ),
                Text(
                  'RickA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              children: options.map(
                (item) {
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, item.routeName);
                    },
                    title: Text(
                      item.title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  );
                },
              ).toList(),
            ),
            Spacer(),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.settings,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.headset_mic,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                'Support',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;
  String routeName;

  MenuItem(this.icon, this.title, this.routeName);
}