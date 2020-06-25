import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockSimulator/models/user.dart';
import '../models/datahive.dart';
import '../bloc/API.dart';
import 'package:hive/hive.dart';

class Login extends StatelessWidget {

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
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
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
      },
    );
  }
}
