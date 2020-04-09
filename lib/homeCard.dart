import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.black12,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height / 6,
          child: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              //children: <Widget>[Center(child: Text('Current Portfolio Value'))],
              children: <Widget>[Text('Top 3 stocks...')],
            ),
          ),
        ),
      ),
    );
  }
}
