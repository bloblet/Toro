import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'stock.dart';
import 'user.dart';

class DataHive {
  static final _cache = DataHive._();
  bool hasInitialized = false;
  Stream<ConnectionState> lock;
  bool hasUser = false;

  Future<void> _init() async {
    final controller = StreamController<ConnectionState>();
    lock = controller.stream;

    controller.add(ConnectionState.active);

    final path = await getApplicationSupportDirectory();

    Hive.init(path.path);

    // Register all type adapters
    Hive.registerAdapter(StockAdapter());
    Hive.registerAdapter(UserAdapter());

    // Open boxes
    await Hive.openBox<User>('me');

    User me = Hive.box('me').get('me');

    hasUser = me != null;

    controller.add(ConnectionState.done);
    controller.close();
  }

  DataHive._() {
    _init();
  }

  
  factory DataHive() => _cache;
}
