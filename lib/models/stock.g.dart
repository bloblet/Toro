// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockAdapter extends TypeAdapter<Stock> {
  @override
  final typeId = 1;

  @override
  Stock read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stock()
      ..change = fields[0] as double
      ..changesPercentage = fields[1] as double
      ..dayHigh = fields[2] as double
      ..dayLow = fields[3] as double
      ..exchange = fields[4] as String
      ..name = fields[5] as String
      ..open = fields[6] as double
      ..price = fields[7] as double
      ..symbol = fields[8] as String
      ..quantity = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, Stock obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.change)
      ..writeByte(1)
      ..write(obj.changesPercentage)
      ..writeByte(2)
      ..write(obj.dayHigh)
      ..writeByte(3)
      ..write(obj.dayLow)
      ..writeByte(4)
      ..write(obj.exchange)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.open)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.symbol)
      ..writeByte(9)
      ..write(obj.quantity);
  }
}
