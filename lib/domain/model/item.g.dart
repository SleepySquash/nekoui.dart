// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CupcakeItemAdapter extends TypeAdapter<CupcakeItem> {
  @override
  final int typeId = 5;

  @override
  CupcakeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CupcakeItem(
      fields[0] as RxInt,
    );
  }

  @override
  void write(BinaryWriter writer, CupcakeItem obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CupcakeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WaterBottleItemAdapter extends TypeAdapter<WaterBottleItem> {
  @override
  final int typeId = 15;

  @override
  WaterBottleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterBottleItem(
      fields[0] as RxInt,
    );
  }

  @override
  void write(BinaryWriter writer, WaterBottleItem obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterBottleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
