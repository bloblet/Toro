import 'package:flutter/material.dart';
import '../models/datahive.dart';

class EnsureHiveInitialized extends StatefulWidget {
  final Widget child;
  final Widget loader;
  EnsureHiveInitialized({@required this.child, @required this.loader, Key key}) : super(key: key);

  @override
  _EnsureHiveInitializedState createState() => _EnsureHiveInitializedState();
}

class _EnsureHiveInitializedState extends State<EnsureHiveInitialized> {
  @override
  void initState() {
    DataHive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataHive().lock,
      builder: (context, snapshot) {
        if (snapshot.data == ConnectionState.done) {
          return widget.child;
        }
        return widget.loader;
      },
    );
  }
}
