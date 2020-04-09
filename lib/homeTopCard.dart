import 'package:flutter/material.dart';

class HomeTopCard extends StatelessWidget {
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
          width: MediaQuery.of(context).size.width-16,
          child: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: Text('XXX\'s Account', style: TextStyle(fontSize: 40),)), 
                Center(child: Text("\$123234434545", style: TextStyle(fontSize: 20),)),
                Center(child: Text("Day Change: \$ | %", style: TextStyle(fontSize: 14),),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}