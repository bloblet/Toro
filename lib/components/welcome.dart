import 'package:flutter/material.dart';
import 'welcome_page_button.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('assets/images/temp_logo.png'),
                      height: 120.0,
                    ),
                  ),
                ),
                Text(
                  'Stockl',
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48,
            ),
            WelcomePageButton(
              text: 'Login',
              color: Colors.green,
              onPressed: () {
                Navigator.pushNamed(context, 'loginScreen');
              },
            ),
            WelcomePageButton(
              text: 'Sign Up',
              color: Colors.green[700],
              onPressed: () {
                Navigator.pushNamed(context, 'signupScreen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
