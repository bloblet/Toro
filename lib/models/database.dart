import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as s;

abstract class DataModel {
  Map toMap();
  
}

class Database {
  static s.Database _conn;

  Future<void> _connect() async {
    _conn ??= await s.openDatabase(
      join(await s.getDatabasesPath(), 'pymarkets.db'),
      onCreate: (db, version) async {
        await _conn.execute('CREATE TABLE GainHistory (day text PRIMARY KEY, change float, balance float);');
      },
    );
  }

  Database();

  Future<s.Database> get conn async {
    await _connect();
    return _conn;
  }
}

class RowDoesNotExist implements Exception {
  String cause;

  RowDoesNotExist(this.cause);
}