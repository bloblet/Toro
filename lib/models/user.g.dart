// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..username = fields[0] as String
      ..balance = fields[1] as double
      ..lastUpdatedBalance = fields[2] as DateTime
      ..balanceHistory = (fields[3] as Map)?.cast<DateTime, double>()
      ..lastUpdatedBalanceHistory = fields[4] as DateTime
      ..inventory = (fields[5] as List)?.cast<Stock>()
      ..lastUpdatedInventory = fields[6] as DateTime
      ..firebaseToken = fields[7] as String
      ..avatarURL = fields[8] as String
      ..token = fields[9] as String
      ..email = fields[10] as String
      ..investedValue = fields[11] as double
      ..totalValue = fields[12] as double;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.balance)
      ..writeByte(2)
      ..write(obj.lastUpdatedBalance)
      ..writeByte(3)
      ..write(obj.balanceHistory)
      ..writeByte(4)
      ..write(obj.lastUpdatedBalanceHistory)
      ..writeByte(5)
      ..write(obj.inventory)
      ..writeByte(6)
      ..write(obj.lastUpdatedInventory)
      ..writeByte(7)
      ..write(obj.firebaseToken)
      ..writeByte(8)
      ..write(obj.avatarURL)
      ..writeByte(9)
      ..write(obj.token)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.investedValue)
      ..writeByte(12)
      ..write(obj.totalValue);
  }
}
