import 'package:flutter/material.dart';
import '../models/datahive.dart';
import '../bloc/API.dart';
import 'package:hive/hive.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    if (DataHive().hasUser) {
      Navigator.popAndPushNamed(context, 'summary');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Container(), flex: 1),
          Center(
            child: Container(
              width: (size.width / 3) * 2,
              height: size.height / 3,
              child: Card(
                color: Colors.green,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    children: <Widget>[
                      TextField(),
                      SizedBox(
                        height: 16,
                        child: Center(
                          child: Divider(),
                        ),
                      ),
                      TextField(),
                      SizedBox(
                        height: 16,
                        child: Center(
                          child: Divider(),
                        ),
                      ),
                      TextField(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Container(), flex: 3),
        ],
      ),
    );
  }
}
