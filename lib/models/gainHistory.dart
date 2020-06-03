import 'database.dart';
import 'package:sqflite/sqflite.dart' as s;

class GainHistory extends Database implements DataModel  {
  String day;
  double change;
  double balance;
  GainHistory({this.day, this.change, this.balance});

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'change': change,
      'balance': balance,
    };
  }

  GainHistory.fromMap(Map<String, dynamic> map) {
    this.day = map['day'];
    this.change = map['change'];
    this.balance = map['balance'];
  }

  Future<GainHistory> get() async {
    assert (day != null);

    final s.Database conn = await this.conn;

    final res = await conn.rawQuery('SELECT * FROM gainHistory WHERE day=?', [this.day]);

    if (res.length == 0) {
      throw RowDoesNotExist(day);
    }
    else {
      return GainHistory.fromMap(res[0]);
    }
  }

  Future<void> add() async {
    assert (day != null);

    final s.Database conn = await this.conn;

    await conn.rawInsert('INSERT INTO gainHistory(day, change, balance) VALUES(?, ?, ?)', [this.day, this.change, this.balance]);
  }
}