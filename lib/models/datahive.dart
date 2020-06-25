import 'dart:async';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'stock.dart';
import 'user.dart';

class DataHive {
  static final _cache = DataHive._();
  bool hasInitialized = false;
  bool hasUser = false;
  Box<User> me;

  DataHive._();

  factory DataHive() => _cache;
}
