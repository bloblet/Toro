import 'package:flutter/material.dart';

class WelcomePageButton extends StatelessWidget {
  final Color color;
  final Function onPressed;
  final String text;

  WelcomePageButton({@required this.text, @required this.color,@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.all(Radius.zero),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}