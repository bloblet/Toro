import 'package:flutter/material.dart';

class HomeTopCard extends StatelessWidget {
  final List<Widget> children;

  HomeTopCard(this.children);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.blueGrey[100],
        ),
        child: Container(
          height: MediaQuery.of(context).size.height / 7 - 8,
          width: MediaQuery.of(context).size.width / 2 - 24,
          child: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: this.children
            ),
          ),
        ),
      ),
    );
  }
}
