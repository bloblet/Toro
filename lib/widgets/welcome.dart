import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockSimulator/models/user.dart';
import '../models/datahive.dart';
import '../bloc/API.dart';
import 'package:hive/hive.dart';
import 'package:stockSimulator/components/welcome_page_button.dart';

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
    final size = MediaQuery.of(context).size;

    return FutureProvider.value(
      value: Future.value(true),
      // value: DataHive().init(),
      initialData: false,
      builder: (context, child) {
        if (!Provider.of<bool>(context)) {
          return Center(
            child: Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (DataHive().hasUser) {
          Navigator.popAndPushNamed(context, 'summary');
        }
        return Scaffold(
          backgroundColor: animation.value,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/temp_logo.png'),
                        height: 120.0,
                      ),
                    ),
                    Text(
                      'StockSim',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48,),
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
      },
    );
  }
}
